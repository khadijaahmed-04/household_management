import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../budgets/domain/entities/budget_entity.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../consumption/domain/entities/consumption_entities.dart';
import '../../../notifications/domain/entities/notification_entity.dart';
import '../../../predictions/domain/entities/prediction_entity.dart';
import '../../../wallet/domain/entities/wallet_entities.dart';
import '../../domain/entities/household.dart';
import '../../domain/entities/household_member.dart';

/// Snapshot of a user's households and all child ledger collections loaded from Cloud Firestore.
class FirestoreHouseholdBundle {
  final Map<String, Household> households = {};
  final Map<String, HouseholdWallet> wallets = {};
  final Map<String, List<HouseholdMember>> members = {};
  final Map<String, List<ExpenseCategory>> categories = {};
  final Map<String, List<Contribution>> contributions = {};
  final Map<String, List<Expense>> expenses = {};
  final Map<String, List<WalletTransaction>> transactions = {};
  final Map<String, List<HouseholdBudget>> budgets = {};
  final Map<String, List<TrackedSupply>> supplies = {};
  final Map<String, List<ConsumptionRecord>> consumption = {};
  final Map<String, Map<String, SupplyPrediction>> predictions = {};
  final Map<String, List<RecurringBill>> bills = {};
  final Map<String, List<HouseholdNotification>> notifications = {};
  final Map<String, List<AuditLogEntry>> auditLogs = {};
}

/// Handles Cloud Firestore persistence & synchronization for [HouseholdLedgerRepository],
/// adhering strictly to `firestore.rules` schemas and offline resilience.
class FirestoreLedgerSyncService {
  final FirebaseFirestore? _firestoreOverride;
  final FirebaseAuth? _authOverride;

  const FirestoreLedgerSyncService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestoreOverride = firestore,
        _authOverride = auth;

  bool get isAvailable {
    if (_firestoreOverride != null && _authOverride != null) return true;
    try {
      return Firebase.apps.isNotEmpty && FirebaseAuth.instance.currentUser != null;
    } catch (_) {
      return false;
    }
  }

  FirebaseFirestore get _db => _firestoreOverride ?? FirebaseFirestore.instance;
  String? get _currentUid =>
      (_authOverride ?? FirebaseAuth.instance).currentUser?.uid;

  DocumentReference<Map<String, dynamic>> _householdDoc(String householdId) =>
      _db.collection('households').doc(householdId);

  Future<FirestoreHouseholdBundle?> fetchAllForUser(String userId) async {
    if (!isAvailable) return null;
    final uid = _currentUid;
    if (uid == null || uid != userId) return null;

    final snap = await _db
        .collection('households')
        .where('memberIds', arrayContains: userId)
        .get();

    final bundle = FirestoreHouseholdBundle();
    await Future.wait(
      snap.docs.map((doc) => _loadHouseholdBundle(doc, bundle)),
    );
    return bundle;
  }

