import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../budgets/domain/entities/budget_entity.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../consumption/domain/entities/consumption_entities.dart';
import '../../../notifications/domain/entities/notification_entity.dart';
import '../../../notifications/domain/services/notification_service.dart';
import '../../../predictions/domain/entities/prediction_entity.dart';
import '../../../predictions/domain/services/prediction_engine.dart';
import '../../../wallet/domain/entities/wallet_entities.dart';
import '../../domain/entities/household.dart';
import '../../domain/entities/household_member.dart';
import '../services/firestore_ledger_sync.dart';

class HouseholdLedgerRepository {
  final FirestoreLedgerSyncService _firestoreSync;
  final PredictionEngine _predictionEngine;
  final NotificationAlertEvaluator _alertEvaluator;
  final _uuid = const Uuid();
  String? _activeUserId;

  // Isolated per-household stores
  final Map<String, Household> _households = {};
  final Map<String, List<HouseholdMember>> _membersByHousehold = {};
  final Map<String, List<ExpenseCategory>> _categoriesByHousehold = {};
  final Map<String, HouseholdWallet> _walletsByHousehold = {};
  final Map<String, List<Contribution>> _contributionsByHousehold = {};
  final Map<String, List<Expense>> _expensesByHousehold = {};
  final Map<String, List<WalletTransaction>> _transactionsByHousehold = {};
  final Map<String, List<HouseholdBudget>> _budgetsByHousehold = {};
  final Map<String, List<TrackedSupply>> _suppliesByHousehold = {};
  final Map<String, List<ConsumptionRecord>> _consumptionByHousehold = {};
  final Map<String, Map<String, SupplyPrediction>> _predictionsByHousehold = {};
  final Map<String, List<RecurringBill>> _billsByHousehold = {};
  final Map<String, List<HouseholdNotification>> _notificationsByHousehold = {};
  final Map<String, List<AuditLogEntry>> _auditLogsByHousehold = {};
  final Set<String> _processedIdempotencyKeys = {};
  bool _isSeeding = false;
  static const String _localStoragePrefix = 'nyumbasmart_ledger_snapshot_v2_';

  String get _localStorageKey =>
      '$_localStoragePrefix${_activeUserId ?? 'local'}';

  HouseholdLedgerRepository({
    FirestoreLedgerSyncService? firestoreSync,
    PredictionEngine predictionEngine = const PredictionEngine(),
    NotificationAlertEvaluator alertEvaluator =
        const NotificationAlertEvaluator(),
    bool initializeDemoSeed = false,
  })  : _firestoreSync = firestoreSync ?? const FirestoreLedgerSyncService(),
        _predictionEngine = predictionEngine,
        _alertEvaluator = alertEvaluator {
    if (initializeDemoSeed) {
      _isSeeding = true;
      _seedInitialTanzanianHouseholds();
      _isSeeding = false;
    }
  }

  Future<void> _syncRemote(Future<void> Function() op) async {
    try {
      await op().timeout(const Duration(seconds: 4));
    } on TimeoutException {
      // Firestore offline persistence keeps queued writes locally until online.
    } catch (_) {
      // Offline or transient errors continue with local persistence.
    }
  }

  /// Synchronizes the signed-in user's households and ledger data from Cloud Firestore
  /// (falling back to the user's scoped on-device cache when offline).
  Future<void> syncForUser(String userId) async {
    if (userId.isEmpty) return;
    if (_activeUserId != userId) {
      _clearMaps();
      _activeUserId = userId;
      await restoreFromLocalStorage(userId: userId);
    }

    if (!_firestoreSync.isAvailable) return;
    try {
      final bundle = await _firestoreSync
          .fetchAllForUser(userId)
          .timeout(const Duration(seconds: 8));
      if (bundle == null) return;

      _clearMaps();
      _households.addAll(bundle.households);
      _walletsByHousehold.addAll(bundle.wallets);
      _membersByHousehold.addAll(bundle.members);
      _categoriesByHousehold.addAll(bundle.categories);
      _contributionsByHousehold.addAll(bundle.contributions);
      _expensesByHousehold.addAll(bundle.expenses);
      _transactionsByHousehold.addAll(bundle.transactions);
      _budgetsByHousehold.addAll(bundle.budgets);
      _suppliesByHousehold.addAll(bundle.supplies);
      _consumptionByHousehold.addAll(bundle.consumption);
      _predictionsByHousehold.addAll(bundle.predictions);
      _billsByHousehold.addAll(bundle.bills);
      _notificationsByHousehold.addAll(bundle.notifications);
      _auditLogsByHousehold.addAll(bundle.auditLogs);

      for (final hId in _households.keys) {
        _refreshHouseholdAlerts(hId);
      }
      await _persistSnapshot();
    } catch (_) {
      // Keep local/cached state if offline or timed out.
    }
  }

  void clearSessionData() {
    _activeUserId = null;
    _clearMaps();
  }

  void _clearMaps() {
    _households.clear();
    _membersByHousehold.clear();
    _categoriesByHousehold.clear();
    _walletsByHousehold.clear();
    _contributionsByHousehold.clear();
    _expensesByHousehold.clear();
    _transactionsByHousehold.clear();
    _budgetsByHousehold.clear();
    _suppliesByHousehold.clear();
    _consumptionByHousehold.clear();
    _predictionsByHousehold.clear();
    _billsByHousehold.clear();
    _notificationsByHousehold.clear();
    _auditLogsByHousehold.clear();
    _processedIdempotencyKeys.clear();
  }

  // ---------------------------------------------------------------------------
  // ACCESS CONTROL & AUTHORIZATION GUARDS
  // ---------------------------------------------------------------------------

  void verifyReadAccess({
    required String householdId,
    required String actorUserId,
  }) {
    final household = _households[householdId];
    if (household == null) {
      throw const UnauthorizedHouseholdAccessException(
        'Household not found.',
      );
    }
    if (household.ownerId == actorUserId) return;

    final members = _membersByHousehold[householdId] ?? const [];
    final isLinkedMember = members.any(
      (m) => m.linkedUserId == actorUserId && m.isActive,
    );
    if (!isLinkedMember) {
      throw const UnauthorizedHouseholdAccessException();
    }
  }

  void verifyAdminWriteAccess({
    required String householdId,
    required String actorUserId,
  }) {
    final household = _households[householdId];
    if (household == null) {
      throw const UnauthorizedHouseholdAccessException(
        'Household not found.',
      );
    }
    if (household.ownerId == actorUserId) return;

    // Check if actor is a read-only member of this household
    final members = _membersByHousehold[householdId] ?? const [];
    final memberRecord = members
        .where((m) => m.linkedUserId == actorUserId && m.isActive)
        .firstOrNull;
    if (memberRecord != null && memberRecord.isReadOnlyMember) {
      throw const ReadOnlyMemberRestrictionException();
    }

    throw const UnauthorizedHouseholdAccessException();
  }

  // ---------------------------------------------------------------------------
  // HOUSEHOLD MANAGEMENT (PHASE 2)
  // ---------------------------------------------------------------------------

