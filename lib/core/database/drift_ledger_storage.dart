import 'dart:convert';
import 'package:drift/drift.dart';

import '../../features/budgets/domain/entities/budget_entity.dart';
import '../../features/categories/domain/entities/expense_category.dart';
import '../../features/consumption/domain/entities/consumption_entities.dart';
import '../../features/households/domain/entities/household.dart';
import '../../features/households/domain/entities/household_member.dart';
import '../../features/notifications/domain/entities/notification_entity.dart';
import '../../features/predictions/domain/entities/prediction_entity.dart';
import '../../features/wallet/domain/entities/wallet_entities.dart';
import '../utils/currency_precision.dart';
import 'app_database.dart';

/// Structured in-memory bundle loaded directly from SQLite.
class DriftHouseholdDataBundle {
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

/// Transactional persistence adapter connecting SQLite with the domain ledger.
class DriftLedgerStorage {
  final AppDatabase _db;

  const DriftLedgerStorage(this._db);

  AppDatabase get db => _db;

  // ---------------------------------------------------------------------------
  // LOAD FOR USER (ISOLATION & OFFLINE RESTORE)
  // ---------------------------------------------------------------------------

  Future<DriftHouseholdDataBundle> loadAllForUser(String userId) async {
    final bundle = DriftHouseholdDataBundle();

    // 1. Fetch user's households
    final householdRows = await (_db.select(_db.households)
          ..where((h) => h.ownerId.equals(userId) | h.isArchived.equals(false)))
        .get();

    final allowedHouseholdIds = <String>{};

    for (final h in householdRows) {
      allowedHouseholdIds.add(h.id);
      bundle.households[h.id] = Household(
        id: h.id,
        ownerId: h.ownerId,
        name: h.name,
        description: h.description,
        address: h.address,
        currencyCode: h.currencyCode,
        currencySymbol: h.currencySymbol,
        timezone: h.timezone,
        allowOverdraft: h.allowOverdraft,
        lowBalanceThreshold:
            CurrencyPrecision.fromMinorUnits(h.lowBalanceThresholdCents),
        isArchived: h.isArchived,
        createdAt: h.createdAt,
      );
    }

    if (allowedHouseholdIds.isEmpty) return bundle;

    // 2. Load Wallets
    final walletRows = await (_db.select(_db.householdWallets)
          ..where((w) => w.householdId.isIn(allowedHouseholdIds)))
        .get();
    for (final w in walletRows) {
      bundle.wallets[w.householdId] = HouseholdWallet(
        id: w.id,
        householdId: w.householdId,
        totalContributions:
            CurrencyPrecision.fromMinorUnits(w.totalContributionsCents),
        totalExpenses: CurrencyPrecision.fromMinorUnits(w.totalExpensesCents),
        totalAdjustments:
            CurrencyPrecision.fromMinorUnits(w.totalAdjustmentsCents),
        availableBalance:
            CurrencyPrecision.fromMinorUnits(w.availableBalanceCents),
        version: w.version,
        lastTransactionAt: w.lastTransactionAt,
      );
    }

    // 3. Load Members
    final memberRows = await (_db.select(_db.householdMembers)
          ..where((m) => m.householdId.isIn(allowedHouseholdIds)))
        .get();
    for (final m in memberRows) {
      final list = bundle.members.putIfAbsent(m.householdId, () => []);
      list.add(
        HouseholdMember(
          id: m.id,
          householdId: m.householdId,
          linkedUserId: m.linkedUserId,
          displayName: m.displayName,
          email: m.email,
          phoneNumber: m.phoneNumber,
          role: m.role == 'admin' ? HouseholdRole.admin : HouseholdRole.member,
          avatarColor: m.avatarColor,
          isActive: m.isActive,
          joinedAt: m.joinedAt,
        ),
      );
    }

    // 4. Load Categories
    final categoryRows = await (_db.select(_db.expenseCategories)
          ..where((c) => c.householdId.isIn(allowedHouseholdIds)))
        .get();
    for (final c in categoryRows) {
      final list = bundle.categories.putIfAbsent(c.householdId, () => []);
      list.add(
        ExpenseCategory(
          id: c.id,
          householdId: c.householdId,
          name: c.name,
          slug: c.slug,
          iconName: c.iconName,
          colorHex: c.colorHex,
          isDefault: c.isDefault,
          isActive: c.isActive,
          tracksConsumption: c.tracksConsumption,
          supplyType: c.supplyType,
        ),
      );
    }

    // 5. Load Contributions
    final contribRows = await (_db.select(_db.contributions)
          ..where((c) => c.householdId.isIn(allowedHouseholdIds)))
        .get();
    for (final c in contribRows) {
      final list = bundle.contributions.putIfAbsent(c.householdId, () => []);
      list.add(
        Contribution(
          id: c.id,
          householdId: c.householdId,
          memberId: c.memberId,
          memberName: c.memberName,
          recordedBy: c.recordedBy,
          amount: CurrencyPrecision.fromMinorUnits(c.amountCents),
          contributionDate: c.contributionDate,
          description: c.description,
          status: _parseRecordStatus(c.status),
          idempotencyKey: c.idempotencyKey,
          createdAt: c.createdAt,
        ),
      );
    }

    // 6. Load Expenses
    final expenseRows = await (_db.select(_db.expenses)
          ..where((e) => e.householdId.isIn(allowedHouseholdIds)))
        .get();
    for (final e in expenseRows) {
      final list = bundle.expenses.putIfAbsent(e.householdId, () => []);
      list.add(
        Expense(
          id: e.id,
          householdId: e.householdId,
          categoryId: e.categoryId,
          categoryName: e.categoryName,
          paidByMemberId: e.paidByMemberId,
          paidByMemberName: e.paidByMemberName,
          recordedBy: e.recordedBy,
          title: e.title,
          amount: CurrencyPrecision.fromMinorUnits(e.amountCents),
          expenseDate: e.expenseDate,
          notes: e.notes,
          receiptUrl: e.receiptUrl,
          status: _parseRecordStatus(e.status),
          idempotencyKey: e.idempotencyKey,
          createdAt: e.createdAt,
        ),
      );
    }

    // 7. Load Transactions
    final txRows = await (_db.select(_db.walletTransactions)
          ..where((t) => t.householdId.isIn(allowedHouseholdIds)))
        .get();
    for (final t in txRows) {
      final list = bundle.transactions.putIfAbsent(t.householdId, () => []);
      list.add(
        WalletTransaction(
          id: t.id,
          householdId: t.householdId,
          walletId: t.walletId,
          transactionType: WalletTransactionType.values.firstWhere(
            (v) => v.name == t.transactionType,
            orElse: () => WalletTransactionType.expense,
          ),
          referenceContributionId: t.referenceContributionId,
          referenceExpenseId: t.referenceExpenseId,
          parentTransactionId: t.parentTransactionId,
          memberId: t.memberId,
          memberName: t.memberName,
          categoryId: t.categoryId,
          categoryName: t.categoryName,
          amount: CurrencyPrecision.fromMinorUnits(t.amountCents),
          signedAmount: CurrencyPrecision.fromMinorUnits(t.signedAmountCents),
          balanceBefore: CurrencyPrecision.fromMinorUnits(t.balanceBeforeCents),
          balanceAfter: CurrencyPrecision.fromMinorUnits(t.balanceAfterCents),
          transactionDate: t.transactionDate,
          description: t.description,
          recordedBy: t.recordedBy,
          createdAt: t.createdAt,
        ),
      );
    }

    // 8. Load Consumption
    final consRows = await (_db.select(_db.consumptionRecords)
          ..where((r) => r.householdId.isIn(allowedHouseholdIds)))
        .get();
    for (final r in consRows) {
      final list = bundle.consumption.putIfAbsent(r.householdId, () => []);
      list.add(
        ConsumptionRecord(
          id: r.id,
          householdId: r.householdId,
          supplyId: r.supplyId,
          supplyName: r.supplyName,
          supplyType: SupplyType.values.firstWhere(
            (v) => v.name == r.supplyType,
            orElse: () => SupplyType.grocery,
          ),
          expenseId: r.expenseId,
          purchaseDate: r.purchaseDate,
          amountPaid: CurrencyPrecision.fromMinorUnits(r.amountPaidCents),
          quantity: r.quantity,
          unit: r.unit,
          previousExhaustedState: PreviousExhaustedState.values.firstWhere(
            (v) => v.name == r.previousExhaustedState,
            orElse: () => PreviousExhaustedState.unknown,
          ),
          remainingUnits: r.remainingUnits,
          remainingPercentage: r.remainingPercentage,
          cylinderWeightKg: r.cylinderWeightKg,
          userEstimatedDurationDays: r.userEstimatedDurationDays,
          actualDepletionDate: r.actualDepletionDate,
          notes: r.notes,
          recordedBy: r.recordedBy,
          createdAt: r.createdAt,
        ),
      );
    }

    // 9. Load Supplies
    final supplyRows = await (_db.select(_db.trackedSupplies)
          ..where((s) => s.householdId.isIn(allowedHouseholdIds)))
        .get();
    for (final s in supplyRows) {
      final list = bundle.supplies.putIfAbsent(s.householdId, () => []);
      list.add(
        TrackedSupply(
          id: s.id,
          householdId: s.householdId,
          categoryId: s.categoryId,
          name: s.name,
          supplyType: SupplyType.values.firstWhere(
            (v) => v.name == s.supplyType,
            orElse: () => SupplyType.grocery,
          ),
          defaultUnit: s.defaultUnit,
          isActive: s.isActive,
        ),
      );
    }

    // 10. Load Budgets
    final budgetRows = await (_db.select(_db.householdBudgets)
          ..where((b) => b.householdId.isIn(allowedHouseholdIds)))
        .get();
    for (final b in budgetRows) {
      final list = bundle.budgets.putIfAbsent(b.householdId, () => []);
      list.add(
        HouseholdBudget(
          id: b.id,
          householdId: b.householdId,
          categoryId: b.categoryId,
          categoryName: b.categoryName,
          budgetMonth: b.budgetMonth,
          budgetAmount: CurrencyPrecision.fromMinorUnits(b.budgetAmountCents),
          alertThresholdPercent: b.alertThresholdPercent.toDouble(),
          isActive: b.isActive,
        ),
      );
    }

    // 11. Load Bills
    final billRows = await (_db.select(_db.recurringBills)
          ..where((b) => b.householdId.isIn(allowedHouseholdIds)))
        .get();
    for (final b in billRows) {
      final list = bundle.bills.putIfAbsent(b.householdId, () => []);
      list.add(
        RecurringBill(
          id: b.id,
          householdId: b.householdId,
          categoryId: b.categoryId,
          categoryName: b.categoryName,
          title: b.title,
          providerName: b.providerName,
          expectedAmount: CurrencyPrecision.fromMinorUnits(b.expectedAmountCents),
          frequency: BillingFrequency.values.firstWhere(
            (v) => v.name == b.frequency,
            orElse: () => BillingFrequency.monthly,
          ),
          nextDueDate: b.nextDueDate,
          remindDaysBefore: b.remindDaysBefore,
          isActive: b.isActive,
        ),
      );
    }

    // 12. Load Audit Logs
    final auditRows = await (_db.select(_db.auditLogs)
          ..where((a) => a.householdId.isIn(allowedHouseholdIds)))
        .get();
    for (final a in auditRows) {
      final list = bundle.auditLogs.putIfAbsent(a.householdId, () => []);
      list.add(
        AuditLogEntry(
          id: a.id,
          householdId: a.householdId,
          actorUserId: a.performedBy,
          entityType: a.entityType,
          entityId: a.entityId,
          action: a.action,
          reason: a.reason,
          previousState: a.beforeStateJson != null
              ? jsonDecode(a.beforeStateJson!) as Map<String, dynamic>
              : null,
          newState: a.afterStateJson != null
              ? jsonDecode(a.afterStateJson!) as Map<String, dynamic>
              : null,
          createdAt: a.timestamp,
        ),
      );
    }

    return bundle;
  }