  Future<void> _loadHouseholdBundle(
    QueryDocumentSnapshot<Map<String, dynamic>> hDoc,
    FirestoreHouseholdBundle bundle,
  ) async {
    final hId = hDoc.id;
    final hData = hDoc.data();
    bundle.households[hId] = Household(
      id: hId,
      ownerId: (hData['ownerId'] ?? '') as String,
      name: (hData['name'] ?? 'Household') as String,
      description: hData['description'] as String?,
      address: hData['address'] as String?,
      currencyCode: (hData['currencyCode'] ?? 'TZS') as String,
      currencySymbol: (hData['currencySymbol'] ?? 'TSh') as String,
      timezone: (hData['timezone'] ?? 'Africa/Dar_es_Salaam') as String,
      allowOverdraft: (hData['allowOverdraft'] ?? false) as bool,
      lowBalanceThreshold:
          ((hData['lowBalanceThreshold'] ?? 25000.0) as num).toDouble(),
      isArchived: (hData['isArchived'] ?? false) as bool,
      createdAt: _parseDate(hData['createdAt']) ?? DateTime.now(),
    );

    final ref = _householdDoc(hId);
    final results = await Future.wait([
      ref.collection('wallet').get(),
      ref.collection('members').get(),
      ref.collection('categories').get(),
      ref.collection('contributions').get(),
      ref.collection('expenses').get(),
      ref.collection('transactions').get(),
      ref.collection('budgets').get(),
      ref.collection('supplies').get(),
      ref.collection('consumptionRecords').get(),
      ref.collection('predictions').get(),
      ref.collection('bills').get(),
      ref.collection('notifications').get(),
      ref.collection('auditLogs').get(),
    ]);

    final walletSnap = results[0];
    if (walletSnap.docs.isNotEmpty) {
      final wDoc = walletSnap.docs.first;
      final w = wDoc.data();
      bundle.wallets[hId] = HouseholdWallet(
        id: wDoc.id,
        householdId: hId,
        totalContributions:
            ((w['totalContributions'] ?? 0.0) as num).toDouble(),
        totalExpenses: ((w['totalExpenses'] ?? 0.0) as num).toDouble(),
        totalAdjustments: ((w['totalAdjustments'] ?? 0.0) as num).toDouble(),
        availableBalance: ((w['availableBalance'] ?? 0.0) as num).toDouble(),
        version: ((w['version'] ?? 1) as num).toInt(),
        lastTransactionAt: _parseDate(w['lastTransactionAt']),
      );
    } else {
      bundle.wallets[hId] = HouseholdWallet(
        id: 'wallet-$hId',
        householdId: hId,
        totalContributions: 0.0,
        totalExpenses: 0.0,
        totalAdjustments: 0.0,
        availableBalance: 0.0,
      );
    }

    bundle.members[hId] = results[1].docs.map((d) {
      final m = d.data();
      return HouseholdMember(
        id: d.id,
        householdId: hId,
        linkedUserId: m['linkedUserId'] as String?,
        displayName: (m['displayName'] ?? 'Member') as String,
        email: m['email'] as String?,
        phoneNumber: m['phoneNumber'] as String?,
        role: (m['role'] == 'admin') ? HouseholdRole.admin : HouseholdRole.member,
        avatarColor: (m['avatarColor'] ?? '#3B82F6') as String,
        isActive: (m['isActive'] ?? true) as bool,
        joinedAt: _parseDate(m['joinedAt']) ?? DateTime.now(),
      );
    }).toList();

    final cats = results[2].docs.map((d) {
      final c = d.data();
      return ExpenseCategory(
        id: d.id,
        householdId: hId,
        name: (c['name'] ?? 'Category') as String,
        slug: (c['slug'] ?? d.id) as String,
        iconName: (c['iconName'] ?? 'category') as String,
        colorHex: (c['colorHex'] ?? '#3B82F6') as String,
        isDefault: (c['isDefault'] ?? false) as bool,
        isActive: (c['isActive'] ?? true) as bool,
        tracksConsumption: (c['tracksConsumption'] ?? false) as bool,
        supplyType: (c['supplyType'] ?? 'none') as String,
      );
    }).toList();
    bundle.categories[hId] = cats.isNotEmpty
        ? cats
        : ExpenseCategory.createDefaultCategoriesForHousehold(hId);

    final contribs = results[3].docs.map((d) {
      final c = d.data();
      return Contribution(
        id: d.id,
        householdId: hId,
        memberId: (c['memberId'] ?? '') as String,
        memberName: (c['memberName'] ?? '') as String,
        recordedBy: (c['recordedBy'] ?? '') as String,
        amount: ((c['amount'] ?? 0.0) as num).toDouble(),
        contributionDate: _parseDate(c['contributionDate']) ?? DateTime.now(),
        description: c['description'] as String?,
        status: _parseRecordStatus(c['status'] as String?),
        idempotencyKey: (c['idempotencyKey'] ?? d.id) as String,
        createdAt: _parseDate(c['createdAt']) ?? DateTime.now(),
      );
    }).toList();

    final exps = results[4].docs.map((d) {
      final e = d.data();
      return Expense(
        id: d.id,
        householdId: hId,
        categoryId: (e['categoryId'] ?? '') as String,
        categoryName: (e['categoryName'] ?? '') as String,
        paidByMemberId: (e['paidByMemberId'] ?? '') as String,
        paidByMemberName: (e['paidByMemberName'] ?? '') as String,
        recordedBy: (e['recordedBy'] ?? '') as String,
        title: (e['title'] ?? '') as String,
        amount: ((e['amount'] ?? 0.0) as num).toDouble(),
        expenseDate: _parseDate(e['expenseDate']) ?? DateTime.now(),
        notes: e['notes'] as String?,
        receiptUrl: e['receiptUrl'] as String?,
        status: _parseRecordStatus(e['status'] as String?),
        idempotencyKey: (e['idempotencyKey'] ?? d.id) as String,
        createdAt: _parseDate(e['createdAt']) ?? DateTime.now(),
      );
    }).toList();

    final txs = results[5].docs.map((d) {
      final t = d.data();
      return WalletTransaction(
        id: d.id,
        householdId: hId,
        walletId: (t['walletId'] ?? 'wallet-$hId') as String,
        transactionType: _parseTxType(t['transactionType'] as String?),
        referenceContributionId: t['referenceContributionId'] as String?,
        referenceExpenseId: t['referenceExpenseId'] as String?,
        parentTransactionId: t['parentTransactionId'] as String?,
        memberId: t['memberId'] as String?,
        memberName: (t['memberName'] ?? 'Member') as String,
        categoryId: t['categoryId'] as String?,
        categoryName: (t['categoryName'] ?? 'General') as String,
        amount: ((t['amount'] ?? 0.0) as num).toDouble(),
        signedAmount: ((t['signedAmount'] ?? 0.0) as num).toDouble(),
        balanceBefore: ((t['balanceBefore'] ?? 0.0) as num).toDouble(),
        balanceAfter: ((t['balanceAfter'] ?? 0.0) as num).toDouble(),
        transactionDate: _parseDate(t['transactionDate']) ?? DateTime.now(),
        description: (t['description'] ?? '') as String,
        recordedBy: (t['recordedBy'] ?? '') as String,
        createdAt: _parseDate(t['createdAt']) ?? DateTime.now(),
      );
    }).toList();

    // Derive corrected/reversed statuses from adjustment/reversal transactions
    // because primary contribution/expense docs are immutable in Firestore.
    final adjustmentsByParent = <String, WalletTransaction>{};
    for (final tx in txs) {
      if (tx.parentTransactionId != null) {
        adjustmentsByParent[tx.parentTransactionId!] = tx;
      }
    }
    final adjustedStatusByRefId = <String, RecordStatus>{};
    for (final tx in txs) {
      final adj = adjustmentsByParent[tx.id];
      if (adj != null) {
        final st = adj.transactionType == WalletTransactionType.reversal
            ? RecordStatus.reversed
            : RecordStatus.corrected;
        if (tx.referenceContributionId != null) {
          adjustedStatusByRefId[tx.referenceContributionId!] = st;
        }
        if (tx.referenceExpenseId != null) {
          adjustedStatusByRefId[tx.referenceExpenseId!] = st;
        }
      }
    }
    bundle.contributions[hId] = contribs
        .map((c) => adjustedStatusByRefId.containsKey(c.id)
            ? c.copyWith(status: adjustedStatusByRefId[c.id])
            : c)
        .toList();
    bundle.expenses[hId] = exps
        .map((e) => adjustedStatusByRefId.containsKey(e.id)
            ? e.copyWith(status: adjustedStatusByRefId[e.id])
            : e)
        .toList();
    bundle.transactions[hId] = txs;

    bundle.budgets[hId] = results[6].docs.map((d) {
      final b = d.data();
      return HouseholdBudget(
        id: d.id,
        householdId: hId,
        categoryId: (b['categoryId'] ?? '') as String,
        categoryName: (b['categoryName'] ?? '') as String,
        budgetMonth: _parseDate(b['budgetMonth']) ?? DateTime.now(),
        budgetAmount: ((b['budgetAmount'] ?? 0.0) as num).toDouble(),
        alertThresholdPercent:
            ((b['alertThresholdPercent'] ?? 80.0) as num).toDouble(),
        isActive: (b['isActive'] ?? true) as bool,
      );
    }).toList();

    final sups = results[7].docs.map((d) {
      final s = d.data();
      return TrackedSupply(
        id: d.id,
        householdId: hId,
        categoryId: s['categoryId'] as String?,
        name: (s['name'] ?? '') as String,
        supplyType: _parseSupplyType(s['supplyType'] as String?),
        defaultUnit: (s['defaultUnit'] ?? 'units') as String,
        isActive: (s['isActive'] ?? true) as bool,
      );
    }).toList();
    bundle.supplies[hId] =
        sups.isNotEmpty ? sups : TrackedSupply.createDefaultsForHousehold(hId);

    bundle.consumption[hId] = results[8].docs.map((d) {
      final r = d.data();
      return ConsumptionRecord(
        id: d.id,
        householdId: hId,
        supplyId: (r['supplyId'] ?? '') as String,
        supplyName: (r['supplyName'] ?? '') as String,
        supplyType: _parseSupplyType(r['supplyType'] as String?),
        expenseId: r['expenseId'] as String?,
        purchaseDate: _parseDate(r['purchaseDate']) ?? DateTime.now(),
        amountPaid: ((r['amountPaid'] ?? 0.0) as num).toDouble(),
        quantity: (r['quantity'] as num?)?.toDouble(),
        unit: (r['unit'] ?? 'units') as String,
        previousExhaustedState:
            _parseExhaustedState(r['previousExhaustedState'] as String?),
        remainingUnits: (r['remainingUnits'] as num?)?.toDouble(),
        remainingPercentage: (r['remainingPercentage'] as num?)?.toDouble(),
        cylinderWeightKg: (r['cylinderWeightKg'] as num?)?.toDouble(),
        userEstimatedDurationDays:
            (r['userEstimatedDurationDays'] as num?)?.toInt(),
        actualDepletionDate: _parseDate(r['actualDepletionDate']),
        notes: r['notes'] as String?,
        recordedBy: (r['recordedBy'] ?? '') as String,
        createdAt: _parseDate(r['createdAt']) ?? DateTime.now(),
      );
    }).toList();

    final predMap = <String, SupplyPrediction>{};
    for (final d in results[9].docs) {
      final p = d.data();
      final sId = (p['supplyId'] ?? d.id) as String;
      predMap[sId] = SupplyPrediction(
        id: d.id,
        householdId: hId,
        supplyId: sId,
        supplyName: (p['supplyName'] ?? '') as String,
        supplyType: _parseSupplyType(p['supplyType'] as String?),
        unit: (p['unit'] ?? 'units') as String,
        sampleCount: ((p['sampleCount'] ?? 0) as num).toInt(),
        confirmedCycleCount: ((p['confirmedCycleCount'] ?? 0) as num).toInt(),
        averageIntervalDays: (p['averageIntervalDays'] as num?)?.toDouble(),
        medianIntervalDays: (p['medianIntervalDays'] as num?)?.toDouble(),
        weightedIntervalDays: (p['weightedIntervalDays'] as num?)?.toDouble(),
        intervalStdDevDays: (p['intervalStdDevDays'] as num?)?.toDouble(),
        averagePurchaseAmount: (p['averagePurchaseAmount'] as num?)?.toDouble(),
        averageDailyConsumptionUnits:
            (p['averageDailyConsumptionUnits'] as num?)?.toDouble(),
        averageDailyCost: (p['averageDailyCost'] as num?)?.toDouble(),
        lastPurchaseDate: _parseDate(p['lastPurchaseDate']),
        estimatedNextReplenishmentDate:
            _parseDate(p['estimatedNextReplenishmentDate']),
        manualOverrideDate: _parseDate(p['manualOverrideDate']),
        actualConfirmedDepletionDate:
            _parseDate(p['actualConfirmedDepletionDate']),
        confidenceLevel: _parseConfidence(p['confidenceLevel'] as String?),
        confidenceScore: ((p['confidenceScore'] ?? 0.0) as num).toDouble(),
        isMonetaryEstimateOnly: (p['isMonetaryEstimateOnly'] ?? false) as bool,
        explanation: (p['explanation'] ?? '') as String,
        trendDirection: (p['trendDirection'] ?? 'stable') as String,
        historicalIntervalsDays:
            ((p['historicalIntervalsDays'] as List?) ?? const [])
                .map((x) => (x as num).toDouble())
                .toList(),
        updatedAt: _parseDate(p['updatedAt']) ?? DateTime.now(),
      );
    }
    bundle.predictions[hId] = predMap;

    bundle.bills[hId] = results[10].docs.map((d) {
      final b = d.data();
      return RecurringBill(
        id: d.id,
        householdId: hId,
        categoryId: (b['categoryId'] ?? '') as String,
        categoryName: (b['categoryName'] ?? '') as String,
        title: (b['title'] ?? '') as String,
        providerName: b['providerName'] as String?,
        expectedAmount: ((b['expectedAmount'] ?? 0.0) as num).toDouble(),
        frequency: _parseBillingFreq(b['frequency'] as String?),
        nextDueDate: _parseDate(b['nextDueDate']) ?? DateTime.now(),
        lastPaidDate: _parseDate(b['lastPaidDate']),
        remindDaysBefore: ((b['remindDaysBefore'] ?? 3) as num).toInt(),
        isActive: (b['isActive'] ?? true) as bool,
        notes: b['notes'] as String?,
      );
    }).toList();

    bundle.notifications[hId] = results[11].docs.map((d) {
      final n = d.data();
      return HouseholdNotification(
        id: d.id,
        householdId: hId,
        type: _parseNotifType(n['type'] as String?),
        severity: _parseNotifSeverity(n['severity'] as String?),
        title: (n['title'] ?? '') as String,
        body: (n['body'] ?? '') as String,
        relatedEntityType: n['relatedEntityType'] as String?,
        relatedEntityId: n['relatedEntityId'] as String?,
        dedupKey: (n['dedupKey'] ?? d.id) as String,
        isRead: (n['isRead'] ?? false) as bool,
        isDismissed: (n['isDismissed'] ?? false) as bool,
        createdAt: _parseDate(n['createdAt']) ?? DateTime.now(),
      );
    }).toList();

    bundle.auditLogs[hId] = results[12].docs.map((d) {
      final a = d.data();
      return AuditLogEntry(
        id: d.id,
        householdId: hId,
        actorUserId: (a['actorUserId'] ?? '') as String,
        entityType: (a['entityType'] ?? '') as String,
        entityId: (a['entityId'] ?? '') as String,
        action: (a['action'] ?? '') as String,
        reason: (a['reason'] ?? '') as String,
        previousState: a['previousState'] as Map<String, dynamic>?,
        newState: a['newState'] as Map<String, dynamic>?,
        createdAt: _parseDate(a['createdAt']) ?? DateTime.now(),
      );
    }).toList();
  }