  List<Household> getHouseholdsForUser(String userId) {
    return _households.values.where((h) {
      if (h.isArchived) return false;
      if (h.ownerId == userId) return true;
      final members = _membersByHousehold[h.id] ?? const [];
      return members.any((m) => m.linkedUserId == userId && m.isActive);
    }).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Household getHouseholdById({
    required String householdId,
    required String actorUserId,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    return _households[householdId]!;
  }

  Future<Household> createHousehold({
    required String ownerId,
    required String adminDisplayName,
    required String name,
    String? description,
    String? address,
    String currencyCode = 'TZS',
    String currencySymbol = 'TSh',
    double lowBalanceThreshold = 25000.0,
  }) async {
    if (name.trim().length < 2) {
      throw const ValidationException(
        'Household name must be at least 2 characters.',
      );
    }

    _activeUserId ??= ownerId;
    final householdId = _uuid.v4();

    final household = Household(
      id: householdId,
      ownerId: ownerId,
      name: name.trim(),
      description: description?.trim(),
      address: address?.trim(),
      currencyCode: currencyCode,
      currencySymbol: currencySymbol,
      lowBalanceThreshold: lowBalanceThreshold,
      createdAt: DateTime.now(),
    );

    final wallet = HouseholdWallet(
      id: 'wallet-$householdId',
      householdId: householdId,
      totalContributions: 0.0,
      totalExpenses: 0.0,
      totalAdjustments: 0.0,
      availableBalance: 0.0,
    );
    final members = [
      HouseholdMember(
        id: 'member-admin-$householdId',
        householdId: householdId,
        linkedUserId: ownerId,
        displayName: adminDisplayName.trim(),
        role: HouseholdRole.admin,
        avatarColor: '#3B82F6',
        joinedAt: DateTime.now(),
      ),
    ];
    final categories =
        ExpenseCategory.createDefaultCategoriesForHousehold(householdId);
    final supplies = TrackedSupply.createDefaultsForHousehold(householdId);
    final predictions = <String, SupplyPrediction>{
      for (final s in supplies)
        s.id: _predictionEngine.computePrediction(supply: s, records: const []),
    };

    _households[householdId] = household;
    _walletsByHousehold[householdId] = wallet;
    _membersByHousehold[householdId] = members;
    _categoriesByHousehold[householdId] = categories;
    _suppliesByHousehold[householdId] = supplies;
    _contributionsByHousehold[householdId] = [];
    _expensesByHousehold[householdId] = [];
    _transactionsByHousehold[householdId] = [];
    _budgetsByHousehold[householdId] = [];
    _consumptionByHousehold[householdId] = [];
    _billsByHousehold[householdId] = [];
    _notificationsByHousehold[householdId] = [];
    _auditLogsByHousehold[householdId] = [];
    _predictionsByHousehold[householdId] = predictions;

    await _syncRemote(
      () => _firestoreSync.saveNewHousehold(
        household: household,
        wallet: wallet,
        members: members,
        categories: categories,
        supplies: supplies,
        predictions: predictions,
      ),
    );
    await _persistSnapshot();
    return household;
  }

  Future<Household> updateHousehold({
    required String householdId,
    required String actorUserId,
    required String name,
    String? description,
    String? address,
    String? currencyCode,
    String? currencySymbol,
    double? lowBalanceThreshold,
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);
    if (name.trim().length < 2) {
      throw const ValidationException(
        'Household name must be at least 2 characters.',
      );
    }
    final existing = _households[householdId]!;
    final updated = existing.copyWith(
      name: name.trim(),
      description: description?.trim(),
      address: address?.trim(),
      currencyCode: currencyCode,
      currencySymbol: currencySymbol,
      lowBalanceThreshold: lowBalanceThreshold,
    );
    _households[householdId] = updated;
    await _syncRemote(
      () => _firestoreSync.updateHousehold(
        updated,
        _membersByHousehold[householdId] ?? const [],
      ),
    );
    await _persistSnapshot();
    return updated;
  }

  /// Deletes a household and all of its associated wallet, member, transaction,
  /// and supply records.
  Future<void> deleteHousehold({
    required String householdId,
    required String actorUserId,
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);
    await _syncRemote(() => _firestoreSync.deleteHousehold(householdId));
    _households.remove(householdId);
    _walletsByHousehold.remove(householdId);
    _membersByHousehold.remove(householdId);
    _categoriesByHousehold.remove(householdId);
    _suppliesByHousehold.remove(householdId);
    _contributionsByHousehold.remove(householdId);
    _expensesByHousehold.remove(householdId);
    _transactionsByHousehold.remove(householdId);
    _budgetsByHousehold.remove(householdId);
    _consumptionByHousehold.remove(householdId);
    _billsByHousehold.remove(householdId);
    _notificationsByHousehold.remove(householdId);
    _auditLogsByHousehold.remove(householdId);
    _predictionsByHousehold.remove(householdId);
    await _persistSnapshot();
  }

  // ---------------------------------------------------------------------------
  // HOUSEHOLD MEMBERS MANAGEMENT
  // ---------------------------------------------------------------------------

  List<HouseholdMember> getMembers({
    required String householdId,
    required String actorUserId,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    return List.unmodifiable(_membersByHousehold[householdId] ?? const []);
  }

  Future<HouseholdMember> addMember({
    required String householdId,
    required String actorUserId,
    required String displayName,
    String? email,
    String? phoneNumber,
    String? linkedUserId,
    HouseholdRole role = HouseholdRole.member,
    String avatarColor = '#10B981',
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);
    final trimmedName = displayName.trim();
    if (trimmedName.isEmpty) {
      throw const ValidationException('Member name cannot be empty.');
    }

    final existingMembers = _membersByHousehold[householdId] ?? [];
    final duplicate = existingMembers.any(
      (m) => m.displayName.toLowerCase() == trimmedName.toLowerCase(),
    );
    if (duplicate) {
      throw const ValidationException(
        'A member with this name already exists in this household.',
      );
    }

    final member = HouseholdMember(
      id: _uuid.v4(),
      householdId: householdId,
      linkedUserId: linkedUserId,
      displayName: trimmedName,
      email: email?.trim(),
      phoneNumber: phoneNumber?.trim(),
      role: role,
      avatarColor: avatarColor,
      joinedAt: DateTime.now(),
    );
    _membersByHousehold[householdId] = [...existingMembers, member];
    await _syncRemote(() => _firestoreSync.upsertMember(member, isCreate: true));
    _persistSnapshot();
    return member;
  }

  /// Removes (deletes) a contributor/member from the household.
  Future<void> removeMember({
    required String householdId,
    required String actorUserId,
    required String memberId,
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);
    final existingMembers = _membersByHousehold[householdId] ?? [];
    final target = existingMembers.where((m) => m.id == memberId).firstOrNull;
    if (target == null) {
      throw const ValidationException('Member not found in this household.');
    }
    if (target.isAdmin &&
        target.linkedUserId == _households[householdId]?.ownerId) {
      throw const ValidationException(
        'Cannot delete the primary household administrator.',
      );
    }

    _membersByHousehold[householdId] =
        existingMembers.where((m) => m.id != memberId).toList();

    final auditEntry = AuditLogEntry(
      id: _uuid.v4(),
      householdId: householdId,
      actorUserId: actorUserId,
      entityType: 'member',
      entityId: memberId,
      action: 'delete',
      reason: 'Removed household contributor "${target.displayName}"',
      previousState: {'display_name': target.displayName},
      createdAt: DateTime.now(),
    );
    _auditLogsByHousehold[householdId] = [
      ...(_auditLogsByHousehold[householdId] ?? const []),
      auditEntry,
    ];
    await _syncRemote(
      () => _firestoreSync.deleteMember(
        householdId,
        memberId,
        auditLog: auditEntry,
      ),
    );
    _persistSnapshot();
  }

  /// Clears demo/historical transactions and resets the household balance to 0
  /// so the administrator can start fresh with real household data.
  Future<void> clearHouseholdDemoData({
    required String householdId,
    required String actorUserId,
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);
    final wallet = _walletsByHousehold[householdId];
    if (wallet != null) {
      _walletsByHousehold[householdId] = wallet.copyWith(
        totalContributions: 0.0,
        totalExpenses: 0.0,
        totalAdjustments: 0.0,
        availableBalance: 0.0,
        version: wallet.version + 1,
      );
    }
    _contributionsByHousehold[householdId] = [];
    _expensesByHousehold[householdId] = [];
    _transactionsByHousehold[householdId] = [];
    _consumptionByHousehold[householdId] = [];
    _notificationsByHousehold[householdId] = [];
    final supplies = _suppliesByHousehold[householdId] ?? const [];
    _predictionsByHousehold[householdId] = {
      for (final s in supplies)
        s.id: _predictionEngine.computePrediction(supply: s, records: const []),
    };
    _persistSnapshot();
  }

  /// Resolves an existing member by written name (case-insensitive) or creates
  /// a new household member record automatically when the administrator types a name.
  Future<HouseholdMember> resolveOrCreateMemberByName({
    required String householdId,
    required String actorUserId,
    required String writtenName,
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);
    final trimmed = writtenName.trim();
    if (trimmed.isEmpty) {
      throw const ValidationException('Please write the member name.');
    }

    final existingMembers = _membersByHousehold[householdId] ?? [];
    final match = existingMembers
        .where((m) => m.displayName.toLowerCase() == trimmed.toLowerCase())
        .firstOrNull;
    if (match != null) {
      return match;
    }

    return addMember(
      householdId: householdId,
      actorUserId: actorUserId,
      displayName: trimmed,
    );
  }

  // ---------------------------------------------------------------------------
  // EXPENSE CATEGORIES MANAGEMENT (PHASE 3 / SECTION 7)
  // ---------------------------------------------------------------------------

  List<ExpenseCategory> getCategories({
    required String householdId,
    required String actorUserId,
    bool activeOnly = false,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    final list = _categoriesByHousehold[householdId] ?? const [];
    if (activeOnly) {
      return list.where((c) => c.isActive).toList();
    }
    return List.unmodifiable(list);
  }

  Future<ExpenseCategory> createCustomCategory({
    required String householdId,
    required String actorUserId,
    required String name,
    String iconName = 'category',
    String colorHex = '#3B82F6',
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);
    final trimmed = name.trim();
    if (trimmed.length < 2) {
      throw const ValidationException(
        'Category name must be at least 2 characters.',
      );
    }
    final slug = trimmed.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    final existing = _categoriesByHousehold[householdId] ?? [];
    if (existing.any((c) => c.slug == slug)) {
      throw const ValidationException('Category already exists.');
    }

    final category = ExpenseCategory(
      id: _uuid.v4(),
      householdId: householdId,
      name: trimmed,
      slug: slug,
      iconName: iconName,
      colorHex: colorHex,
      isDefault: false,
      isActive: true,
    );
    _categoriesByHousehold[householdId] = [...existing, category];
    await _syncRemote(
      () => _firestoreSync.upsertCategory(category, isCreate: true),
    );
    _persistSnapshot();
    return category;
  }

  Future<ExpenseCategory> updateCategory({
    required String householdId,
    required String actorUserId,
    required String categoryId,
    String? newName,
    bool? isActive,
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);
    final list = List<ExpenseCategory>.from(
      _categoriesByHousehold[householdId] ?? const [],
    );
    final idx = list.indexWhere((c) => c.id == categoryId);
    if (idx == -1) {
      throw const ValidationException('Category not found.');
    }
    final updated = list[idx].copyWith(
      name: newName?.trim(),
      isActive: isActive,
    );
    list[idx] = updated;
    _categoriesByHousehold[householdId] = list;
    await _syncRemote(
      () => _firestoreSync.upsertCategory(updated, isCreate: false),
    );
    _persistSnapshot();
    return updated;
  }

  // ---------------------------------------------------------------------------
  // WALLET, CONTRIBUTIONS, EXPENSES & AUDIT-LOGGED CORRECTIONS (PHASE 3)
  // ---------------------------------------------------------------------------

  HouseholdWallet getWallet({
    required String householdId,
    required String actorUserId,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    return _walletsByHousehold[householdId]!;
  }

  List<Contribution> getContributions({
    required String householdId,
    required String actorUserId,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    final list = List<Contribution>.from(
      _contributionsByHousehold[householdId] ?? const [],
    )..sort((a, b) => b.contributionDate.compareTo(a.contributionDate));
    return list;
  }

  List<Expense> getExpenses({
    required String householdId,
    required String actorUserId,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    final list = List<Expense>.from(
      _expensesByHousehold[householdId] ?? const [],
    )..sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
    return list;
  }

  List<WalletTransaction> getWalletTransactions({
    required String householdId,
    required String actorUserId,
    DateTime? startDate,
    DateTime? endDate,
    String? memberId,
    String? categoryId,
    WalletTransactionType? transactionType,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    final all = _transactionsByHousehold[householdId] ?? const [];
    final filtered = all.where((tx) {
      if (startDate != null && tx.transactionDate.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && tx.transactionDate.isAfter(endDate)) {
        return false;
      }
      if (memberId != null &&
          memberId.isNotEmpty &&
          tx.memberId != memberId) {
        return false;
      }
      if (categoryId != null &&
          categoryId.isNotEmpty &&
          tx.categoryId != categoryId) {
        return false;
      }
      if (transactionType != null && tx.transactionType != transactionType) {
        return false;
      }
      return true;
    }).toList()
      ..sort((a, b) {
        final cmp = b.transactionDate.compareTo(a.transactionDate);
        if (cmp != 0) return cmp;
        return b.createdAt.compareTo(a.createdAt);
      });
    return filtered;
  }

  List<AuditLogEntry> getAuditLogs({
    required String householdId,
    required String actorUserId,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    final logs = List<AuditLogEntry>.from(
      _auditLogsByHousehold[householdId] ?? const [],
    )..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return logs;
  }

  /// Atomically records an unequal or equal member contribution and updates the shared household wallet.
  Future<Contribution> recordContribution({
    required String householdId,
    required String actorUserId,
    required String memberId,
    required double amount,
    required DateTime contributionDate,
    String? description,
    String? idempotencyKey,
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);

    if (amount <= 0) {
      throw const ValidationException(
        'Contribution amount must be greater than zero.',
      );
    }

    final idemKey = idempotencyKey ?? _uuid.v4();
    final scopedKey = '$householdId:$idemKey';
    if (_processedIdempotencyKeys.contains(scopedKey)) {
      throw const DuplicateTransactionException();
    }

    final members = _membersByHousehold[householdId] ?? const [];
    final member = members.where((m) => m.id == memberId).firstOrNull;
    if (member == null) {
      throw const ValidationException(
        'Selected member does not belong to this household.',
      );
    }

    _processedIdempotencyKeys.add(scopedKey);

    final wallet = _walletsByHousehold[householdId]!;
    final balanceBefore = wallet.availableBalance;
    final newContributions = wallet.totalContributions + amount;
    final balanceAfter =
        newContributions - wallet.totalExpenses + wallet.totalAdjustments;

    final contribution = Contribution(
      id: _uuid.v4(),
      householdId: householdId,
      memberId: member.id,
      memberName: member.displayName,
      recordedBy: actorUserId,
      amount: amount,
      contributionDate: contributionDate,
      description: description?.trim(),
      idempotencyKey: idemKey,
      createdAt: DateTime.now(),
    );

    _contributionsByHousehold[householdId] = [
      ...(_contributionsByHousehold[householdId] ?? const []),
      contribution,
    ];

    final updatedWallet = wallet.copyWith(
      totalContributions: newContributions,
      availableBalance: balanceAfter,
      version: wallet.version + 1,
      lastTransactionAt: DateTime.now(),
    );
    _walletsByHousehold[householdId] = updatedWallet;

    final walletTx = WalletTransaction(
      id: _uuid.v4(),
      householdId: householdId,
      walletId: wallet.id,
      transactionType: WalletTransactionType.contribution,
      referenceContributionId: contribution.id,
      memberId: member.id,
      memberName: member.displayName,
      categoryName: 'Contribution',
      amount: amount,
      signedAmount: amount,
      balanceBefore: balanceBefore,
      balanceAfter: balanceAfter,
      transactionDate: contributionDate,
      description: (description?.trim().isNotEmpty == true)
          ? description!.trim()
          : 'Contribution by ${member.displayName}',
      recordedBy: actorUserId,
      createdAt: DateTime.now(),
    );

    _transactionsByHousehold[householdId] = [
      ...(_transactionsByHousehold[householdId] ?? const []),
      walletTx,
    ];

    _auditLogsByHousehold[householdId] = [
      ...(_auditLogsByHousehold[householdId] ?? const []),
      AuditLogEntry(
        id: _uuid.v4(),
        householdId: householdId,
        actorUserId: actorUserId,
        entityType: 'contribution',
        entityId: contribution.id,
        action: 'create',
        reason: 'Member contribution recorded',
        newState: {
          'member': member.displayName,
          'amount': amount,
          'balance_before': balanceBefore,
          'balance_after': balanceAfter,
        },
        createdAt: DateTime.now(),
      ),
    ];

    await _syncRemote(
      () => _firestoreSync.saveContributionBundle(
        contribution: contribution,
        updatedWallet: updatedWallet,
        transaction: walletTx,
      ),
    );
    _refreshHouseholdAlerts(householdId);
    _persistSnapshot();
    return contribution;
  }

  /// Atomically records a household expense, validating that the wallet has sufficient balance.
  /// When [autoTrackSupply] is true, automatically logs a consumption record and updates
  /// replenishment predictions if the expense matches Electricity, Gas, Water, or a tracked Grocery item.
  Future<Expense> recordExpense({
    required String householdId,
    required String actorUserId,
    required String categoryId,
    required String paidByMemberId,
    required String title,
    required double amount,
    required DateTime expenseDate,
    String? notes,
    String? receiptUrl,
    String? idempotencyKey,
    bool autoTrackSupply = true,
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);

    if (title.trim().length < 2) {
      throw const ValidationException(
        'Expense title must be at least 2 characters.',
      );
    }
    if (amount <= 0) {
      throw const ValidationException(
        'Expense amount must be greater than zero.',
      );
    }

    final idemKey = idempotencyKey ?? _uuid.v4();
    final scopedKey = '$householdId:$idemKey';
    if (_processedIdempotencyKeys.contains(scopedKey)) {
      throw const DuplicateTransactionException();
    }

    final household = _households[householdId]!;
    final wallet = _walletsByHousehold[householdId]!;

    // STRICT NON-NEGATIVE WALLET INVARIANT
    if (wallet.availableBalance < amount && !household.allowOverdraft) {
      throw InsufficientBalanceException(
        availableBalance: wallet.availableBalance,
        requestedAmount: amount,
        currencySymbol: household.currencySymbol,
      );
    }

    final members = _membersByHousehold[householdId] ?? const [];
    final member = members.where((m) => m.id == paidByMemberId).firstOrNull;
    if (member == null) {
      throw const ValidationException(
        'Selected member does not belong to this household.',
      );
    }

    final categories = _categoriesByHousehold[householdId] ?? const [];
    final category = categories.where((c) => c.id == categoryId).firstOrNull;
    if (category == null) {
      throw const ValidationException(
        'Selected category does not belong to this household.',
      );
    }

    _processedIdempotencyKeys.add(scopedKey);

    final balanceBefore = wallet.availableBalance;
    final newExpenses = wallet.totalExpenses + amount;
    final balanceAfter =
        wallet.totalContributions - newExpenses + wallet.totalAdjustments;

    final expense = Expense(
      id: _uuid.v4(),
      householdId: householdId,
      categoryId: category.id,
      categoryName: category.name,
      paidByMemberId: member.id,
      paidByMemberName: member.displayName,
      recordedBy: actorUserId,
      title: title.trim(),
      amount: amount,
      expenseDate: expenseDate,
      notes: notes?.trim(),
      receiptUrl: receiptUrl,
      idempotencyKey: idemKey,
      createdAt: DateTime.now(),
    );

    _expensesByHousehold[householdId] = [
      ...(_expensesByHousehold[householdId] ?? const []),
      expense,
    ];

    final updatedWallet = wallet.copyWith(
      totalExpenses: newExpenses,
      availableBalance: balanceAfter,
      version: wallet.version + 1,
      lastTransactionAt: DateTime.now(),
    );
    _walletsByHousehold[householdId] = updatedWallet;

    final walletTx = WalletTransaction(
      id: _uuid.v4(),
      householdId: householdId,
      walletId: wallet.id,
      transactionType: WalletTransactionType.expense,
      referenceExpenseId: expense.id,
      memberId: member.id,
      memberName: member.displayName,
      categoryId: category.id,
      categoryName: category.name,
      amount: amount,
      signedAmount: -amount,
      balanceBefore: balanceBefore,
      balanceAfter: balanceAfter,
      transactionDate: expenseDate,
      description: title.trim(),
      recordedBy: actorUserId,
      createdAt: DateTime.now(),
    );

    _transactionsByHousehold[householdId] = [
      ...(_transactionsByHousehold[householdId] ?? const []),
      walletTx,
    ];

    _auditLogsByHousehold[householdId] = [
      ...(_auditLogsByHousehold[householdId] ?? const []),
      AuditLogEntry(
        id: _uuid.v4(),
        householdId: householdId,
        actorUserId: actorUserId,
        entityType: 'expense',
        entityId: expense.id,
        action: 'create',
        reason: 'Household expense recorded',
        newState: {
          'title': title.trim(),
          'category': category.name,
          'paid_by': member.displayName,
          'amount': amount,
          'balance_before': balanceBefore,
          'balance_after': balanceAfter,
        },
        createdAt: DateTime.now(),
      ),
    ];

    (ConsumptionRecord?, SupplyPrediction?) tracked = (null, null);
    if (autoTrackSupply) {
      tracked = _autoTrackSupplyFromExpense(
        householdId: householdId,
        actorUserId: actorUserId,
        category: category,
        expense: expense,
      );
    }

    await _syncRemote(
      () => _firestoreSync.saveExpenseBundle(
        expense: expense,
        updatedWallet: updatedWallet,
        transaction: walletTx,
        autoConsumption: tracked.$1,
        updatedPrediction: tracked.$2,
      ),
    );
    _refreshHouseholdAlerts(householdId);
    _persistSnapshot();
    return expense;
  }

  (ConsumptionRecord?, SupplyPrediction?) _autoTrackSupplyFromExpense({
    required String householdId,
    required String actorUserId,
    required ExpenseCategory category,
    required Expense expense,
  }) {
    final supplies = _suppliesByHousehold[householdId] ?? const [];
    if (supplies.isEmpty) return (null, null);

    final lowerTitle = expense.title.toLowerCase();
    TrackedSupply? matchedSupply;

    if (category.slug == 'electricity' ||
        lowerTitle.contains('electricity') ||
        lowerTitle.contains('luku') ||
        lowerTitle.contains('umeme')) {
      matchedSupply = supplies
          .where((s) => s.supplyType == SupplyType.electricity)
          .firstOrNull;
    } else if (category.slug == 'gas' ||
        lowerTitle.contains('gas') ||
        lowerTitle.contains('gesi')) {
      matchedSupply =
          supplies.where((s) => s.supplyType == SupplyType.gas).firstOrNull;
    } else if (category.slug == 'water' ||
        lowerTitle.contains('water') ||
        lowerTitle.contains('maji')) {
      matchedSupply =
          supplies.where((s) => s.supplyType == SupplyType.water).firstOrNull;
    } else {
      // Match separate grocery items (Flour/Unga, Sugar/Sukari, Cooking Oil/Mafuta, Spices, Seasonings/Viungo, Rice/Mchele, Milk/Maziwa, Eggs/Mayai, Soap/Sabuni)
      for (final s in supplies.where((s) => s.supplyType == SupplyType.grocery)) {
        final sLower = s.name.toLowerCase();
        if (lowerTitle.contains(sLower) ||
            (sLower.contains('flour') && lowerTitle.contains('unga')) ||
            (sLower.contains('sugar') && lowerTitle.contains('sukari')) ||
            (sLower.contains('oil') && lowerTitle.contains('mafuta')) ||
            (sLower.contains('seasoning') && lowerTitle.contains('viungo')) ||
            (sLower.contains('rice') && lowerTitle.contains('mchele')) ||
            (sLower.contains('milk') && lowerTitle.contains('maziwa')) ||
            (sLower.contains('egg') && lowerTitle.contains('mayai')) ||
            (sLower.contains('soap') && lowerTitle.contains('sabuni'))) {
          matchedSupply = s;
          break;
        }
      }
    }

    if (matchedSupply != null) {
      final record = ConsumptionRecord(
        id: _uuid.v4(),
        householdId: householdId,
        supplyId: matchedSupply.id,
        supplyName: matchedSupply.name,
        supplyType: matchedSupply.supplyType,
        expenseId: expense.id,
        purchaseDate: expense.expenseDate,
        amountPaid: expense.amount,
        unit: matchedSupply.defaultUnit,
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        notes: expense.notes,
        recordedBy: actorUserId,
        createdAt: DateTime.now(),
      );
      _consumptionByHousehold[householdId] = [
        ...(_consumptionByHousehold[householdId] ?? const []),
        record,
      ];
      final pred = _recomputePredictionForSupply(householdId, matchedSupply);
      return (record, pred);
    }
    return (null, null);
  }

  /// Safely corrects or reverses an existing wallet transaction without overwriting
  /// historical records, appending a compensating adjustment entry and an audit trail record.
  Future<WalletTransaction> correctOrReverseTransaction({
    required String householdId,
    required String actorUserId,
    required String walletTransactionId,
    required double newAmount, // Pass 0 to completely reverse the transaction
    required String newDescription,
    required String reason,
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);

    if (reason.trim().length < 3) {
      throw const ValidationException(
        'An audit reason (at least 3 characters) is required for transaction corrections.',
      );
    }
    if (newAmount < 0) {
      throw const ValidationException('Corrected amount cannot be negative.');
    }

    final txList = _transactionsByHousehold[householdId] ?? const [];
    final origTx =
        txList.where((tx) => tx.id == walletTransactionId).firstOrNull;
    if (origTx == null) {
      throw const ValidationException('Original wallet transaction not found.');
    }

    double deltaSigned;
    if (origTx.transactionType == WalletTransactionType.contribution) {
      deltaSigned = newAmount - origTx.amount;
    } else if (origTx.transactionType == WalletTransactionType.expense) {
      deltaSigned = origTx.amount - newAmount;
    } else {
      throw const ValidationException(
        'Only primary contribution or expense transactions can be corrected.',
      );
    }

    final household = _households[householdId]!;
    final wallet = _walletsByHousehold[householdId]!;
    final balanceBefore = wallet.availableBalance;
    final newAdjustments = wallet.totalAdjustments + deltaSigned;
    final balanceAfter =
        wallet.totalContributions - wallet.totalExpenses + newAdjustments;

    if (balanceAfter < 0 && !household.allowOverdraft) {
      throw InsufficientBalanceException(
        availableBalance: wallet.availableBalance,
        requestedAmount: deltaSigned.abs(),
        currencySymbol: household.currencySymbol,
      );
    }

    // Mark original contribution or expense status as corrected / reversed
    final targetStatus =
        newAmount == 0 ? RecordStatus.reversed : RecordStatus.corrected;
    if (origTx.referenceContributionId != null) {
      final contribs = List<Contribution>.from(
        _contributionsByHousehold[householdId] ?? const [],
      );
      final idx =
          contribs.indexWhere((c) => c.id == origTx.referenceContributionId);
      if (idx != -1) {
        contribs[idx] = contribs[idx].copyWith(status: targetStatus);
        _contributionsByHousehold[householdId] = contribs;
      }
    } else if (origTx.referenceExpenseId != null) {
      final exps = List<Expense>.from(
        _expensesByHousehold[householdId] ?? const [],
      );
      final idx = exps.indexWhere((e) => e.id == origTx.referenceExpenseId);
      if (idx != -1) {
        exps[idx] = exps[idx].copyWith(status: targetStatus);
        _expensesByHousehold[householdId] = exps;
      }
    }

    final WalletTransactionType adjType;
    if (newAmount == 0) {
      adjType = WalletTransactionType.reversal;
    } else if (deltaSigned >= 0) {
      adjType = WalletTransactionType.adjustmentCredit;
    } else {
      adjType = WalletTransactionType.adjustmentDebit;
    }

    final updatedWallet = wallet.copyWith(
      totalAdjustments: newAdjustments,
      availableBalance: balanceAfter,
      version: wallet.version + 1,
      lastTransactionAt: DateTime.now(),
    );
    _walletsByHousehold[householdId] = updatedWallet;

    final adjTx = WalletTransaction(
      id: _uuid.v4(),
      householdId: householdId,
      walletId: wallet.id,
      transactionType: adjType,
      referenceContributionId: origTx.referenceContributionId,
      referenceExpenseId: origTx.referenceExpenseId,
      parentTransactionId: origTx.id,
      memberId: origTx.memberId,
      memberName: origTx.memberName,
      categoryId: origTx.categoryId,
      categoryName: origTx.categoryName,
      amount: deltaSigned.abs(),
      signedAmount: deltaSigned,
      balanceBefore: balanceBefore,
      balanceAfter: balanceAfter,
      transactionDate: DateTime.now(),
      description:
          '[${newAmount == 0 ? 'REVERSAL' : 'CORRECTION'}] ${newDescription.trim()} (Reason: ${reason.trim()})',
      recordedBy: actorUserId,
      createdAt: DateTime.now(),
    );

    _transactionsByHousehold[householdId] = [
      ...(_transactionsByHousehold[householdId] ?? const []),
      adjTx,
    ];

    final auditLog = AuditLogEntry(
      id: _uuid.v4(),
      householdId: householdId,
      actorUserId: actorUserId,
      entityType: 'wallet_transaction',
      entityId: origTx.id,
      action: newAmount == 0 ? 'reverse' : 'correct',
      reason: reason.trim(),
      previousState: {
        'original_amount': origTx.amount,
        'original_signed_amount': origTx.signedAmount,
        'original_description': origTx.description,
        'balance_before_adjustment': balanceBefore,
      },
      newState: {
        'adjustment_transaction_id': adjTx.id,
        'corrected_amount': newAmount,
        'delta_signed': deltaSigned,
        'new_description': newDescription.trim(),
        'balance_after_adjustment': balanceAfter,
      },
      createdAt: DateTime.now(),
    );
    _auditLogsByHousehold[householdId] = [
      ...(_auditLogsByHousehold[householdId] ?? const []),
      auditLog,
    ];

    await _syncRemote(
      () => _firestoreSync.saveCorrectionBundle(
        householdId: householdId,
        updatedWallet: updatedWallet,
        adjustmentTransaction: adjTx,
        auditLog: auditLog,
      ),
    );
    _refreshHouseholdAlerts(householdId);
    _persistSnapshot();
    return adjTx;
  }

  // ---------------------------------------------------------------------------
  // CONSUMPTION TRACKING & PREDICTION ENGINE (PHASES 4 & 5)
  // ---------------------------------------------------------------------------

  List<TrackedSupply> getTrackedSupplies({
    required String householdId,
    required String actorUserId,
    SupplyType? supplyType,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    final list = _suppliesByHousehold[householdId] ?? const [];
    if (supplyType != null) {
      return list.where((s) => s.supplyType == supplyType).toList();
    }
    return List.unmodifiable(list);
  }

  Future<TrackedSupply> addTrackedSupply({
    required String householdId,
    required String actorUserId,
    required String name,
    required SupplyType supplyType,
    required String defaultUnit,
    String? categoryId,
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);
    final supply = TrackedSupply(
      id: _uuid.v4(),
      householdId: householdId,
      categoryId: categoryId,
      name: name.trim(),
      supplyType: supplyType,
      defaultUnit: defaultUnit.trim(),
    );
    _suppliesByHousehold[householdId] = [
      ...(_suppliesByHousehold[householdId] ?? const []),
      supply,
    ];
    final pred = _recomputePredictionForSupply(householdId, supply);
    await _syncRemote(
      () => _firestoreSync.saveTrackedSupplyBundle(supply, pred),
    );
    _persistSnapshot();
    return supply;
  }

  List<ConsumptionRecord> getConsumptionRecords({
    required String householdId,
    required String actorUserId,
    String? supplyId,
    SupplyType? supplyType,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    final all = _consumptionByHousehold[householdId] ?? const [];
    final filtered = all.where((r) {
      if (supplyId != null && r.supplyId != supplyId) return false;
      if (supplyType != null && r.supplyType != supplyType) return false;
      return true;
    }).toList()
      ..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
    return filtered;
  }

  List<SupplyPrediction> getPredictions({
    required String householdId,
    required String actorUserId,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    final map = _predictionsByHousehold[householdId] ?? const {};
    final list = map.values.toList()
      ..sort((a, b) {
        final dateA = a.effectiveNextDate ?? DateTime(2099);
        final dateB = b.effectiveNextDate ?? DateTime(2099);
        return dateA.compareTo(dateB);
      });
    return list;
  }

  /// Records a supply purchase (Electricity LUKU, Gas, Water, or Grocery item),
  /// optionally deducts it from the household wallet, and immediately updates predictions.
  Future<ConsumptionRecord> recordSupplyPurchase({
    required String householdId,
    required String actorUserId,
    required String supplyId,
    required DateTime purchaseDate,
    required double amountPaid,
    double? quantity,
    PreviousExhaustedState previousExhaustedState =
        PreviousExhaustedState.unknown,
    double? remainingUnits,
    double? remainingPercentage,
    double? cylinderWeightKg,
    int? userEstimatedDurationDays,
    String? notes,
    bool alsoRecordWalletExpense = false,
    String? paidByMemberId,
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);

    final supplies = _suppliesByHousehold[householdId] ?? const [];
    final supply = supplies.where((s) => s.id == supplyId).firstOrNull;
    if (supply == null) {
      throw const ValidationException('Selected supply not found.');
    }

    String? linkedExpenseId;
    if (alsoRecordWalletExpense && paidByMemberId != null) {
      final categoryId =
          supply.categoryId ?? 'cat-$householdId-other';
      final expense = await recordExpense(
        householdId: householdId,
        actorUserId: actorUserId,
        categoryId: categoryId,
        paidByMemberId: paidByMemberId,
        title: '${supply.name} Replenishment',
        amount: amountPaid,
        expenseDate: purchaseDate,
        notes: notes,
        autoTrackSupply: false,
      );
      linkedExpenseId = expense.id;
    }

    final record = ConsumptionRecord(
      id: _uuid.v4(),
      householdId: householdId,
      supplyId: supply.id,
      supplyName: supply.name,
      supplyType: supply.supplyType,
      expenseId: linkedExpenseId,
      purchaseDate: purchaseDate,
      amountPaid: amountPaid,
      quantity: quantity,
      unit: supply.defaultUnit,
      previousExhaustedState: previousExhaustedState,
      remainingUnits: remainingUnits,
      remainingPercentage: remainingPercentage,
      cylinderWeightKg: cylinderWeightKg,
      userEstimatedDurationDays: userEstimatedDurationDays,
      notes: notes?.trim(),
      recordedBy: actorUserId,
      createdAt: DateTime.now(),
    );

    _consumptionByHousehold[householdId] = [
      ...(_consumptionByHousehold[householdId] ?? const []),
      record,
    ];

    final updatedPred = _recomputePredictionForSupply(householdId, supply);
    await _syncRemote(
      () => _firestoreSync.saveConsumptionBundle(
        record: record,
        updatedPrediction: updatedPred,
        isCreateRecord: true,
      ),
    );
    _refreshHouseholdAlerts(householdId);
    _persistSnapshot();
    return record;
  }

  /// Allows the administrator to record the actual depletion date or override a prediction
  /// (Section 9.2: Manual correction & learning from actual outcomes).
  Future<SupplyPrediction> recordActualDepletionOutcome({
    required String householdId,
    required String actorUserId,
    required String supplyId,
    required DateTime actualDepletionDate,
    String? reason,
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);

    final supplies = _suppliesByHousehold[householdId] ?? const [];
    final supply = supplies.where((s) => s.id == supplyId).firstOrNull;
    if (supply == null) {
      throw const ValidationException('Tracked supply not found.');
    }

    final records = List<ConsumptionRecord>.from(
      _consumptionByHousehold[householdId] ?? const [],
    );
    final supplyRecords = records
        .where((r) => r.supplyId == supplyId)
        .toList()
      ..sort((a, b) => a.purchaseDate.compareTo(b.purchaseDate));

    if (supplyRecords.isEmpty) {
      throw const ValidationException(
        'Cannot record depletion outcome before recording at least one purchase.',
      );
    }

    final latestRecord = supplyRecords.last;
    if (!actualDepletionDate.isAfter(latestRecord.purchaseDate)) {
      throw const ValidationException(
        'Actual depletion date must be after the latest purchase date.',
      );
    }

    final idx = records.indexWhere((r) => r.id == latestRecord.id);
    final updatedRecord = latestRecord.copyWith(
      actualDepletionDate: actualDepletionDate,
    );
    records[idx] = updatedRecord;
    _consumptionByHousehold[householdId] = records;

    final previousPred = _predictionsByHousehold[householdId]?[supplyId];
    final updatedPred = _recomputePredictionForSupply(householdId, supply);

    final auditLog = AuditLogEntry(
      id: _uuid.v4(),
      householdId: householdId,
      actorUserId: actorUserId,
      entityType: 'prediction',
      entityId: updatedPred.id,
      action: 'manual_prediction_override',
      reason: reason?.trim().isNotEmpty == true
          ? reason!.trim()
          : 'Recorded actual confirmed supply depletion date',
      previousState: {
        'previous_estimated_date':
            previousPred?.estimatedNextReplenishmentDate?.toIso8601String(),
      },
      newState: {
        'actual_depletion_date': actualDepletionDate.toIso8601String(),
        'updated_average_interval_days': updatedPred.averageIntervalDays,
        'updated_estimated_next_date':
            updatedPred.estimatedNextReplenishmentDate?.toIso8601String(),
      },
      createdAt: DateTime.now(),
    );
    _auditLogsByHousehold[householdId] = [
      ...(_auditLogsByHousehold[householdId] ?? const []),
      auditLog,
    ];

    await _syncRemote(
      () => _firestoreSync.saveConsumptionBundle(
        record: updatedRecord,
        updatedPrediction: updatedPred,
        isCreateRecord: false,
        auditLog: auditLog,
      ),
    );
    _refreshHouseholdAlerts(householdId);
    _persistSnapshot();
    return updatedPred;
  }

  SupplyPrediction _recomputePredictionForSupply(
    String householdId,
    TrackedSupply supply,
  ) {
    final allRecords = _consumptionByHousehold[householdId] ?? const [];
    final supplyRecords =
        allRecords.where((r) => r.supplyId == supply.id).toList();
    final computed = _predictionEngine.computePrediction(
      supply: supply,
      records: supplyRecords,
    );
    final map = Map<String, SupplyPrediction>.from(
      _predictionsByHousehold[householdId] ?? const {},
    );
    map[supply.id] = computed;
    _predictionsByHousehold[householdId] = map;
    return computed;
  }

  // ---------------------------------------------------------------------------
  // RECURRING BILLS (SECTION 8.5)
  // ---------------------------------------------------------------------------

  List<RecurringBill> getRecurringBills({
    required String householdId,
    required String actorUserId,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    final bills = List<RecurringBill>.from(
      _billsByHousehold[householdId] ?? const [],
    )..sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
    return bills;
  }

  Future<RecurringBill> upsertRecurringBill({
    required String householdId,
    required String actorUserId,
    required String categoryId,
    required String title,
    String? providerName,
    required double expectedAmount,
    required BillingFrequency frequency,
    required DateTime nextDueDate,
    int remindDaysBefore = 3,
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);
    final categories = _categoriesByHousehold[householdId] ?? const [];
    final category = categories.where((c) => c.id == categoryId).firstOrNull;
    final bill = RecurringBill(
      id: _uuid.v4(),
      householdId: householdId,
      categoryId: categoryId,
      categoryName: category?.name ?? 'Bill',
      title: title.trim(),
      providerName: providerName?.trim(),
      expectedAmount: expectedAmount,
      frequency: frequency,
      nextDueDate: nextDueDate,
      remindDaysBefore: remindDaysBefore,
    );
    _billsByHousehold[householdId] = [
      ...(_billsByHousehold[householdId] ?? const []),
      bill,
    ];
    await _syncRemote(() => _firestoreSync.saveRecurringBill(bill));
    _refreshHouseholdAlerts(householdId);
    _persistSnapshot();
    return bill;
  }

  // ---------------------------------------------------------------------------
  // MONTHLY BUDGETS (SECTION 11)
  // ---------------------------------------------------------------------------

  List<CategoryBudgetStatus> getBudgetStatusesForMonth({
    required String householdId,
    required String actorUserId,
    required DateTime month,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    final normalizedMonth = DateTime(month.year, month.month, 1);
    final budgets = (_budgetsByHousehold[householdId] ?? const [])
        .where(
          (b) =>
              b.isActive &&
              b.budgetMonth.year == normalizedMonth.year &&
              b.budgetMonth.month == normalizedMonth.month,
        )
        .toList();

    final expenses = (_expensesByHousehold[householdId] ?? const []).where(
      (e) =>
          e.status != RecordStatus.reversed &&
          e.expenseDate.year == normalizedMonth.year &&
          e.expenseDate.month == normalizedMonth.month,
    );

    return budgets.map((budget) {
      final spent = expenses
          .where((e) => e.categoryId == budget.categoryId)
          .fold<double>(0.0, (sum, e) => sum + e.amount);
      return CategoryBudgetStatus(budget: budget, amountSpent: spent);
    }).toList();
  }

  Future<HouseholdBudget> setMonthlyCategoryBudget({
    required String householdId,
    required String actorUserId,
    required String categoryId,
    required DateTime month,
    required double budgetAmount,
    double alertThresholdPercent = 80.0,
  }) async {
    verifyAdminWriteAccess(householdId: householdId, actorUserId: actorUserId);
    if (budgetAmount <= 0) {
      throw const ValidationException('Budget amount must be greater than zero.');
    }

    final normalizedMonth = DateTime(month.year, month.month, 1);
    final categories = _categoriesByHousehold[householdId] ?? const [];
    final category = categories.where((c) => c.id == categoryId).firstOrNull;
    if (category == null) {
      throw const ValidationException('Category not found.');
    }

    final existing = List<HouseholdBudget>.from(
      _budgetsByHousehold[householdId] ?? const [],
    );
    final idx = existing.indexWhere(
      (b) =>
          b.categoryId == categoryId &&
          b.budgetMonth.year == normalizedMonth.year &&
          b.budgetMonth.month == normalizedMonth.month,
    );

    final HouseholdBudget saved;
    if (idx != -1) {
      saved = existing[idx].copyWith(
        budgetAmount: budgetAmount,
        alertThresholdPercent: alertThresholdPercent,
        isActive: true,
      );
      existing[idx] = saved;
    } else {
      saved = HouseholdBudget(
        id: _uuid.v4(),
        householdId: householdId,
        categoryId: category.id,
        categoryName: category.name,
        budgetMonth: normalizedMonth,
        budgetAmount: budgetAmount,
        alertThresholdPercent: alertThresholdPercent,
      );
      existing.add(saved);
    }
    _budgetsByHousehold[householdId] = existing;
    await _syncRemote(
      () => _firestoreSync.saveBudget(saved, isCreate: idx == -1),
    );
    _refreshHouseholdAlerts(householdId);
    _persistSnapshot();
    return saved;
  }

  // ---------------------------------------------------------------------------
  // NOTIFICATIONS & MONTHLY REPORTS (PHASES 6 & 7)
  // ---------------------------------------------------------------------------

  List<HouseholdNotification> getNotifications({
    required String householdId,
    required String actorUserId,
    bool includeDismissed = false,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    final list = (_notificationsByHousehold[householdId] ?? const [])
        .where((n) => includeDismissed || !n.isDismissed)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  void markNotificationRead({
    required String householdId,
    required String actorUserId,
    required String notificationId,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    final list = List<HouseholdNotification>.from(
      _notificationsByHousehold[householdId] ?? const [],
    );
    final idx = list.indexWhere((n) => n.id == notificationId);
    if (idx != -1) {
      final updated = list[idx].copyWith(isRead: true);
      list[idx] = updated;
      _notificationsByHousehold[householdId] = list;
      unawaited(_syncRemote(() => _firestoreSync.updateNotificationState(updated)));
    }
  }

  void dismissNotification({
    required String householdId,
    required String actorUserId,
    required String notificationId,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    final list = List<HouseholdNotification>.from(
      _notificationsByHousehold[householdId] ?? const [],
    );
    final idx = list.indexWhere((n) => n.id == notificationId);
    if (idx != -1) {
      final updated = list[idx].copyWith(isDismissed: true, isRead: true);
      list[idx] = updated;
      _notificationsByHousehold[householdId] = list;
      unawaited(_syncRemote(() => _firestoreSync.updateNotificationState(updated)));
    }
  }

  MonthlyFinancialSummary getMonthlySummary({
    required String householdId,
    required String actorUserId,
    required DateTime month,
  }) {
    verifyReadAccess(householdId: householdId, actorUserId: actorUserId);
    final wallet = _walletsByHousehold[householdId]!;
    final contributions = (_contributionsByHousehold[householdId] ?? const [])
        .where(
          (c) =>
              c.status != RecordStatus.reversed &&
              c.contributionDate.year == month.year &&
              c.contributionDate.month == month.month,
        )
        .toList();

    final expenses = (_expensesByHousehold[householdId] ?? const [])
        .where(
          (e) =>
              e.status != RecordStatus.reversed &&
              e.expenseDate.year == month.year &&
              e.expenseDate.month == month.month,
        )
        .toList();

    final prevMonth = DateTime(month.year, month.month - 1, 1);
    final prevMonthExpenses =
        (_expensesByHousehold[householdId] ?? const [])
            .where(
              (e) =>
                  e.status != RecordStatus.reversed &&
                  e.expenseDate.year == prevMonth.year &&
                  e.expenseDate.month == prevMonth.month,
            )
            .fold<double>(0.0, (sum, e) => sum + e.amount);

    final totalContrib =
        contributions.fold<double>(0.0, (sum, c) => sum + c.amount);
    final totalExp = expenses.fold<double>(0.0, (sum, e) => sum + e.amount);

    final Map<String, double> byMember = {};
    for (final c in contributions) {
      byMember[c.memberName] = (byMember[c.memberName] ?? 0.0) + c.amount;
    }

    final Map<String, double> byCategory = {};
    for (final e in expenses) {
      byCategory[e.categoryName] =
          (byCategory[e.categoryName] ?? 0.0) + e.amount;
    }

    String? highestCategory;
    double highestAmount = 0.0;
    byCategory.forEach((cat, amt) {
      if (amt > highestAmount) {
        highestAmount = amt;
        highestCategory = cat;
      }
    });

    return MonthlyFinancialSummary(
      month: DateTime(month.year, month.month, 1),
      totalContributions: totalContrib,
      totalExpenses: totalExp,
      remainingBalance: wallet.availableBalance,
      highestExpenseCategory: highestCategory,
      highestExpenseCategoryAmount: highestAmount,
      contributionsByMember: byMember,
      expensesByCategory: byCategory,
      previousMonthExpenses: prevMonthExpenses,
    );
  }

  void _refreshHouseholdAlerts(String householdId) {
    final household = _households[householdId];
    final wallet = _walletsByHousehold[householdId];
    if (household == null || wallet == null) return;

    final now = DateTime.now();
    final predictions =
        (_predictionsByHousehold[householdId] ?? const {}).values.toList();
    final bills = _billsByHousehold[householdId] ?? const [];
    final budgets = getBudgetStatusesForMonth(
      householdId: householdId,
      actorUserId: household.ownerId,
      month: now,
    );
    final existing = _notificationsByHousehold[householdId] ?? const [];

    final newlyGenerated = _alertEvaluator.evaluateAlerts(
      household: household,
      wallet: wallet,
      predictions: predictions,
      recurringBills: bills,
      budgetStatuses: budgets,
      existingNotifications: existing,
      referenceDate: now,
    );

    if (newlyGenerated.isNotEmpty) {
      _notificationsByHousehold[householdId] = [
        ...newlyGenerated,
        ...existing,
      ];
      unawaited(
        _syncRemote(
          () => _firestoreSync.saveNotifications(householdId, newlyGenerated),
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // REALISTIC TANZANIAN SEED ENVIRONMENT (SEPARATE DEMO SEED AS PER SECTION 19.15)
  // ---------------------------------------------------------------------------

  void _seedInitialTanzanianHouseholds() {
    const ownerId = 'user-admin-dida-001';
    const h1Id = 'household-my-family-001';
    const h2Id = 'household-my-apartment-002';
    const h3Id = 'household-parents-home-003';

    // 1. Create "My Family" (Primary Household from Product Overview)
    _households[h1Id] = Household(
      id: h1Id,
      ownerId: ownerId,
      name: 'My Family',
      description: 'Shared family house in Mikocheni, Dar es Salaam',
      address: 'Mikocheni B, Kinondoni, Dar es Salaam',
      currencyCode: 'TZS',
      currencySymbol: 'TSh',
      lowBalanceThreshold: 40000,
      createdAt: DateTime(2026, 10, 1),
    );

    const mDidaId = 'member-dida-001';
    const mMemberBId = 'member-asha-002';
    const mMemberCId = 'member-juma-003';

    _membersByHousehold[h1Id] = [
      HouseholdMember(
        id: mDidaId,
        householdId: h1Id,
        linkedUserId: ownerId,
        displayName: 'Dida',
        email: 'dida@rahisi.co.tz',
        phoneNumber: '+255 754 100 200',
        role: HouseholdRole.admin,
        avatarColor: '#3B82F6',
        joinedAt: DateTime(2026, 10, 1),
      ),
      HouseholdMember(
        id: mMemberBId,
        householdId: h1Id,
        displayName: 'Member B (Asha)',
        phoneNumber: '+255 713 200 300',
        role: HouseholdRole.member,
        avatarColor: '#10B981',
        joinedAt: DateTime(2026, 10, 1),
      ),
      HouseholdMember(
        id: mMemberCId,
        householdId: h1Id,
        displayName: 'Member C (Juma)',
        phoneNumber: '+255 784 300 400',
        role: HouseholdRole.member,
        avatarColor: '#F97316',
        joinedAt: DateTime(2026, 10, 1),
      ),
    ];

    _categoriesByHousehold[h1Id] =
        ExpenseCategory.createDefaultCategoriesForHousehold(h1Id);
    final h1Supplies = TrackedSupply.createDefaultsForHousehold(h1Id);
    _suppliesByHousehold[h1Id] = h1Supplies;

    // Initialize empty wallet before recording the exact Product Overview scenario:
    // Dida contributes TSh 100,000; Member B contributes TSh 50,000; Member C contributes TSh 150,000 -> Total 300,000
    // Dida purchases Groceries for TSh 50,000 -> Available balance = TSh 250,000
    _walletsByHousehold[h1Id] = const HouseholdWallet(
      id: 'wallet-h1',
      householdId: h1Id,
      totalContributions: 0,
      totalExpenses: 0,
      totalAdjustments: 0,
      availableBalance: 0,
    );
    _contributionsByHousehold[h1Id] = [];
    _expensesByHousehold[h1Id] = [];
    _transactionsByHousehold[h1Id] = [];
    _budgetsByHousehold[h1Id] = [
      HouseholdBudget(
        id: 'budget-h1-groceries',
        householdId: h1Id,
        categoryId: 'cat-$h1Id-groceries',
        categoryName: 'Groceries',
        budgetMonth: DateTime(2026, 11, 1),
        budgetAmount: 150000,
      ),
      HouseholdBudget(
        id: 'budget-h1-electricity',
        householdId: h1Id,
        categoryId: 'cat-$h1Id-electricity',
        categoryName: 'Electricity',
        budgetMonth: DateTime(2026, 11, 1),
        budgetAmount: 50000,
      ),
      HouseholdBudget(
        id: 'budget-h1-gas',
        householdId: h1Id,
        categoryId: 'cat-$h1Id-gas',
        categoryName: 'Gas',
        budgetMonth: DateTime(2026, 11, 1),
        budgetAmount: 40000,
      ),
      HouseholdBudget(
        id: 'budget-h1-water',
        householdId: h1Id,
        categoryId: 'cat-$h1Id-water',
        categoryName: 'Water',
        budgetMonth: DateTime(2026, 11, 1),
        budgetAmount: 30000,
      ),
    ];
    _consumptionByHousehold[h1Id] = [];
    _billsByHousehold[h1Id] = [
      RecurringBill(
        id: 'bill-h1-internet',
        householdId: h1Id,
        categoryId: 'cat-$h1Id-internet',
        categoryName: 'Internet',
        title: 'Fiber Internet Subscription',
        providerName: ' Vodacom / TTCL Fiber',
        expectedAmount: 65000,
        frequency: BillingFrequency.monthly,
        nextDueDate: DateTime(2026, 11, 12),
        remindDaysBefore: 3,
      ),
      RecurringBill(
        id: 'bill-h1-rent',
        householdId: h1Id,
        categoryId: 'cat-$h1Id-rent',
        categoryName: 'Rent',
        title: 'Monthly House Rent',
        providerName: 'Landlord Mikocheni',
        expectedAmount: 450000,
        frequency: BillingFrequency.monthly,
        nextDueDate: DateTime(2026, 11, 30),
        remindDaysBefore: 5,
      ),
    ];
    _notificationsByHousehold[h1Id] = [];
    _auditLogsByHousehold[h1Id] = [];
    _predictionsByHousehold[h1Id] = {};

    // Record the exact contributions & grocery purchase from Section 2 & Section 6:
    recordContribution(
      householdId: h1Id,
      actorUserId: ownerId,
      memberId: mDidaId,
      amount: 100000,
      contributionDate: DateTime(2026, 11, 1),
      description: 'Monthly household contribution (Dida)',
    );
    recordContribution(
      householdId: h1Id,
      actorUserId: ownerId,
      memberId: mMemberBId,
      amount: 50000,
      contributionDate: DateTime(2026, 11, 2),
      description: 'Monthly household contribution (Member B)',
    );
    recordContribution(
      householdId: h1Id,
      actorUserId: ownerId,
      memberId: mMemberCId,
      amount: 150000,
      contributionDate: DateTime(2026, 11, 3),
      description: 'Monthly household contribution (Member C)',
    );
    // Record separate grocery purchases (Flour, Sugar, Cooking Oil, Spices, Seasonings = Total TSh 50,000)
    recordExpense(
      householdId: h1Id,
      actorUserId: ownerId,
      categoryId: 'cat-$h1Id-groceries',
      paidByMemberId: mDidaId,
      title: 'Flour - 10 kg',
      amount: 15000,
      expenseDate: DateTime(2026, 11, 4),
      notes: 'Maize & wheat flour',
    );
    recordExpense(
      householdId: h1Id,
      actorUserId: ownerId,
      categoryId: 'cat-$h1Id-groceries',
      paidByMemberId: mDidaId,
      title: 'Sugar - 5 kg',
      amount: 15000,
      expenseDate: DateTime(2026, 11, 4),
      notes: 'Household sugar',
    );
    recordExpense(
      householdId: h1Id,
      actorUserId: ownerId,
      categoryId: 'cat-$h1Id-groceries',
      paidByMemberId: mDidaId,
      title: 'Cooking Oil - 3 Liters',
      amount: 12000,
      expenseDate: DateTime(2026, 11, 4),
      notes: 'Sunflower cooking oil',
    );
    recordExpense(
      householdId: h1Id,
      actorUserId: ownerId,
      categoryId: 'cat-$h1Id-groceries',
      paidByMemberId: mDidaId,
      title: 'Spices',
      amount: 3000,
      expenseDate: DateTime(2026, 11, 4),
      notes: 'Pilau masala, black pepper, turmeric',
    );
    recordExpense(
      householdId: h1Id,
      actorUserId: ownerId,
      categoryId: 'cat-$h1Id-groceries',
      paidByMemberId: mDidaId,
      title: 'Seasonings',
      amount: 5000,
      expenseDate: DateTime(2026, 11, 4),
      notes: 'Onions, tomatoes, garlic, ginger, bell peppers',
    );

    // Seed Historical Consumption Records for Electricity & Separate Groceries
    final lukuSupplyId = 'supply-$h1Id-luku';
    final gasSupplyId = 'supply-$h1Id-gas';
    final waterSupplyId = 'supply-$h1Id-water';
    final ungaSupplyId = 'supply-$h1Id-unga';
    final sukariSupplyId = 'supply-$h1Id-sukari';
    final mafutaSupplyId = 'supply-$h1Id-mafuta';
    final spicesSupplyId = 'supply-$h1Id-spices';
    final viungoSupplyId = 'supply-$h1Id-viungo';
    final riceSupplyId = 'supply-$h1Id-rice';

    _consumptionByHousehold[h1Id] = [
      ConsumptionRecord(
        id: 'cons-luku-1',
        householdId: h1Id,
        supplyId: lukuSupplyId,
        supplyName: 'Electricity',
        supplyType: SupplyType.electricity,
        purchaseDate: DateTime(2026, 10, 5),
        amountPaid: 30000,
        quantity: 84.0,
        unit: 'kWh',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 10, 5),
      ),
      ConsumptionRecord(
        id: 'cons-luku-2',
        householdId: h1Id,
        supplyId: lukuSupplyId,
        supplyName: 'Electricity',
        supplyType: SupplyType.electricity,
        purchaseDate: DateTime(2026, 10, 15),
        amountPaid: 30000,
        quantity: 84.0,
        unit: 'kWh',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 10, 15),
      ),
      ConsumptionRecord(
        id: 'cons-luku-3',
        householdId: h1Id,
        supplyId: lukuSupplyId,
        supplyName: 'Electricity',
        supplyType: SupplyType.electricity,
        purchaseDate: DateTime(2026, 10, 25),
        amountPaid: 35000,
        quantity: 98.0,
        unit: 'kWh',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 10, 25),
      ),
      ConsumptionRecord(
        id: 'cons-luku-4',
        householdId: h1Id,
        supplyId: lukuSupplyId,
        supplyName: 'Electricity',
        supplyType: SupplyType.electricity,
        purchaseDate: DateTime(2026, 11, 1),
        amountPaid: 30000,
        quantity: 84.0,
        unit: 'kWh',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 11, 1),
      ),
      // Gas replacement records (~25 day duration as in Section 8.2)
      ConsumptionRecord(
        id: 'cons-gas-1',
        householdId: h1Id,
        supplyId: gasSupplyId,
        supplyName: 'Cooking Gas',
        supplyType: SupplyType.gas,
        purchaseDate: DateTime(2026, 9, 12),
        amountPaid: 55000,
        quantity: 15.0,
        cylinderWeightKg: 15.0,
        unit: 'kg',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 9, 12),
      ),
      ConsumptionRecord(
        id: 'cons-gas-2',
        householdId: h1Id,
        supplyId: gasSupplyId,
        supplyName: 'Cooking Gas',
        supplyType: SupplyType.gas,
        purchaseDate: DateTime(2026, 10, 7),
        amountPaid: 55000,
        quantity: 15.0,
        cylinderWeightKg: 15.0,
        unit: 'kg',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 10, 7),
      ),
      ConsumptionRecord(
        id: 'cons-gas-3',
        householdId: h1Id,
        supplyId: gasSupplyId,
        supplyName: 'Cooking Gas',
        supplyType: SupplyType.gas,
        purchaseDate: DateTime(2026, 11, 1),
        amountPaid: 55000,
        quantity: 15.0,
        cylinderWeightKg: 15.0,
        unit: 'kg',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 11, 1),
      ),
      // Water records (~14 day interval)
      ConsumptionRecord(
        id: 'cons-water-1',
        householdId: h1Id,
        supplyId: waterSupplyId,
        supplyName: 'Water Supply',
        supplyType: SupplyType.water,
        purchaseDate: DateTime(2026, 10, 14),
        amountPaid: 18000,
        quantity: 2000,
        unit: 'liters',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 10, 14),
      ),
      ConsumptionRecord(
        id: 'cons-water-2',
        householdId: h1Id,
        supplyId: waterSupplyId,
        supplyName: 'Water Supply',
        supplyType: SupplyType.water,
        purchaseDate: DateTime(2026, 10, 28),
        amountPaid: 18000,
        quantity: 2000,
        unit: 'liters',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 10, 28),
      ),
      // Separate Grocery Items: Flour, Sugar, Cooking Oil, Spices, Seasonings, Rice
      ConsumptionRecord(
        id: 'cons-unga-1',
        householdId: h1Id,
        supplyId: ungaSupplyId,
        supplyName: 'Flour',
        supplyType: SupplyType.grocery,
        purchaseDate: DateTime(2026, 10, 21),
        amountPaid: 15000,
        quantity: 10.0,
        unit: 'kg',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 10, 21),
      ),
      ConsumptionRecord(
        id: 'cons-unga-2',
        householdId: h1Id,
        supplyId: ungaSupplyId,
        supplyName: 'Flour',
        supplyType: SupplyType.grocery,
        purchaseDate: DateTime(2026, 11, 4),
        amountPaid: 15000,
        quantity: 10.0,
        unit: 'kg',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 11, 4),
      ),
      ConsumptionRecord(
        id: 'cons-sukari-1',
        householdId: h1Id,
        supplyId: sukariSupplyId,
        supplyName: 'Sugar',
        supplyType: SupplyType.grocery,
        purchaseDate: DateTime(2026, 10, 15),
        amountPaid: 15000,
        quantity: 5.0,
        unit: 'kg',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 10, 15),
      ),
      ConsumptionRecord(
        id: 'cons-sukari-2',
        householdId: h1Id,
        supplyId: sukariSupplyId,
        supplyName: 'Sugar',
        supplyType: SupplyType.grocery,
        purchaseDate: DateTime(2026, 11, 4),
        amountPaid: 15000,
        quantity: 5.0,
        unit: 'kg',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 11, 4),
      ),
      ConsumptionRecord(
        id: 'cons-mafuta-1',
        householdId: h1Id,
        supplyId: mafutaSupplyId,
        supplyName: 'Cooking Oil',
        supplyType: SupplyType.grocery,
        purchaseDate: DateTime(2026, 10, 18),
        amountPaid: 12000,
        quantity: 3.0,
        unit: 'liters',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 10, 18),
      ),
      ConsumptionRecord(
        id: 'cons-mafuta-2',
        householdId: h1Id,
        supplyId: mafutaSupplyId,
        supplyName: 'Cooking Oil',
        supplyType: SupplyType.grocery,
        purchaseDate: DateTime(2026, 11, 4),
        amountPaid: 12000,
        quantity: 3.0,
        unit: 'liters',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 11, 4),
      ),
      ConsumptionRecord(
        id: 'cons-spices-1',
        householdId: h1Id,
        supplyId: spicesSupplyId,
        supplyName: 'Spices',
        supplyType: SupplyType.grocery,
        purchaseDate: DateTime(2026, 10, 10),
        amountPaid: 3000,
        quantity: 3.0,
        unit: 'packs',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 10, 10),
      ),
      ConsumptionRecord(
        id: 'cons-spices-2',
        householdId: h1Id,
        supplyId: spicesSupplyId,
        supplyName: 'Spices',
        supplyType: SupplyType.grocery,
        purchaseDate: DateTime(2026, 11, 4),
        amountPaid: 3000,
        quantity: 3.0,
        unit: 'packs',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 11, 4),
      ),
      ConsumptionRecord(
        id: 'cons-viungo-1',
        householdId: h1Id,
        supplyId: viungoSupplyId,
        supplyName: 'Seasonings',
        supplyType: SupplyType.grocery,
        purchaseDate: DateTime(2026, 10, 28),
        amountPaid: 5000,
        quantity: 2.5,
        unit: 'kg',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 10, 28),
      ),
      ConsumptionRecord(
        id: 'cons-viungo-2',
        householdId: h1Id,
        supplyId: viungoSupplyId,
        supplyName: 'Seasonings',
        supplyType: SupplyType.grocery,
        purchaseDate: DateTime(2026, 11, 4),
        amountPaid: 5000,
        quantity: 2.5,
        unit: 'kg',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 11, 4),
      ),
      ConsumptionRecord(
        id: 'cons-rice-1',
        householdId: h1Id,
        supplyId: riceSupplyId,
        supplyName: 'Rice',
        supplyType: SupplyType.grocery,
        purchaseDate: DateTime(2026, 10, 20),
        amountPaid: 28000,
        quantity: 10.0,
        unit: 'kg',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 10, 20),
      ),
      ConsumptionRecord(
        id: 'cons-rice-2',
        householdId: h1Id,
        supplyId: riceSupplyId,
        supplyName: 'Rice',
        supplyType: SupplyType.grocery,
        purchaseDate: DateTime(2026, 11, 4),
        amountPaid: 28000,
        quantity: 10.0,
        unit: 'kg',
        previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
        recordedBy: ownerId,
        createdAt: DateTime(2026, 11, 4),
      ),
    ];

    for (final s in h1Supplies) {
      _recomputePredictionForSupply(h1Id, s);
    }
    _refreshHouseholdAlerts(h1Id);

    // 2. Create Second Independent Household: "My Apartment"
    _households[h2Id] = Household(
      id: h2Id,
      ownerId: ownerId,
      name: 'My Apartment',
      description: 'Shared roommates apartment in Masaki',
      address: 'Haile Selassie Rd, Masaki, Dar es Salaam',
      currencyCode: 'TZS',
      currencySymbol: 'TSh',
      lowBalanceThreshold: 30000,
      createdAt: DateTime(2026, 10, 5),
    );
    _membersByHousehold[h2Id] = [
      HouseholdMember(
        id: 'member-dida-h2',
        householdId: h2Id,
        linkedUserId: ownerId,
        displayName: 'Dida',
        role: HouseholdRole.admin,
        avatarColor: '#3B82F6',
        joinedAt: DateTime(2026, 10, 5),
      ),
      HouseholdMember(
        id: 'member-kelvin-h2',
        householdId: h2Id,
        displayName: 'Kelvin',
        role: HouseholdRole.member,
        avatarColor: '#8B5CF6',
        joinedAt: DateTime(2026, 10, 5),
      ),
    ];
    _categoriesByHousehold[h2Id] =
        ExpenseCategory.createDefaultCategoriesForHousehold(h2Id);
    final h2Supplies = TrackedSupply.createDefaultsForHousehold(h2Id);
    _suppliesByHousehold[h2Id] = h2Supplies;
    _walletsByHousehold[h2Id] = const HouseholdWallet(
      id: 'wallet-h2',
      householdId: h2Id,
      totalContributions: 0,
      totalExpenses: 0,
      totalAdjustments: 0,
      availableBalance: 0,
    );
    _contributionsByHousehold[h2Id] = [];
    _expensesByHousehold[h2Id] = [];
    _transactionsByHousehold[h2Id] = [];
    _budgetsByHousehold[h2Id] = [];
    _consumptionByHousehold[h2Id] = [];
    _billsByHousehold[h2Id] = [];
    _notificationsByHousehold[h2Id] = [];
    _auditLogsByHousehold[h2Id] = [];
    _predictionsByHousehold[h2Id] = {
      for (final s in h2Supplies)
        s.id: _predictionEngine.computePrediction(supply: s, records: const []),
    };

    recordContribution(
      householdId: h2Id,
      actorUserId: ownerId,
      memberId: 'member-dida-h2',
      amount: 120000,
      contributionDate: DateTime(2026, 11, 1),
      description: 'Masaki apartment utility fund',
    );

    // 3. Create Third Independent Household: "Parents' Home"
    _households[h3Id] = Household(
      id: h3Id,
      ownerId: ownerId,
      name: "Parents' Home",
      description: 'Family support fund for parents in Arusha',
      address: 'Njiro, Arusha',
      currencyCode: 'TZS',
      currencySymbol: 'TSh',
      lowBalanceThreshold: 25000,
      createdAt: DateTime(2026, 10, 10),
    );
    _membersByHousehold[h3Id] = [
      HouseholdMember(
        id: 'member-dida-h3',
        householdId: h3Id,
        linkedUserId: ownerId,
        displayName: 'Dida',
        role: HouseholdRole.admin,
        avatarColor: '#3B82F6',
        joinedAt: DateTime(2026, 10, 10),
      ),
      HouseholdMember(
        id: 'member-mama-h3',
        householdId: h3Id,
        displayName: 'Mama',
        role: HouseholdRole.member,
        avatarColor: '#10B981',
        joinedAt: DateTime(2026, 10, 10),
      ),
    ];
    _categoriesByHousehold[h3Id] =
        ExpenseCategory.createDefaultCategoriesForHousehold(h3Id);
    final h3Supplies = TrackedSupply.createDefaultsForHousehold(h3Id);
    _suppliesByHousehold[h3Id] = h3Supplies;
    _walletsByHousehold[h3Id] = const HouseholdWallet(
      id: 'wallet-h3',
      householdId: h3Id,
      totalContributions: 0,
      totalExpenses: 0,
      totalAdjustments: 0,
      availableBalance: 0,
    );
    _contributionsByHousehold[h3Id] = [];
    _expensesByHousehold[h3Id] = [];
    _transactionsByHousehold[h3Id] = [];
    _budgetsByHousehold[h3Id] = [];
    _consumptionByHousehold[h3Id] = [];
    _billsByHousehold[h3Id] = [];
    _notificationsByHousehold[h3Id] = [];
    _auditLogsByHousehold[h3Id] = [];
    _predictionsByHousehold[h3Id] = {
      for (final s in h3Supplies)
        s.id: _predictionEngine.computePrediction(supply: s, records: const []),
    };

    recordContribution(
      householdId: h3Id,
      actorUserId: ownerId,
      memberId: 'member-dida-h3',
      amount: 180000,
      contributionDate: DateTime(2026, 11, 1),
      description: 'Monthly upkeep contribution for Parents Home',
    );
  }

  // ---------------------------------------------------------------------------
  // ON-DEVICE PERSISTENCE (SHARED PREFERENCES SNAPSHOT)
  // ---------------------------------------------------------------------------

  Future<void> _persistSnapshot() async {
    if (_isSeeding) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = <String, dynamic>{
        'households': {
          for (final entry in _households.entries)
            entry.key: entry.value.toJson(),
        },
        'wallets': {
          for (final entry in _walletsByHousehold.entries)
            entry.key: {
              'id': entry.value.id,
              'householdId': entry.value.householdId,
              'totalContributions': entry.value.totalContributions,
              'totalExpenses': entry.value.totalExpenses,
              'totalAdjustments': entry.value.totalAdjustments,
              'availableBalance': entry.value.availableBalance,
              'version': entry.value.version,
            },
        },
        'members': {
          for (final entry in _membersByHousehold.entries)
            entry.key: entry.value
                .map(
                  (m) => {
                    'id': m.id,
                    'householdId': m.householdId,
                    'linkedUserId': m.linkedUserId,
                    'displayName': m.displayName,
                    'email': m.email,
                    'phoneNumber': m.phoneNumber,
                    'role': m.role.name,
                    'avatarColor': m.avatarColor,
                    'joinedAt': m.joinedAt.toIso8601String(),
                  },
                )
                .toList(),
        },
        'contributions': {
          for (final entry in _contributionsByHousehold.entries)
            entry.key: entry.value
                .map(
                  (c) => {
                    'id': c.id,
                    'householdId': c.householdId,
                    'memberId': c.memberId,
                    'memberName': c.memberName,
                    'recordedBy': c.recordedBy,
                    'amount': c.amount,
                    'contributionDate': c.contributionDate.toIso8601String(),
                    'description': c.description,
                    'idempotencyKey': c.idempotencyKey,
                    'createdAt': c.createdAt.toIso8601String(),
                  },
                )
                .toList(),
        },
        'expenses': {
          for (final entry in _expensesByHousehold.entries)
            entry.key: entry.value
                .map(
                  (e) => {
                    'id': e.id,
                    'householdId': e.householdId,
                    'categoryId': e.categoryId,
                    'categoryName': e.categoryName,
                    'paidByMemberId': e.paidByMemberId,
                    'paidByMemberName': e.paidByMemberName,
                    'recordedBy': e.recordedBy,
                    'title': e.title,
                    'amount': e.amount,
                    'expenseDate': e.expenseDate.toIso8601String(),
                    'notes': e.notes,
                    'idempotencyKey': e.idempotencyKey,
                    'createdAt': e.createdAt.toIso8601String(),
                  },
                )
                .toList(),
        },
        'transactions': {
          for (final entry in _transactionsByHousehold.entries)
            entry.key: entry.value
                .map(
                  (t) => {
                    'id': t.id,
                    'householdId': t.householdId,
                    'walletId': t.walletId,
                    'transactionType': t.transactionType.name,
                    'referenceContributionId': t.referenceContributionId,
                    'referenceExpenseId': t.referenceExpenseId,
                    'memberId': t.memberId,
                    'memberName': t.memberName,
                    'categoryId': t.categoryId,
                    'categoryName': t.categoryName,
                    'amount': t.amount,
                    'signedAmount': t.signedAmount,
                    'balanceBefore': t.balanceBefore,
                    'balanceAfter': t.balanceAfter,
                    'transactionDate': t.transactionDate.toIso8601String(),
                    'description': t.description,
                    'recordedBy': t.recordedBy,
                    'createdAt': t.createdAt.toIso8601String(),
                  },
                )
                .toList(),
        },
        'consumption': {
          for (final entry in _consumptionByHousehold.entries)
            entry.key: entry.value
                .map(
                  (r) => {
                    'id': r.id,
                    'householdId': r.householdId,
                    'supplyId': r.supplyId,
                    'supplyName': r.supplyName,
                    'supplyType': r.supplyType.name,
                    'expenseId': r.expenseId,
                    'purchaseDate': r.purchaseDate.toIso8601String(),
                    'amountPaid': r.amountPaid,
                    'quantity': r.quantity,
                    'unit': r.unit,
                    'previousExhaustedState': r.previousExhaustedState.name,
                    'remainingUnits': r.remainingUnits,
                    'remainingPercentage': r.remainingPercentage,
                    'cylinderWeightKg': r.cylinderWeightKg,
                    'userEstimatedDurationDays': r.userEstimatedDurationDays,
                    'actualDepletionDate':
                        r.actualDepletionDate?.toIso8601String(),
                    'notes': r.notes,
                    'recordedBy': r.recordedBy,
                    'createdAt': r.createdAt.toIso8601String(),
                  },
                )
                .toList(),
        },
      };
      await prefs.setString(_localStorageKey, jsonEncode(payload));
    } catch (_) {
      // Ignore storage errors in unit tests where SharedPreferences is not initialized
    }
  }

  /// Restores persisted household wallets, members, transactions, and supply records
  /// from on-device SharedPreferences.
  Future<bool> restoreFromLocalStorage({String? userId}) async {
    if (userId != null && userId.isNotEmpty) {
      _activeUserId = userId;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_localStorageKey);
      if (raw == null || raw.isEmpty) return false;

      final decoded = jsonDecode(raw) as Map<String, dynamic>;

      final householdsMap = decoded['households'] as Map<String, dynamic>?;
      if (householdsMap != null) {
        _households.clear();
        for (final entry in householdsMap.entries) {
          final h = Household.fromJson(entry.value as Map<String, dynamic>);
          _households[entry.key] = h;
          _categoriesByHousehold.putIfAbsent(
            entry.key,
            () => ExpenseCategory.createDefaultCategoriesForHousehold(entry.key),
          );
          _suppliesByHousehold.putIfAbsent(
            entry.key,
            () => TrackedSupply.createDefaultsForHousehold(entry.key),
          );
          _budgetsByHousehold.putIfAbsent(entry.key, () => []);
          _billsByHousehold.putIfAbsent(entry.key, () => []);
          _notificationsByHousehold.putIfAbsent(entry.key, () => []);
          _auditLogsByHousehold.putIfAbsent(entry.key, () => []);
        }
      }

      final walletsMap = decoded['wallets'] as Map<String, dynamic>?;
      if (walletsMap != null) {
        for (final entry in walletsMap.entries) {
          final w = entry.value as Map<String, dynamic>;
          _walletsByHousehold[entry.key] = HouseholdWallet(
            id: w['id'] as String,
            householdId: w['householdId'] as String,
            totalContributions: (w['totalContributions'] as num).toDouble(),
            totalExpenses: (w['totalExpenses'] as num).toDouble(),
            totalAdjustments: (w['totalAdjustments'] as num).toDouble(),
            availableBalance: (w['availableBalance'] as num).toDouble(),
            version: (w['version'] as num?)?.toInt() ?? 1,
          );
        }
      }

      final membersMap = decoded['members'] as Map<String, dynamic>?;
      if (membersMap != null) {
        for (final entry in membersMap.entries) {
          final list = (entry.value as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(
                (m) => HouseholdMember(
                  id: m['id'] as String,
                  householdId: m['householdId'] as String,
                  linkedUserId: m['linkedUserId'] as String?,
                  displayName: m['displayName'] as String,
                  email: m['email'] as String?,
                  phoneNumber: m['phoneNumber'] as String?,
                  role: m['role'] == 'admin'
                      ? HouseholdRole.admin
                      : HouseholdRole.member,
                  avatarColor: (m['avatarColor'] as String?) ?? '#167D52',
                  joinedAt: DateTime.parse(m['joinedAt'] as String),
                ),
              )
              .toList();
          _membersByHousehold[entry.key] = list;
        }
      }

      final contribsMap = decoded['contributions'] as Map<String, dynamic>?;
      if (contribsMap != null) {
        for (final entry in contribsMap.entries) {
          final list = (entry.value as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map<Contribution>(
                (c) => Contribution(
                  id: c['id'] as String,
                  householdId: c['householdId'] as String,
                  memberId: c['memberId'] as String,
                  memberName: c['memberName'] as String,
                  recordedBy: c['recordedBy'] as String,
                  amount: (c['amount'] as num).toDouble(),
                  contributionDate:
                      DateTime.parse(c['contributionDate'] as String),
                  description: c['description'] as String?,
                  idempotencyKey: c['idempotencyKey'] as String,
                  createdAt: DateTime.parse(c['createdAt'] as String),
                ),
              )
              .toList();
          _contributionsByHousehold[entry.key] = list;
        }
      }

      final expensesMap = decoded['expenses'] as Map<String, dynamic>?;
      if (expensesMap != null) {
        for (final entry in expensesMap.entries) {
          final list = (entry.value as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(
                (e) => Expense(
                  id: e['id'] as String,
                  householdId: e['householdId'] as String,
                  categoryId: e['categoryId'] as String,
                  categoryName: e['categoryName'] as String,
                  paidByMemberId: e['paidByMemberId'] as String,
                  paidByMemberName: e['paidByMemberName'] as String,
                  recordedBy: e['recordedBy'] as String,
                  title: e['title'] as String,
                  amount: (e['amount'] as num).toDouble(),
                  expenseDate: DateTime.parse(e['expenseDate'] as String),
                  notes: e['notes'] as String?,
                  idempotencyKey: e['idempotencyKey'] as String,
                  createdAt: DateTime.parse(e['createdAt'] as String),
                ),
              )
              .toList();
          _expensesByHousehold[entry.key] = list;
        }
      }

      final txMap = decoded['transactions'] as Map<String, dynamic>?;
      if (txMap != null) {
        for (final entry in txMap.entries) {
          final list = (entry.value as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(
                (t) => WalletTransaction(
                  id: t['id'] as String,
                  householdId: t['householdId'] as String,
                  walletId: t['walletId'] as String,
                  transactionType: WalletTransactionType.values.firstWhere(
                    (v) => v.name == t['transactionType'],
                    orElse: () => WalletTransactionType.expense,
                  ),
                  referenceContributionId:
                      t['referenceContributionId'] as String?,
                  referenceExpenseId: t['referenceExpenseId'] as String?,
                  memberId: t['memberId'] as String?,
                  memberName: t['memberName'] as String,
                  categoryId: t['categoryId'] as String?,
                  categoryName: t['categoryName'] as String,
                  amount: (t['amount'] as num).toDouble(),
                  signedAmount: (t['signedAmount'] as num).toDouble(),
                  balanceBefore: (t['balanceBefore'] as num).toDouble(),
                  balanceAfter: (t['balanceAfter'] as num).toDouble(),
                  transactionDate:
                      DateTime.parse(t['transactionDate'] as String),
                  description: t['description'] as String,
                  recordedBy: t['recordedBy'] as String,
                  createdAt: DateTime.parse(t['createdAt'] as String),
                ),
              )
              .toList();
          _transactionsByHousehold[entry.key] = list;
        }
      }

      final consMap = decoded['consumption'] as Map<String, dynamic>?;
      if (consMap != null) {
        for (final entry in consMap.entries) {
          final list = (entry.value as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(
                (r) => ConsumptionRecord(
                  id: r['id'] as String,
                  householdId: r['householdId'] as String,
                  supplyId: r['supplyId'] as String,
                  supplyName: r['supplyName'] as String,
                  supplyType: SupplyType.values.firstWhere(
                    (v) => v.name == r['supplyType'],
                    orElse: () => SupplyType.grocery,
                  ),
                  expenseId: r['expenseId'] as String?,
                  purchaseDate: DateTime.parse(r['purchaseDate'] as String),
                  amountPaid: (r['amountPaid'] as num).toDouble(),
                  quantity: (r['quantity'] as num?)?.toDouble(),
                  unit: r['unit'] as String,
                  previousExhaustedState:
                      PreviousExhaustedState.values.firstWhere(
                    (v) => v.name == r['previousExhaustedState'],
                    orElse: () => PreviousExhaustedState.unknown,
                  ),
                  remainingUnits: (r['remainingUnits'] as num?)?.toDouble(),
                  remainingPercentage:
                      (r['remainingPercentage'] as num?)?.toDouble(),
                  cylinderWeightKg:
                      (r['cylinderWeightKg'] as num?)?.toDouble(),
                  userEstimatedDurationDays:
                      (r['userEstimatedDurationDays'] as num?)?.toInt(),
                  actualDepletionDate: r['actualDepletionDate'] != null
                      ? DateTime.parse(r['actualDepletionDate'] as String)
                      : null,
                  notes: r['notes'] as String?,
                  recordedBy: r['recordedBy'] as String,
                  createdAt: DateTime.parse(r['createdAt'] as String),
                ),
              )
              .toList();
          _consumptionByHousehold[entry.key] = list;
        }
      }

      for (final hId in _households.keys) {
        final supplies = _suppliesByHousehold[hId] ?? const [];
        for (final s in supplies) {
          _recomputePredictionForSupply(hId, s);
        }
        _refreshHouseholdAlerts(hId);
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}

