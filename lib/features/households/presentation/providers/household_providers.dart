import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../budgets/domain/entities/budget_entity.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../consumption/domain/entities/consumption_entities.dart';
import '../../../notifications/domain/entities/notification_entity.dart';
import '../../../predictions/domain/entities/prediction_entity.dart';
import '../../../wallet/domain/entities/wallet_entities.dart';
import '../../data/repositories/household_ledger_repository.dart';
import '../../domain/entities/household.dart';
import '../../domain/entities/household_member.dart';

final householdLedgerRepositoryProvider =
    Provider<HouseholdLedgerRepository>((ref) {
  return HouseholdLedgerRepository(initializeDemoSeed: false);
});

/// Incremented whenever a financial or consumption operation mutates repository state
/// so all dependent providers refresh immediately.
final ledgerRevisionProvider = StateProvider<int>((ref) => 0);

final currentUserIdProvider = Provider<String>((ref) {
  final authUser = ref.watch(authControllerProvider).valueOrNull;
  return authUser?.id ?? '';
});

final userHouseholdsProvider = Provider<List<Household>>((ref) {
  ref.watch(ledgerRevisionProvider);
  final userId = ref.watch(currentUserIdProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  return repo.getHouseholdsForUser(userId);
});

final selectedHouseholdIdProvider = StateProvider<String?>((ref) => null);

final activeHouseholdProvider = Provider<Household?>((ref) {
  final households = ref.watch(userHouseholdsProvider);
  if (households.isEmpty) return null;
  final selectedId = ref.watch(selectedHouseholdIdProvider);
  if (selectedId != null) {
    final match = households.where((h) => h.id == selectedId).firstOrNull;
    if (match != null) return match;
  }
  return households.first;
});

final activeHouseholdWalletProvider = Provider<HouseholdWallet?>((ref) {
  ref.watch(ledgerRevisionProvider);
  final household = ref.watch(activeHouseholdProvider);
  if (household == null) return null;
  final userId = ref.watch(currentUserIdProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  return repo.getWallet(householdId: household.id, actorUserId: userId);
});

final activeHouseholdMembersProvider = Provider<List<HouseholdMember>>((ref) {
  ref.watch(ledgerRevisionProvider);
  final household = ref.watch(activeHouseholdProvider);
  if (household == null) return const [];
  final userId = ref.watch(currentUserIdProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  return repo.getMembers(householdId: household.id, actorUserId: userId);
});

final activeHouseholdCategoriesProvider =
    Provider<List<ExpenseCategory>>((ref) {
  ref.watch(ledgerRevisionProvider);
  final household = ref.watch(activeHouseholdProvider);
  if (household == null) return const [];
  final userId = ref.watch(currentUserIdProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  return repo.getCategories(householdId: household.id, actorUserId: userId);
});

final activeHouseholdContributionsProvider =
    Provider<List<Contribution>>((ref) {
  ref.watch(ledgerRevisionProvider);
  final household = ref.watch(activeHouseholdProvider);
  if (household == null) return const [];
  final userId = ref.watch(currentUserIdProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  return repo.getContributions(householdId: household.id, actorUserId: userId);
});

final activeHouseholdExpensesProvider = Provider<List<Expense>>((ref) {
  ref.watch(ledgerRevisionProvider);
  final household = ref.watch(activeHouseholdProvider);
  if (household == null) return const [];
  final userId = ref.watch(currentUserIdProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  return repo.getExpenses(householdId: household.id, actorUserId: userId);
});

class TransactionFilterState {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? memberId;
  final String? categoryId;
  final WalletTransactionType? transactionType;

  const TransactionFilterState({
    this.startDate,
    this.endDate,
    this.memberId,
    this.categoryId,
    this.transactionType,
  });

  TransactionFilterState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? memberId,
    String? categoryId,
    WalletTransactionType? transactionType,
    bool clearMember = false,
    bool clearCategory = false,
    bool clearType = false,
    bool clearDates = false,
  }) {
    return TransactionFilterState(
      startDate: clearDates ? null : (startDate ?? this.startDate),
      endDate: clearDates ? null : (endDate ?? this.endDate),
      memberId: clearMember ? null : (memberId ?? this.memberId),
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      transactionType:
          clearType ? null : (transactionType ?? this.transactionType),
    );
  }
}

final transactionFilterProvider = StateProvider<TransactionFilterState>(
  (ref) => const TransactionFilterState(),
);

final activeHouseholdTransactionsProvider =
    Provider<List<WalletTransaction>>((ref) {
  ref.watch(ledgerRevisionProvider);
  final household = ref.watch(activeHouseholdProvider);
  if (household == null) return const [];
  final userId = ref.watch(currentUserIdProvider);
  final filter = ref.watch(transactionFilterProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  return repo.getWalletTransactions(
    householdId: household.id,
    actorUserId: userId,
    startDate: filter.startDate,
    endDate: filter.endDate,
    memberId: filter.memberId,
    categoryId: filter.categoryId,
    transactionType: filter.transactionType,
  );
});

final activeHouseholdAuditLogsProvider = Provider<List<AuditLogEntry>>((ref) {
  ref.watch(ledgerRevisionProvider);
  final household = ref.watch(activeHouseholdProvider);
  if (household == null) return const [];
  final userId = ref.watch(currentUserIdProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  return repo.getAuditLogs(householdId: household.id, actorUserId: userId);
});

final activeHouseholdSuppliesProvider = Provider<List<TrackedSupply>>((ref) {
  ref.watch(ledgerRevisionProvider);
  final household = ref.watch(activeHouseholdProvider);
  if (household == null) return const [];
  final userId = ref.watch(currentUserIdProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  return repo.getTrackedSupplies(
    householdId: household.id,
    actorUserId: userId,
  );
});

final activeHouseholdConsumptionRecordsProvider =
    Provider<List<ConsumptionRecord>>((ref) {
  ref.watch(ledgerRevisionProvider);
  final household = ref.watch(activeHouseholdProvider);
  if (household == null) return const [];
  final userId = ref.watch(currentUserIdProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  return repo.getConsumptionRecords(
    householdId: household.id,
    actorUserId: userId,
  );
});

final activeHouseholdPredictionsProvider =
    Provider<List<SupplyPrediction>>((ref) {
  ref.watch(ledgerRevisionProvider);
  final household = ref.watch(activeHouseholdProvider);
  if (household == null) return const [];
  final userId = ref.watch(currentUserIdProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  return repo.getPredictions(householdId: household.id, actorUserId: userId);
});

final activeHouseholdRecurringBillsProvider =
    Provider<List<RecurringBill>>((ref) {
  ref.watch(ledgerRevisionProvider);
  final household = ref.watch(activeHouseholdProvider);
  if (household == null) return const [];
  final userId = ref.watch(currentUserIdProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  return repo.getRecurringBills(householdId: household.id, actorUserId: userId);
});

final selectedReportMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

final activeHouseholdBudgetsProvider =
    Provider<List<CategoryBudgetStatus>>((ref) {
  ref.watch(ledgerRevisionProvider);
  final household = ref.watch(activeHouseholdProvider);
  if (household == null) return const [];
  final userId = ref.watch(currentUserIdProvider);
  final month = ref.watch(selectedReportMonthProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  return repo.getBudgetStatusesForMonth(
    householdId: household.id,
    actorUserId: userId,
    month: month,
  );
});

final activeHouseholdNotificationsProvider =
    Provider<List<HouseholdNotification>>((ref) {
  ref.watch(ledgerRevisionProvider);
  final household = ref.watch(activeHouseholdProvider);
  if (household == null) return const [];
  final userId = ref.watch(currentUserIdProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  return repo.getNotifications(householdId: household.id, actorUserId: userId);
});

final activeHouseholdMonthlySummaryProvider =
    Provider<MonthlyFinancialSummary?>((ref) {
  ref.watch(ledgerRevisionProvider);
  final household = ref.watch(activeHouseholdProvider);
  if (household == null) return null;
  final userId = ref.watch(currentUserIdProvider);
  final month = ref.watch(selectedReportMonthProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  return repo.getMonthlySummary(
    householdId: household.id,
    actorUserId: userId,
    month: month,
  );
});