  Future<void> saveNewHousehold({
    required Household household,
    required HouseholdWallet wallet,
    required List<HouseholdMember> members,
    required List<ExpenseCategory> categories,
    required List<TrackedSupply> supplies,
    required Map<String, SupplyPrediction> predictions,
  }) async {
    if (!isAvailable) return;
    final batch = _db.batch();
    final now = Timestamp.fromDate(DateTime.now());
    final hRef = _householdDoc(household.id);

    batch.set(hRef, _householdMap(household, members, now: now, isCreate: true));
    batch.set(
      hRef.collection('wallet').doc(wallet.id),
      _walletMap(wallet, now: now, isCreate: true),
    );
    for (final m in members) {
      batch.set(
        hRef.collection('members').doc(m.id),
        _memberMap(m, now: now, isCreate: true),
      );
    }
    for (final c in categories) {
      batch.set(
        hRef.collection('categories').doc(c.id),
        _categoryMap(c, now: now, isCreate: true),
      );
    }
    for (final s in supplies) {
      batch.set(
        hRef.collection('supplies').doc(s.id),
        _supplyMap(s, now: now, isCreate: true),
      );
    }
    for (final p in predictions.values) {
      batch.set(
        hRef.collection('predictions').doc(p.supplyId),
        _predictionMap(p),
      );
    }
    await batch.commit();
  }