  static RecordStatus _parseRecordStatus(String? status) {
    if (status == 'reversed') return RecordStatus.reversed;
    if (status == 'corrected') return RecordStatus.corrected;
    return RecordStatus.active;
  }

  // ---------------------------------------------------------------------------
  // TRANSACTIONAL ATOMIC MUTATIONS & QUEUEING
  // ---------------------------------------------------------------------------

  Future<void> saveContributionBundle({
    required Contribution contribution,
    required HouseholdWallet updatedWallet,
    required WalletTransaction transaction,
    required AuditLogEntry auditLog,
  }) async {
    await _db.transaction(() async {
      // 1. Insert Contribution
      await _db.into(_db.contributions).insertOnConflictUpdate(
            ContributionsCompanion.insert(
              id: contribution.id,
              householdId: contribution.householdId,
              memberId: contribution.memberId,
              memberName: contribution.memberName,
              recordedBy: contribution.recordedBy,
              amountCents:
                  CurrencyPrecision.toMinorUnits(contribution.amount),
              contributionDate: contribution.contributionDate,
              description: Value(contribution.description),
              status: Value(contribution.status.name),
              idempotencyKey: contribution.idempotencyKey,
              createdAt: contribution.createdAt,
            ),
          );

      // 2. Insert Transaction
      await _db.into(_db.walletTransactions).insertOnConflictUpdate(
            WalletTransactionsCompanion.insert(
              id: transaction.id,
              householdId: transaction.householdId,
              walletId: transaction.walletId,
              transactionType: transaction.transactionType.name,
              referenceContributionId:
                  Value(transaction.referenceContributionId),
              referenceExpenseId: Value(transaction.referenceExpenseId),
              parentTransactionId: Value(transaction.parentTransactionId),
              memberId: Value(transaction.memberId),
              memberName: transaction.memberName,
              categoryId: Value(transaction.categoryId),
              categoryName: transaction.categoryName,
              amountCents:
                  CurrencyPrecision.toMinorUnits(transaction.amount),
              signedAmountCents:
                  CurrencyPrecision.toMinorUnits(transaction.signedAmount),
              balanceBeforeCents:
                  CurrencyPrecision.toMinorUnits(transaction.balanceBefore),
              balanceAfterCents:
                  CurrencyPrecision.toMinorUnits(transaction.balanceAfter),
              transactionDate: transaction.transactionDate,
              description: transaction.description,
              recordedBy: transaction.recordedBy,
              createdAt: transaction.createdAt,
            ),
          );

      // 3. Update Wallet
      await _db.into(_db.householdWallets).insertOnConflictUpdate(
            HouseholdWalletsCompanion.insert(
              id: updatedWallet.id,
              householdId: updatedWallet.householdId,
              totalContributionsCents: Value(
                CurrencyPrecision.toMinorUnits(
                    updatedWallet.totalContributions),
              ),
              totalExpensesCents: Value(
                CurrencyPrecision.toMinorUnits(updatedWallet.totalExpenses),
              ),
              totalAdjustmentsCents: Value(
                CurrencyPrecision.toMinorUnits(
                    updatedWallet.totalAdjustments),
              ),
              availableBalanceCents: Value(
                CurrencyPrecision.toMinorUnits(
                    updatedWallet.availableBalance),
              ),
              version: Value(updatedWallet.version),
              lastTransactionAt: Value(updatedWallet.lastTransactionAt),
            ),
          );

      // 4. Insert Audit Log
      await _db.into(_db.auditLogs).insert(
            AuditLogsCompanion.insert(
              id: auditLog.id,
              householdId: auditLog.householdId,
              action: auditLog.action,
              entityType: auditLog.entityType,
              entityId: auditLog.entityId,
              performedBy: auditLog.actorUserId,
              performedByName: auditLog.actorUserId,
              reason: auditLog.reason,
              beforeStateJson: Value(auditLog.previousState != null
                  ? jsonEncode(auditLog.previousState)
                  : null),
              afterStateJson: Value(auditLog.newState != null
                  ? jsonEncode(auditLog.newState)
                  : null),
              timestamp: auditLog.createdAt,
            ),
          );

      // 5. Enqueue for Cloud Sync
      await _enqueueSyncOp(
        userId: contribution.recordedBy,
        householdId: contribution.householdId,
        entityType: 'contribution',
        entityId: contribution.id,
        operation: 'create',
        payload: {
          'contribution': {
            'id': contribution.id,
            'householdId': contribution.householdId,
            'memberId': contribution.memberId,
            'memberName': contribution.memberName,
            'recordedBy': contribution.recordedBy,
            'amount': contribution.amount,
            'contributionDate': contribution.contributionDate.toIso8601String(),
            'description': contribution.description,
            'status': contribution.status.name,
            'idempotencyKey': contribution.idempotencyKey,
            'createdAt': contribution.createdAt.toIso8601String(),
          },
          'wallet': {
            'id': updatedWallet.id,
            'householdId': updatedWallet.householdId,
            'totalContributions': updatedWallet.totalContributions,
            'totalExpenses': updatedWallet.totalExpenses,
            'totalAdjustments': updatedWallet.totalAdjustments,
            'availableBalance': updatedWallet.availableBalance,
            'version': updatedWallet.version,
          },
          'transaction': {
            'id': transaction.id,
            'householdId': transaction.householdId,
            'walletId': transaction.walletId,
            'transactionType': transaction.transactionType.name,
            'referenceContributionId': transaction.referenceContributionId,
            'memberId': transaction.memberId,
            'memberName': transaction.memberName,
            'categoryName': transaction.categoryName,
            'amount': transaction.amount,
            'signedAmount': transaction.signedAmount,
            'balanceBefore': transaction.balanceBefore,
            'balanceAfter': transaction.balanceAfter,
            'transactionDate': transaction.transactionDate.toIso8601String(),
            'description': transaction.description,
            'recordedBy': transaction.recordedBy,
            'createdAt': transaction.createdAt.toIso8601String(),
          },
        },
        idempotencyKey: contribution.idempotencyKey,
      );
    });
  }

