import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/currency_precision.dart';
import '../app_database.dart';

/// One-time, idempotent migration service transferring legacy SharedPreferences
/// JSON snapshots into Drift SQLite.
class SharedPreferencesToDriftMigrator {
  final AppDatabase _db;
  final SharedPreferences? _prefsOverride;

  static const String _snapshotPrefix = 'nyumbasmart_ledger_snapshot_v2_';
  static const String _migratedFlagPrefix = 'nyumbasmart_drift_migrated_v1_';

  const SharedPreferencesToDriftMigrator(
    this._db, {
    SharedPreferences? prefsOverride,
  }) : _prefsOverride = prefsOverride;

  Future<SharedPreferences> get _prefs async =>
      _prefsOverride ?? await SharedPreferences.getInstance();

  /// Executes idempotent migration for the given [userId].
  ///
  /// Returns the count of migrated households, or 0 if already migrated or no snapshot found.
  Future<int> migrateIfNecessary(String userId) async {
    final prefs = await _prefs;
    final migratedKey = '$_migratedFlagPrefix$userId';
    if (prefs.getBool(migratedKey) == true) {
      return 0; // Already successfully migrated
    }

    final snapshotKey = '$_snapshotPrefix$userId';
    final raw = prefs.getString(snapshotKey);
    if (raw == null || raw.isEmpty) {
      // Also check fallback 'local' snapshot key if user key is empty
      final fallbackRaw = prefs.getString('${_snapshotPrefix}local');
      if (fallbackRaw == null || fallbackRaw.isEmpty) {
        await prefs.setBool(migratedKey, true);
        return 0;
      }
      return _migrateRawJson(fallbackRaw, migratedKey);
    }

    return _migrateRawJson(raw, migratedKey);
  }