  Future<void> updateHousehold(
    Household household,
    List<HouseholdMember> members,
  ) async {
    if (!isAvailable) return;
    await _householdDoc(household.id).update(
      _householdMap(
        household,
        members,
        now: Timestamp.fromDate(DateTime.now()),
        isCreate: false,
      ),
    );
  }

  Future<void> deleteHousehold(String householdId) async {
    if (!isAvailable) return;
    await _householdDoc(householdId).delete();
  }

  Future<void> upsertMember(HouseholdMember member, {required bool isCreate}) async {
    if (!isAvailable) return;
    final doc = _householdDoc(member.householdId)
        .collection('members')
        .doc(member.id);
    final now = Timestamp.fromDate(DateTime.now());
    final data = _memberMap(member, now: now, isCreate: isCreate);
    if (isCreate) {
      await doc.set(data);
    } else {
      await doc.update(data);
    }
  }

  Future<void> deleteMember(
    String householdId,
    String memberId, {
    AuditLogEntry? auditLog,
  }) async {
    if (!isAvailable) return;
    final batch = _db.batch();
    final hRef = _householdDoc(householdId);
    batch.delete(hRef.collection('members').doc(memberId));
    if (auditLog != null && _currentUid != null) {
      batch.set(
        hRef.collection('auditLogs').doc(auditLog.id),
        _auditLogMap(auditLog, actorUid: _currentUid!),
      );
    }
    await batch.commit();
  }