  Future<void> saveExpenseBundle({
    required Expense expense,
    required HouseholdWallet updatedWallet,
    required WalletTransaction transaction,
    required AuditLogEntry auditLog,
    ConsumptionRecord? consumptionRecord,
  }) async {
    await _db.transaction(() async {
      // 1. Insert Expense
      await _db.into(_db.expenses).insertOnConflictUpdate(
            ExpensesCompanion.insert(
              id: expense.id,
              householdId: expense.householdId,
              categoryId: expense.categoryId,
              categoryName: expense.categoryName,
              paidByMemberId: expense.paidByMemberId,
              paidByMemberName: expense.paidByMemberName,
              recordedBy: expense.recordedBy,
              title: expense.title,
              amountCents: CurrencyPrecision.toMinorUnits(expense.amount),
              expenseDate: expense.expenseDate,
              notes: Value(expense.notes),
              receiptUrl: Value(expense.receiptUrl),
              status: Value(expense.status.name),
              idempotencyKey: expense.idempotencyKey,
              createdAt: expense.createdAt,
            ),
          );

      // 2. Insert Transaction
      await _db.into(_db.walletTransactions).insertOnConflictUpdate(
            WalletTransactionsCompanion.insert(
              id: transaction.id,
              householdId: transaction.householdId,
              walletId: transaction.walletId,
              transactionType: transaction.transactionType.name,
              referenceContributionId:
                  Value(transaction.referenceContributionId),
              referenceExpenseId: Value(transaction.referenceExpenseId),
              parentTransactionId: Value(transaction.parentTransactionId),
              memberId: Value(transaction.memberId),
              memberName: transaction.memberName,
              categoryId: Value(transaction.categoryId),
              categoryName: transaction.categoryName,
              amountCents:
                  CurrencyPrecision.toMinorUnits(transaction.amount),
              signedAmountCents:
                  CurrencyPrecision.toMinorUnits(transaction.signedAmount),
              balanceBeforeCents:
                  CurrencyPrecision.toMinorUnits(transaction.balanceBefore),
              balanceAfterCents:
                  CurrencyPrecision.toMinorUnits(transaction.balanceAfter),
              transactionDate: transaction.transactionDate,
              description: transaction.description,
              recordedBy: transaction.recordedBy,
              createdAt: transaction.createdAt,
            ),
          );

      // 3. Update Wallet
      await _db.into(_db.householdWallets).insertOnConflictUpdate(
            HouseholdWalletsCompanion.insert(
              id: updatedWallet.id,
              householdId: updatedWallet.householdId,
              totalContributionsCents: Value(
                CurrencyPrecision.toMinorUnits(
                    updatedWallet.totalContributions),
              ),
              totalExpensesCents: Value(
                CurrencyPrecision.toMinorUnits(updatedWallet.totalExpenses),
              ),
              totalAdjustmentsCents: Value(
                CurrencyPrecision.toMinorUnits(
                    updatedWallet.totalAdjustments),
              ),
              availableBalanceCents: Value(
                CurrencyPrecision.toMinorUnits(
                    updatedWallet.availableBalance),
              ),
              version: Value(updatedWallet.version),
              lastTransactionAt: Value(updatedWallet.lastTransactionAt),
            ),
          );

      // 4. Optional Consumption record
      if (consumptionRecord != null) {
        await _db.into(_db.consumptionRecords).insertOnConflictUpdate(
              ConsumptionRecordsCompanion.insert(
                id: consumptionRecord.id,
                householdId: consumptionRecord.householdId,
                supplyId: consumptionRecord.supplyId,
                supplyName: consumptionRecord.supplyName,
                supplyType: consumptionRecord.supplyType.name,
                expenseId: Value(consumptionRecord.expenseId),
                purchaseDate: consumptionRecord.purchaseDate,
                amountPaidCents: CurrencyPrecision.toMinorUnits(
                    consumptionRecord.amountPaid),
                quantity: Value(consumptionRecord.quantity),
                unit: consumptionRecord.unit,
                previousExhaustedState: Value(
                    consumptionRecord.previousExhaustedState.name),
                remainingUnits: Value(consumptionRecord.remainingUnits),
                remainingPercentage:
                    Value(consumptionRecord.remainingPercentage),
                cylinderWeightKg: Value(consumptionRecord.cylinderWeightKg),
                userEstimatedDurationDays:
                    Value(consumptionRecord.userEstimatedDurationDays),
                actualDepletionDate:
                    Value(consumptionRecord.actualDepletionDate),
                notes: Value(consumptionRecord.notes),
                recordedBy: consumptionRecord.recordedBy,
                createdAt: consumptionRecord.createdAt,
              ),
            );
      }

      // 5. Insert Audit Log
      await _db.into(_db.auditLogs).insert(
            AuditLogsCompanion.insert(
              id: auditLog.id,
              householdId: auditLog.householdId,
              action: auditLog.action,
              entityType: auditLog.entityType,
              entityId: auditLog.entityId,
              performedBy: auditLog.actorUserId,
              performedByName: auditLog.actorUserId,
              reason: auditLog.reason,
              beforeStateJson: Value(auditLog.previousState != null
                  ? jsonEncode(auditLog.previousState)
                  : null),
              afterStateJson: Value(auditLog.newState != null
                  ? jsonEncode(auditLog.newState)
                  : null),
              timestamp: auditLog.createdAt,
            ),
          );

      // 6. Enqueue for Cloud Sync
      await _enqueueSyncOp(
        userId: expense.recordedBy,
        householdId: expense.householdId,
        entityType: 'expense',
        entityId: expense.id,
        operation: 'create',
        payload: {
          'expense': {
            'id': expense.id,
            'householdId': expense.householdId,
            'categoryId': expense.categoryId,
            'categoryName': expense.categoryName,
            'paidByMemberId': expense.paidByMemberId,
            'paidByMemberName': expense.paidByMemberName,
            'recordedBy': expense.recordedBy,
            'title': expense.title,
            'amount': expense.amount,
            'expenseDate': expense.expenseDate.toIso8601String(),
            'notes': expense.notes,
            'receiptUrl': expense.receiptUrl,
            'status': expense.status.name,
            'idempotencyKey': expense.idempotencyKey,
            'createdAt': expense.createdAt.toIso8601String(),
          },
          'wallet': {
            'id': updatedWallet.id,
            'householdId': updatedWallet.householdId,
            'totalContributions': updatedWallet.totalContributions,
            'totalExpenses': updatedWallet.totalExpenses,
            'totalAdjustments': updatedWallet.totalAdjustments,
            'availableBalance': updatedWallet.availableBalance,
            'version': updatedWallet.version,
          },
          'transaction': {
            'id': transaction.id,
            'householdId': transaction.householdId,
            'walletId': transaction.walletId,
            'transactionType': transaction.transactionType.name,
            'referenceExpenseId': transaction.referenceExpenseId,
            'memberId': transaction.memberId,
            'memberName': transaction.memberName,
            'categoryId': transaction.categoryId,
            'categoryName': transaction.categoryName,
            'amount': transaction.amount,
            'signedAmount': transaction.signedAmount,
            'balanceBefore': transaction.balanceBefore,
            'balanceAfter': transaction.balanceAfter,
            'transactionDate': transaction.transactionDate.toIso8601String(),
            'description': transaction.description,
            'recordedBy': transaction.recordedBy,
            'createdAt': transaction.createdAt.toIso8601String(),
          },
        },
        idempotencyKey: expense.idempotencyKey,
      );
    });
  }