  Future<int> _migrateRawJson(String rawJson, String migratedKey) async {
    try {
      final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
      final householdsMap = decoded['households'] as Map<String, dynamic>? ?? {};
      if (householdsMap.isEmpty) {
        final prefs = await _prefs;
        await prefs.setBool(migratedKey, true);
        return 0;
      }

      await _db.transaction(() async {
        // 1. Households
        for (final entry in householdsMap.entries) {
          final h = entry.value as Map<String, dynamic>;
          final lowThreshold =
              ((h['lowBalanceThreshold'] ?? 25000.0) as num).toDouble();
          await _db.into(_db.households).insertOnConflictUpdate(
                HouseholdsCompanion.insert(
                  id: entry.key,
                  ownerId: (h['ownerId'] ?? '') as String,
                  name: (h['name'] ?? 'Household') as String,
                  description: Value(h['description'] as String?),
                  address: Value(h['address'] as String?),
                  currencyCode:
                      Value((h['currencyCode'] ?? 'TZS') as String),
                  currencySymbol:
                      Value((h['currencySymbol'] ?? 'TSh') as String),
                  timezone: Value((h['timezone'] ??
                      'Africa/Dar_es_Salaam') as String),
                  allowOverdraft:
                      Value((h['allowOverdraft'] ?? false) as bool),
                  lowBalanceThresholdCents:
                      Value(CurrencyPrecision.toMinorUnits(lowThreshold)),
                  isArchived: Value((h['isArchived'] ?? false) as bool),
                  createdAt: DateTime.parse(h['createdAt'] as String),
                  updatedAt: Value(h['updatedAt'] != null
                      ? DateTime.parse(h['updatedAt'] as String)
                      : null),
                ),
              );
        }

        // 2. Wallets
        final walletsMap = decoded['wallets'] as Map<String, dynamic>? ?? {};
        for (final entry in walletsMap.entries) {
          final w = entry.value as Map<String, dynamic>;
          await _db.into(_db.householdWallets).insertOnConflictUpdate(
                HouseholdWalletsCompanion.insert(
                  id: (w['id'] ?? 'wallet-${entry.key}') as String,
                  householdId: entry.key,
                  totalContributionsCents: Value(
                    CurrencyPrecision.toMinorUnits(
                      ((w['totalContributions'] ?? 0.0) as num).toDouble(),
                    ),
                  ),
                  totalExpensesCents: Value(
                    CurrencyPrecision.toMinorUnits(
                      ((w['totalExpenses'] ?? 0.0) as num).toDouble(),
                    ),
                  ),
                  totalAdjustmentsCents: Value(
                    CurrencyPrecision.toMinorUnits(
                      ((w['totalAdjustments'] ?? 0.0) as num).toDouble(),
                    ),
                  ),
                  availableBalanceCents: Value(
                    CurrencyPrecision.toMinorUnits(
                      ((w['availableBalance'] ?? 0.0) as num).toDouble(),
                    ),
                  ),
                  version: Value(((w['version'] ?? 1) as num).toInt()),
                  lastTransactionAt: Value(
                    w['lastTransactionAt'] != null
                        ? DateTime.parse(w['lastTransactionAt'] as String)
                        : null,
                  ),
                ),
              );
        }

        // 3. Members
        final membersMap = decoded['members'] as Map<String, dynamic>? ?? {};
        for (final entry in membersMap.entries) {
          final list = (entry.value as List<dynamic>).cast<Map<String, dynamic>>();
          for (final m in list) {
            await _db.into(_db.householdMembers).insertOnConflictUpdate(
                  HouseholdMembersCompanion.insert(
                    id: m['id'] as String,
                    householdId: entry.key,
                    linkedUserId: Value(m['linkedUserId'] as String?),
                    displayName: (m['displayName'] ?? 'Member') as String,
                    email: Value(m['email'] as String?),
                    phoneNumber: Value(m['phoneNumber'] as String?),
                    role: Value((m['role'] ?? 'member') as String),
                    avatarColor:
                        Value((m['avatarColor'] ?? '#167D52') as String),
                    isActive: Value((m['isActive'] ?? true) as bool),
                    joinedAt: DateTime.parse(m['joinedAt'] as String),
                  ),
                );
          }
        }

        // 4. Categories
        final categoriesMap =
            decoded['categories'] as Map<String, dynamic>? ?? {};
        for (final entry in categoriesMap.entries) {
          final list = (entry.value as List<dynamic>).cast<Map<String, dynamic>>();
          for (final c in list) {
            await _db.into(_db.expenseCategories).insertOnConflictUpdate(
                  ExpenseCategoriesCompanion.insert(
                    id: c['id'] as String,
                    householdId: entry.key,
                    name: (c['name'] ?? 'Category') as String,
                    slug: (c['slug'] ?? c['id']) as String,
                    iconName: Value((c['iconName'] ?? 'category') as String),
                    colorHex: Value((c['colorHex'] ?? '#167D52') as String),
                    isDefault: Value((c['isDefault'] ?? false) as bool),
                    isActive: Value((c['isActive'] ?? true) as bool),
                    tracksConsumption:
                        Value((c['tracksConsumption'] ?? false) as bool),
                    supplyType:
                        Value((c['supplyType'] ?? 'none') as String),
                    createdAt: c['createdAt'] != null
                        ? DateTime.parse(c['createdAt'] as String)
                        : DateTime.now(),
                  ),
                );
          }
        }

        // 5. Contributions
        final contribsMap =
            decoded['contributions'] as Map<String, dynamic>? ?? {};
        for (final entry in contribsMap.entries) {
          final list = (entry.value as List<dynamic>).cast<Map<String, dynamic>>();
          for (final c in list) {
            final amt = ((c['amount'] ?? 0.0) as num).toDouble();
            await _db.into(_db.contributions).insertOnConflictUpdate(
                  ContributionsCompanion.insert(
                    id: c['id'] as String,
                    householdId: entry.key,
                    memberId: (c['memberId'] ?? '') as String,
                    memberName: (c['memberName'] ?? '') as String,
                    recordedBy: (c['recordedBy'] ?? '') as String,
                    amountCents: CurrencyPrecision.toMinorUnits(amt),
                    contributionDate:
                        DateTime.parse(c['contributionDate'] as String),
                    description: Value(c['description'] as String?),
                    status: Value((c['status'] ?? 'active') as String),
                    idempotencyKey:
                        (c['idempotencyKey'] ?? c['id']) as String,
                    createdAt: DateTime.parse(c['createdAt'] as String),
                  ),
                );
          }
        }

        // 6. Expenses
        final expensesMap = decoded['expenses'] as Map<String, dynamic>? ?? {};
        for (final entry in expensesMap.entries) {
          final list = (entry.value as List<dynamic>).cast<Map<String, dynamic>>();
          for (final e in list) {
            final amt = ((e['amount'] ?? 0.0) as num).toDouble();
            await _db.into(_db.expenses).insertOnConflictUpdate(
                  ExpensesCompanion.insert(
                    id: e['id'] as String,
                    householdId: entry.key,
                    categoryId: (e['categoryId'] ?? '') as String,
                    categoryName: (e['categoryName'] ?? '') as String,
                    paidByMemberId: (e['paidByMemberId'] ?? '') as String,
                    paidByMemberName: (e['paidByMemberName'] ?? '') as String,
                    recordedBy: (e['recordedBy'] ?? '') as String,
                    title: (e['title'] ?? 'Expense') as String,
                    amountCents: CurrencyPrecision.toMinorUnits(amt),
                    expenseDate: DateTime.parse(e['expenseDate'] as String),
                    notes: Value(e['notes'] as String?),
                    receiptUrl: Value(e['receiptUrl'] as String?),
                    status: Value((e['status'] ?? 'active') as String),
                    idempotencyKey:
                        (e['idempotencyKey'] ?? e['id']) as String,
                    createdAt: DateTime.parse(e['createdAt'] as String),
                  ),
                );
          }
        }

        // 7. Transactions
        final txMap = decoded['transactions'] as Map<String, dynamic>? ?? {};
        for (final entry in txMap.entries) {
          final list = (entry.value as List<dynamic>).cast<Map<String, dynamic>>();
          for (final t in list) {
            await _db.into(_db.walletTransactions).insertOnConflictUpdate(
                  WalletTransactionsCompanion.insert(
                    id: t['id'] as String,
                    householdId: entry.key,
                    walletId: (t['walletId'] ?? 'wallet-${entry.key}') as String,
                    transactionType: (t['transactionType'] ?? 'expense') as String,
                    referenceContributionId:
                        Value(t['referenceContributionId'] as String?),
                    referenceExpenseId:
                        Value(t['referenceExpenseId'] as String?),
                    parentTransactionId:
                        Value(t['parentTransactionId'] as String?),
                    memberId: Value(t['memberId'] as String?),
                    memberName: (t['memberName'] ?? '') as String,
                    categoryId: Value(t['categoryId'] as String?),
                    categoryName: (t['categoryName'] ?? '') as String,
                    amountCents: CurrencyPrecision.toMinorUnits(
                      ((t['amount'] ?? 0.0) as num).toDouble(),
                    ),
                    signedAmountCents: CurrencyPrecision.toMinorUnits(
                      ((t['signedAmount'] ?? 0.0) as num).toDouble(),
                    ),
                    balanceBeforeCents: CurrencyPrecision.toMinorUnits(
                      ((t['balanceBefore'] ?? 0.0) as num).toDouble(),
                    ),
                    balanceAfterCents: CurrencyPrecision.toMinorUnits(
                      ((t['balanceAfter'] ?? 0.0) as num).toDouble(),
                    ),
                    transactionDate:
                        DateTime.parse(t['transactionDate'] as String),
                    description: (t['description'] ?? '') as String,
                    recordedBy: (t['recordedBy'] ?? '') as String,
                    createdAt: DateTime.parse(t['createdAt'] as String),
                  ),
                );
          }
        }

        // 8. Consumption Records
        final consMap = decoded['consumption'] as Map<String, dynamic>? ?? {};
        for (final entry in consMap.entries) {
          final list = (entry.value as List<dynamic>).cast<Map<String, dynamic>>();
          for (final r in list) {
            final amt = ((r['amountPaid'] ?? 0.0) as num).toDouble();
            await _db.into(_db.consumptionRecords).insertOnConflictUpdate(
                  ConsumptionRecordsCompanion.insert(
                    id: r['id'] as String,
                    householdId: entry.key,
                    supplyId: (r['supplyId'] ?? '') as String,
                    supplyName: (r['supplyName'] ?? '') as String,
                    supplyType: (r['supplyType'] ?? 'grocery') as String,
                    expenseId: Value(r['expenseId'] as String?),
                    purchaseDate: DateTime.parse(r['purchaseDate'] as String),
                    amountPaidCents: CurrencyPrecision.toMinorUnits(amt),
                    quantity: Value((r['quantity'] as num?)?.toDouble()),
                    unit: (r['unit'] ?? '') as String,
                    previousExhaustedState: Value(
                        (r['previousExhaustedState'] ?? 'unknown') as String),
                    remainingUnits:
                        Value((r['remainingUnits'] as num?)?.toDouble()),
                    remainingPercentage:
                        Value((r['remainingPercentage'] as num?)?.toDouble()),
                    cylinderWeightKg:
                        Value((r['cylinderWeightKg'] as num?)?.toDouble()),
                    userEstimatedDurationDays: Value(
                        (r['userEstimatedDurationDays'] as num?)?.toInt()),
                    actualDepletionDate: Value(r['actualDepletionDate'] != null
                        ? DateTime.parse(r['actualDepletionDate'] as String)
                        : null),
                    notes: Value(r['notes'] as String?),
                    recordedBy: (r['recordedBy'] ?? '') as String,
                    createdAt: DateTime.parse(r['createdAt'] as String),
                  ),
                );
          }
        }

        // 9. Supplies
        final suppliesMap = decoded['supplies'] as Map<String, dynamic>? ?? {};
        for (final entry in suppliesMap.entries) {
          final list = (entry.value as List<dynamic>).cast<Map<String, dynamic>>();
          for (final s in list) {
            await _db.into(_db.trackedSupplies).insertOnConflictUpdate(
                  TrackedSuppliesCompanion.insert(
                    id: s['id'] as String,
                    householdId: entry.key,
                    categoryId: Value(s['categoryId'] as String?),
                    name: (s['name'] ?? '') as String,
                    supplyType: (s['supplyType'] ?? 'grocery') as String,
                    defaultUnit: (s['defaultUnit'] ?? '') as String,
                    isActive: Value((s['isActive'] ?? true) as bool),
                    createdAt: s['createdAt'] != null
                        ? DateTime.parse(s['createdAt'] as String)
                        : DateTime.now(),
                  ),
                );
          }
        }

        // 10. Budgets
        final budgetsMap = decoded['budgets'] as Map<String, dynamic>? ?? {};
        for (final entry in budgetsMap.entries) {
          final list = (entry.value as List<dynamic>).cast<Map<String, dynamic>>();
          for (final b in list) {
            final amt = ((b['budgetAmount'] ?? 0.0) as num).toDouble();
            await _db.into(_db.householdBudgets).insertOnConflictUpdate(
                  HouseholdBudgetsCompanion.insert(
                    id: b['id'] as String,
                    householdId: entry.key,
                    categoryId: (b['categoryId'] ?? '') as String,
                    categoryName: (b['categoryName'] ?? '') as String,
                    budgetMonth: DateTime.parse(b['budgetMonth'] as String),
                    budgetAmountCents: CurrencyPrecision.toMinorUnits(amt),
                    alertThresholdPercent: Value(
                        ((b['alertThresholdPercent'] ?? 80) as num).toInt()),
                    isActive: Value((b['isActive'] ?? true) as bool),
                    createdAt: b['createdAt'] != null
                        ? DateTime.parse(b['createdAt'] as String)
                        : DateTime.now(),
                  ),
                );
          }
        }

        // 11. Recurring Bills
        final billsMap = decoded['bills'] as Map<String, dynamic>? ?? {};
        for (final entry in billsMap.entries) {
          final list = (entry.value as List<dynamic>).cast<Map<String, dynamic>>();
          for (final b in list) {
            final amt = ((b['expectedAmount'] ?? 0.0) as num).toDouble();
            await _db.into(_db.recurringBills).insertOnConflictUpdate(
                  RecurringBillsCompanion.insert(
                    id: b['id'] as String,
                    householdId: entry.key,
                    categoryId: (b['categoryId'] ?? '') as String,
                    categoryName: (b['categoryName'] ?? '') as String,
                    title: (b['title'] ?? 'Bill') as String,
                    providerName: Value(b['providerName'] as String?),
                    expectedAmountCents: CurrencyPrecision.toMinorUnits(amt),
                    frequency: (b['frequency'] ?? 'monthly') as String,
                    nextDueDate: DateTime.parse(b['nextDueDate'] as String),
                    remindDaysBefore: Value(
                        ((b['remindDaysBefore'] ?? 3) as num).toInt()),
                    isActive: Value((b['isActive'] ?? true) as bool),
                    createdAt: b['createdAt'] != null
                        ? DateTime.parse(b['createdAt'] as String)
                        : DateTime.now(),
                  ),
                );
          }
        }

        // 12. Audit Logs
        final auditMap = decoded['auditLogs'] as Map<String, dynamic>? ?? {};
        for (final entry in auditMap.entries) {
          final list = (entry.value as List<dynamic>).cast<Map<String, dynamic>>();
          for (final a in list) {
            await _db.into(_db.auditLogs).insertOnConflictUpdate(
                  AuditLogsCompanion.insert(
                    id: a['id'] as String,
                    householdId: entry.key,
                    action: (a['action'] ?? '') as String,
                    entityType: (a['entityType'] ?? '') as String,
                    entityId: (a['entityId'] ?? '') as String,
                    performedBy: (a['performedBy'] ?? '') as String,
                    performedByName: (a['performedByName'] ?? '') as String,
                    reason: (a['reason'] ?? '') as String,
                    beforeStateJson: Value(a['beforeStateJson'] as String?),
                    afterStateJson: Value(a['afterStateJson'] as String?),
                    timestamp: DateTime.parse(a['timestamp'] as String),
                  ),
                );
          }
        }
      });

      final prefs = await _prefs;
      await prefs.setBool(migratedKey, true);
      return householdsMap.length;
    } catch (_) {
      // If error occurs, transaction rolls back and migration flag is NOT set.
      return 0;
    }
  }
}