  Future<void> upsertCategory(
    ExpenseCategory category, {
    required bool isCreate,
  }) async {
    if (!isAvailable) return;
    final doc = _householdDoc(category.householdId)
        .collection('categories')
        .doc(category.id);
    final now = Timestamp.fromDate(DateTime.now());
    final data = _categoryMap(category, now: now, isCreate: isCreate);
    if (isCreate) {
      await doc.set(data);
    } else {
      await doc.update(data);
    }
  }

  Future<void> saveContributionBundle({
    required Contribution contribution,
    required HouseholdWallet updatedWallet,
    required WalletTransaction transaction,
  }) async {
    if (!isAvailable || _currentUid == null) return;
    final uid = _currentUid!;
    final batch = _db.batch();
    final hRef = _householdDoc(contribution.householdId);
    final now = Timestamp.fromDate(DateTime.now());

    batch.set(
      hRef.collection('contributions').doc(contribution.id),
      _contributionMap(contribution, recordedByUid: uid),
    );
    batch.update(
      hRef.collection('wallet').doc(updatedWallet.id),
      _walletMap(updatedWallet, now: now, isCreate: false),
    );
    batch.set(
      hRef.collection('transactions').doc(transaction.id),
      _transactionMap(transaction, recordedByUid: uid),
    );
    await batch.commit();
  }

  Future<void> saveExpenseBundle({
    required Expense expense,
    required HouseholdWallet updatedWallet,
    required WalletTransaction transaction,
    ConsumptionRecord? autoConsumption,
    SupplyPrediction? updatedPrediction,
  }) async {
    if (!isAvailable || _currentUid == null) return;
    final uid = _currentUid!;
    final batch = _db.batch();
    final hRef = _householdDoc(expense.householdId);
    final now = Timestamp.fromDate(DateTime.now());

    batch.set(
      hRef.collection('expenses').doc(expense.id),
      _expenseMap(expense, recordedByUid: uid),
    );
    batch.update(
      hRef.collection('wallet').doc(updatedWallet.id),
      _walletMap(updatedWallet, now: now, isCreate: false),
    );
    batch.set(
      hRef.collection('transactions').doc(transaction.id),
      _transactionMap(transaction, recordedByUid: uid),
    );
    if (autoConsumption != null) {
      batch.set(
        hRef.collection('consumptionRecords').doc(autoConsumption.id),
        _consumptionMap(autoConsumption, recordedByUid: uid, now: now, isCreate: true),
      );
    }
    if (updatedPrediction != null) {
      batch.set(
        hRef.collection('predictions').doc(updatedPrediction.supplyId),
        _predictionMap(updatedPrediction),
        SetOptions(merge: true),
      );
    }
    await batch.commit();
  }

  Future<void> saveCorrectionBundle({
    required String householdId,
    required HouseholdWallet updatedWallet,
    required WalletTransaction adjustmentTransaction,
    required AuditLogEntry auditLog,
  }) async {
    if (!isAvailable || _currentUid == null) return;
    final uid = _currentUid!;
    final batch = _db.batch();
    final hRef = _householdDoc(householdId);
    final now = Timestamp.fromDate(DateTime.now());

    batch.update(
      hRef.collection('wallet').doc(updatedWallet.id),
      _walletMap(updatedWallet, now: now, isCreate: false),
    );
    batch.set(
      hRef.collection('transactions').doc(adjustmentTransaction.id),
      _transactionMap(adjustmentTransaction, recordedByUid: uid),
    );
    batch.set(
      hRef.collection('auditLogs').doc(auditLog.id),
      _auditLogMap(auditLog, actorUid: uid),
    );
    await batch.commit();
  }

  Future<void> saveTrackedSupplyBundle(
    TrackedSupply supply,
    SupplyPrediction initialPrediction,
  ) async {
    if (!isAvailable) return;
    final batch = _db.batch();
    final hRef = _householdDoc(supply.householdId);
    final now = Timestamp.fromDate(DateTime.now());

    batch.set(
      hRef.collection('supplies').doc(supply.id),
      _supplyMap(supply, now: now, isCreate: true),
    );
    batch.set(
      hRef.collection('predictions').doc(initialPrediction.supplyId),
      _predictionMap(initialPrediction),
    );
    await batch.commit();
  }

  Future<void> saveConsumptionBundle({
    required ConsumptionRecord record,
    required SupplyPrediction updatedPrediction,
    required bool isCreateRecord,
    AuditLogEntry? auditLog,
  }) async {
    if (!isAvailable || _currentUid == null) return;
    final uid = _currentUid!;
    final batch = _db.batch();
    final hRef = _householdDoc(record.householdId);
    final now = Timestamp.fromDate(DateTime.now());

    final recRef = hRef.collection('consumptionRecords').doc(record.id);
    if (isCreateRecord) {
      batch.set(
        recRef,
        _consumptionMap(record, recordedByUid: uid, now: now, isCreate: true),
      );
    } else {
      batch.update(
        recRef,
        _consumptionMap(record, recordedByUid: uid, now: now, isCreate: false),
      );
    }

    batch.set(
      hRef.collection('predictions').doc(updatedPrediction.supplyId),
      _predictionMap(updatedPrediction),
      SetOptions(merge: true),
    );
    if (auditLog != null) {
      batch.set(
        hRef.collection('auditLogs').doc(auditLog.id),
        _auditLogMap(auditLog, actorUid: uid),
      );
    }
    await batch.commit();
  }