  Future<void> saveHouseholdBundle({
    required Household household,
    required HouseholdWallet wallet,
    required List<HouseholdMember> members,
    required List<ExpenseCategory> categories,
    required List<TrackedSupply> supplies,
  }) async {
    await _db.transaction(() async {
      // 1. Household
      await _db.into(_db.households).insertOnConflictUpdate(
            HouseholdsCompanion.insert(
              id: household.id,
              ownerId: household.ownerId,
              name: household.name,
              description: Value(household.description),
              address: Value(household.address),
              currencyCode: Value(household.currencyCode),
              currencySymbol: Value(household.currencySymbol),
              timezone: Value(household.timezone),
              allowOverdraft: Value(household.allowOverdraft),
              lowBalanceThresholdCents: Value(
                CurrencyPrecision.toMinorUnits(household.lowBalanceThreshold),
              ),
              isArchived: Value(household.isArchived),
              createdAt: household.createdAt,
            ),
          );

      // 2. Wallet
      await _db.into(_db.householdWallets).insertOnConflictUpdate(
            HouseholdWalletsCompanion.insert(
              id: wallet.id,
              householdId: wallet.householdId,
              totalContributionsCents: Value(
                CurrencyPrecision.toMinorUnits(wallet.totalContributions),
              ),
              totalExpensesCents: Value(
                CurrencyPrecision.toMinorUnits(wallet.totalExpenses),
              ),
              totalAdjustmentsCents: Value(
                CurrencyPrecision.toMinorUnits(wallet.totalAdjustments),
              ),
              availableBalanceCents: Value(
                CurrencyPrecision.toMinorUnits(wallet.availableBalance),
              ),
              version: Value(wallet.version),
            ),
          );

      // 3. Members
      for (final m in members) {
        await _db.into(_db.householdMembers).insertOnConflictUpdate(
              HouseholdMembersCompanion.insert(
                id: m.id,
                householdId: m.householdId,
                linkedUserId: Value(m.linkedUserId),
                displayName: m.displayName,
                email: Value(m.email),
                phoneNumber: Value(m.phoneNumber),
                role: Value(m.role.name),
                avatarColor: Value(m.avatarColor),
                isActive: Value(m.isActive),
                joinedAt: m.joinedAt,
              ),
            );
      }

      // 4. Categories
      for (final c in categories) {
        await _db.into(_db.expenseCategories).insertOnConflictUpdate(
              ExpenseCategoriesCompanion.insert(
                id: c.id,
                householdId: c.householdId,
                name: c.name,
                slug: c.slug,
                iconName: Value(c.iconName),
                colorHex: Value(c.colorHex),
                isDefault: Value(c.isDefault),
                isActive: Value(c.isActive),
                tracksConsumption: Value(c.tracksConsumption),
                supplyType: Value(c.supplyType),
                createdAt: DateTime.now(),
              ),
            );
      }

      // 5. Supplies
      for (final s in supplies) {
        await _db.into(_db.trackedSupplies).insertOnConflictUpdate(
              TrackedSuppliesCompanion.insert(
                id: s.id,
                householdId: s.householdId,
                categoryId: Value(s.categoryId),
                name: s.name,
                supplyType: s.supplyType.name,
                defaultUnit: s.defaultUnit,
                isActive: Value(s.isActive),
                createdAt: DateTime.now(),
              ),
            );
      }

      // 6. Enqueue creation
      await _enqueueSyncOp(
        userId: household.ownerId,
        householdId: household.id,
        entityType: 'household',
        entityId: household.id,
        operation: 'create',
        payload: {
          'household': household.toJson(),
          'wallet': wallet.toJson(),
          'members': members.map((m) => m.toJson()).toList(),
          'categories': categories.map((c) => c.toJson()).toList(),
          'supplies': supplies.map((s) => s.toJson()).toList(),
        },
      );
    });
  }

  Future<void> updateHouseholdRow(Household household) async {
    await (_db.update(_db.households)..where((h) => h.id.equals(household.id)))
        .write(
      HouseholdsCompanion(
        name: Value(household.name),
        description: Value(household.description),
        address: Value(household.address),
        currencyCode: Value(household.currencyCode),
        currencySymbol: Value(household.currencySymbol),
        lowBalanceThresholdCents: Value(
          CurrencyPrecision.toMinorUnits(household.lowBalanceThreshold),
        ),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _enqueueSyncOp(
      userId: household.ownerId,
      householdId: household.id,
      entityType: 'household',
      entityId: household.id,
      operation: 'update',
      payload: household.toJson(),
    );
  }

  Future<void> _enqueueSyncOp({
    required String userId,
    required String householdId,
    required String entityType,
    required String entityId,
    required String operation,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  }) async {
    await _db.into(_db.syncQueue).insert(
          SyncQueueCompanion.insert(
            userId: userId,
            householdId: householdId,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payloadJson: jsonEncode(payload),
            idempotencyKey: Value(idempotencyKey),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<int> getHouseholdCount() async {
    final count = await _db.households.count().getSingle();
    return count;
  }
}