  Future<void> saveRecurringBill(RecurringBill bill) async {
    if (!isAvailable) return;
    final doc = _householdDoc(bill.householdId).collection('bills').doc(bill.id);
    final now = Timestamp.fromDate(DateTime.now());
    await doc.set(_billMap(bill, now: now, isCreate: true), SetOptions(merge: true));
  }

  Future<void> saveBudget(HouseholdBudget budget, {required bool isCreate}) async {
    if (!isAvailable) return;
    final doc =
        _householdDoc(budget.householdId).collection('budgets').doc(budget.id);
    final now = Timestamp.fromDate(DateTime.now());
    final data = _budgetMap(budget, now: now, isCreate: isCreate);
    if (isCreate) {
      await doc.set(data);
    } else {
      await doc.update(data);
    }
  }

  Future<void> saveNotifications(
    String householdId,
    List<HouseholdNotification> notifications,
  ) async {
    if (!isAvailable || notifications.isEmpty) return;
    final batch = _db.batch();
    final hRef = _householdDoc(householdId);
    final now = Timestamp.fromDate(DateTime.now());
    for (final n in notifications) {
      batch.set(
        hRef.collection('notifications').doc(n.id),
        _notificationMap(n, now: now, isCreate: true),
      );
    }
    await batch.commit();
  }

  Future<void> updateNotificationState(HouseholdNotification notification) async {
    if (!isAvailable) return;
    await _householdDoc(notification.householdId)
        .collection('notifications')
        .doc(notification.id)
        .update({
      'isRead': notification.isRead,
      'isDismissed': notification.isDismissed,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // ---------------------------------------------------------------------------
  // SERIALIZATION HELPERS (Matching firestore.rules verbatim)
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _householdMap(
    Household h,
    List<HouseholdMember> members, {
    required Timestamp now,
    required bool isCreate,
  }) {
    final memberIds = <String>{
      h.ownerId,
      ...members.where((m) => m.isActive && m.linkedUserId != null && m.linkedUserId!.isNotEmpty).map((m) => m.linkedUserId!),
    }.toList();

    final map = <String, dynamic>{
      'memberIds': memberIds,
      'name': h.name,
      'description': _nullIfEmpty(h.description),
      'address': _nullIfEmpty(h.address),
      'currencyCode': h.currencyCode,
      'currencySymbol': h.currencySymbol,
      'timezone': h.timezone,
      'allowOverdraft': h.allowOverdraft,
      'lowBalanceThreshold': h.lowBalanceThreshold,
      'isArchived': h.isArchived,
      'updatedAt': now,
    };
    if (isCreate) {
      map['id'] = h.id;
      map['ownerId'] = h.ownerId;
      map['createdAt'] = Timestamp.fromDate(h.createdAt);
    }
    return map;
  }

  Map<String, dynamic> _walletMap(
    HouseholdWallet w, {
    required Timestamp now,
    required bool isCreate,
  }) {
    final map = <String, dynamic>{
      'totalContributions': w.totalContributions,
      'totalExpenses': w.totalExpenses,
      'totalAdjustments': w.totalAdjustments,
      'availableBalance': w.availableBalance,
      'version': w.version < 1 ? 1 : w.version,
      'lastTransactionAt': w.lastTransactionAt != null
          ? Timestamp.fromDate(w.lastTransactionAt!)
          : null,
      'updatedAt': now,
    };
    if (isCreate) {
      map['id'] = w.id;
      map['householdId'] = w.householdId;
      map['createdAt'] = now;
    }
    return map;
  }

  Map<String, dynamic> _memberMap(
    HouseholdMember m, {
    required Timestamp now,
    required bool isCreate,
  }) {
    final cleanEmail = _nullIfEmpty(m.email);
    final validEmail = (cleanEmail != null && cleanEmail.contains('@'))
        ? cleanEmail
        : null;
    final map = <String, dynamic>{
      'linkedUserId': _nullIfEmpty(m.linkedUserId),
      'displayName': m.displayName,
      'email': validEmail,
      'phoneNumber': _nullIfEmpty(m.phoneNumber),
      'role': m.role.name,
      'avatarColor': m.avatarColor,
      'isActive': m.isActive,
      'updatedAt': now,
    };
    if (isCreate) {
      map['id'] = m.id;
      map['householdId'] = m.householdId;
      map['joinedAt'] = Timestamp.fromDate(m.joinedAt);
      map['createdAt'] = now;
    }
    return map;
  }

  Map<String, dynamic> _categoryMap(
    ExpenseCategory c, {
    required Timestamp now,
    required bool isCreate,
  }) {
    final map = <String, dynamic>{
      'name': c.name,
      'slug': c.slug,
      'iconName': c.iconName,
      'colorHex': c.colorHex,
      'isDefault': c.isDefault,
      'isActive': c.isActive,
      'tracksConsumption': c.tracksConsumption,
      'supplyType': c.supplyType,
      'updatedAt': now,
    };
    if (isCreate) {
      map['id'] = c.id;
      map['householdId'] = c.householdId;
      map['createdAt'] = now;
    }
    return map;
  }

  Map<String, dynamic> _contributionMap(
    Contribution c, {
    required String recordedByUid,
  }) {
    return {
      'id': c.id,
      'householdId': c.householdId,
      'memberId': c.memberId,
      'memberName': c.memberName,
      'recordedBy': recordedByUid,
      'amount': c.amount,
      'contributionDate': Timestamp.fromDate(c.contributionDate),
      'description': _nullIfEmpty(c.description),
      'status': c.status.name,
      'idempotencyKey': c.idempotencyKey,
      'createdAt': Timestamp.fromDate(c.createdAt),
    };
  }

  Map<String, dynamic> _expenseMap(
    Expense e, {
    required String recordedByUid,
  }) {
    final validReceipt = e.receiptUrl != null &&
            (e.receiptUrl!.startsWith('https://') ||
                e.receiptUrl!.startsWith('http://'))
        ? e.receiptUrl
        : null;
    return {
      'id': e.id,
      'householdId': e.householdId,
      'categoryId': e.categoryId,
      'categoryName': e.categoryName,
      'paidByMemberId': e.paidByMemberId,
      'paidByMemberName': e.paidByMemberName,
      'recordedBy': recordedByUid,
      'title': e.title,
      'amount': e.amount,
      'expenseDate': Timestamp.fromDate(e.expenseDate),
      'notes': _nullIfEmpty(e.notes),
      'receiptUrl': validReceipt,
      'status': e.status.name,
      'idempotencyKey': e.idempotencyKey,
      'createdAt': Timestamp.fromDate(e.createdAt),
    };
  }

  Map<String, dynamic> _transactionMap(
    WalletTransaction t, {
    required String recordedByUid,
  }) {
    return {
      'id': t.id,
      'householdId': t.householdId,
      'walletId': t.walletId,
      'transactionType': t.transactionType.name,
      'referenceContributionId': _nullIfEmpty(t.referenceContributionId),
      'referenceExpenseId': _nullIfEmpty(t.referenceExpenseId),
      'parentTransactionId': _nullIfEmpty(t.parentTransactionId),
      'memberId': _nullIfEmpty(t.memberId),
      'memberName': t.memberName,
      'categoryId': _nullIfEmpty(t.categoryId),
      'categoryName': t.categoryName,
      'amount': t.amount,
      'signedAmount': t.signedAmount,
      'balanceBefore': t.balanceBefore,
      'balanceAfter': t.balanceAfter,
      'transactionDate': Timestamp.fromDate(t.transactionDate),
      'description': t.description,
      'recordedBy': recordedByUid,
      'createdAt': Timestamp.fromDate(t.createdAt),
    };
  }

  Map<String, dynamic> _budgetMap(
    HouseholdBudget b, {
    required Timestamp now,
    required bool isCreate,
  }) {
    final map = <String, dynamic>{
      'categoryId': b.categoryId,
      'categoryName': b.categoryName,
      'budgetMonth': Timestamp.fromDate(b.budgetMonth),
      'budgetAmount': b.budgetAmount,
      'alertThresholdPercent': b.alertThresholdPercent,
      'isActive': b.isActive,
      'updatedAt': now,
    };
    if (isCreate) {
      map['id'] = b.id;
      map['householdId'] = b.householdId;
      map['createdAt'] = now;
    }
    return map;
  }

  Map<String, dynamic> _supplyMap(
    TrackedSupply s, {
    required Timestamp now,
    required bool isCreate,
  }) {
    final map = <String, dynamic>{
      'categoryId': _nullIfEmpty(s.categoryId),
      'name': s.name,
      'supplyType': s.supplyType.name,
      'defaultUnit': s.defaultUnit,
      'isActive': s.isActive,
      'updatedAt': now,
    };
    if (isCreate) {
      map['id'] = s.id;
      map['householdId'] = s.householdId;
      map['createdAt'] = now;
    }
    return map;
  }

  Map<String, dynamic> _consumptionMap(
    ConsumptionRecord r, {
    required String recordedByUid,
    required Timestamp now,
    required bool isCreate,
  }) {
    final map = <String, dynamic>{
      'supplyId': r.supplyId,
      'supplyName': r.supplyName,
      'supplyType': r.supplyType.name,
      'expenseId': _nullIfEmpty(r.expenseId),
      'purchaseDate': Timestamp.fromDate(r.purchaseDate),
      'amountPaid': r.amountPaid,
      'quantity': r.quantity,
      'unit': r.unit,
      'previousExhaustedState': r.previousExhaustedState.name,
      'remainingUnits': r.remainingUnits,
      'remainingPercentage': r.remainingPercentage,
      'cylinderWeightKg': r.cylinderWeightKg,
      'userEstimatedDurationDays': r.userEstimatedDurationDays,
      'actualDepletionDate': r.actualDepletionDate != null
          ? Timestamp.fromDate(r.actualDepletionDate!)
          : null,
      'notes': _nullIfEmpty(r.notes),
      'updatedAt': now,
    };
    if (isCreate) {
      map['id'] = r.id;
      map['householdId'] = r.householdId;
      map['recordedBy'] = recordedByUid;
      map['createdAt'] = Timestamp.fromDate(r.createdAt);
    }
    return map;
  }

  Map<String, dynamic> _predictionMap(SupplyPrediction p) {
    return {
      'id': p.supplyId,
      'householdId': p.householdId,
      'supplyId': p.supplyId,
      'supplyName': p.supplyName,
      'supplyType': p.supplyType.name,
      'unit': p.unit,
      'sampleCount': p.sampleCount,
      'confirmedCycleCount': p.confirmedCycleCount,
      'averageIntervalDays': p.averageIntervalDays,
      'medianIntervalDays': p.medianIntervalDays,
      'weightedIntervalDays': p.weightedIntervalDays,
      'intervalStdDevDays': p.intervalStdDevDays,
      'averagePurchaseAmount': p.averagePurchaseAmount,
      'averageDailyConsumptionUnits': p.averageDailyConsumptionUnits,
      'averageDailyCost': p.averageDailyCost,
      'lastPurchaseDate': p.lastPurchaseDate != null
          ? Timestamp.fromDate(p.lastPurchaseDate!)
          : null,
      'estimatedNextReplenishmentDate': p.estimatedNextReplenishmentDate != null
          ? Timestamp.fromDate(p.estimatedNextReplenishmentDate!)
          : null,
      'manualOverrideDate': p.manualOverrideDate != null
          ? Timestamp.fromDate(p.manualOverrideDate!)
          : null,
      'actualConfirmedDepletionDate': p.actualConfirmedDepletionDate != null
          ? Timestamp.fromDate(p.actualConfirmedDepletionDate!)
          : null,
      'confidenceLevel': p.confidenceLevel.name,
      'confidenceScore': p.confidenceScore,
      'isMonetaryEstimateOnly': p.isMonetaryEstimateOnly,
      'explanation': p.explanation,
      'trendDirection': p.trendDirection,
      'historicalIntervalsDays': p.historicalIntervalsDays,
      'updatedAt': Timestamp.fromDate(p.updatedAt),
    };
  }

  Map<String, dynamic> _billMap(
    RecurringBill b, {
    required Timestamp now,
    required bool isCreate,
  }) {
    final map = <String, dynamic>{
      'categoryId': b.categoryId,
      'categoryName': b.categoryName,
      'title': b.title,
      'providerName': _nullIfEmpty(b.providerName),
      'expectedAmount': b.expectedAmount,
      'frequency': b.frequency.name,
      'nextDueDate': Timestamp.fromDate(b.nextDueDate),
      'lastPaidDate':
          b.lastPaidDate != null ? Timestamp.fromDate(b.lastPaidDate!) : null,
      'remindDaysBefore': b.remindDaysBefore,
      'isActive': b.isActive,
      'notes': _nullIfEmpty(b.notes),
      'updatedAt': now,
    };
    if (isCreate) {
      map['id'] = b.id;
      map['householdId'] = b.householdId;
      map['createdAt'] = now;
    }
    return map;
  }

  Map<String, dynamic> _notificationMap(
    HouseholdNotification n, {
    required Timestamp now,
    required bool isCreate,
  }) {
    final map = <String, dynamic>{
      'type': n.type.name,
      'severity': n.severity.name,
      'title': n.title,
      'body': n.body,
      'relatedEntityType': _nullIfEmpty(n.relatedEntityType),
      'relatedEntityId': _nullIfEmpty(n.relatedEntityId),
      'dedupKey': n.dedupKey,
      'isRead': n.isRead,
      'isDismissed': n.isDismissed,
      'updatedAt': now,
    };
    if (isCreate) {
      map['id'] = n.id;
      map['householdId'] = n.householdId;
      map['createdAt'] = Timestamp.fromDate(n.createdAt);
    }
    return map;
  }

  Map<String, dynamic> _auditLogMap(
    AuditLogEntry a, {
    required String actorUid,
  }) {
    return {
      'id': a.id,
      'householdId': a.householdId,
      'actorUserId': actorUid,
      'entityType': a.entityType,
      'entityId': a.entityId,
      'action': a.action,
      'reason': a.reason,
      'previousState': a.previousState,
      'newState': a.newState,
      'createdAt': Timestamp.fromDate(a.createdAt),
    };
  }

  String? _nullIfEmpty(String? v) {
    if (v == null) return null;
    final trimmed = v.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  DateTime? _parseDate(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.tryParse(v);
    return null;
  }

  RecordStatus _parseRecordStatus(String? name) {
    return RecordStatus.values.firstWhere(
      (e) => e.name == name,
      orElse: () => RecordStatus.active,
    );
  }

  WalletTransactionType _parseTxType(String? name) {
    return WalletTransactionType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => WalletTransactionType.expense,
    );
  }

  SupplyType _parseSupplyType(String? name) {
    return SupplyType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => SupplyType.grocery,
    );
  }

  PreviousExhaustedState _parseExhaustedState(String? name) {
    return PreviousExhaustedState.values.firstWhere(
      (e) => e.name == name,
      orElse: () => PreviousExhaustedState.unknown,
    );
  }

  PredictionConfidenceLevel _parseConfidence(String? name) {
    return PredictionConfidenceLevel.values.firstWhere(
      (e) => e.name == name,
      orElse: () => PredictionConfidenceLevel.insufficientData,
    );
  }

  BillingFrequency _parseBillingFreq(String? name) {
    return BillingFrequency.values.firstWhere(
      (e) => e.name == name,
      orElse: () => BillingFrequency.monthly,
    );
  }

  NotificationType _parseNotifType(String? name) {
    return NotificationType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => NotificationType.lowWalletBalance,
    );
  }

  NotificationSeverity _parseNotifSeverity(String? name) {
    return NotificationSeverity.values.firstWhere(
      (e) => e.name == name,
      orElse: () => NotificationSeverity.info,
    );
  }
}
