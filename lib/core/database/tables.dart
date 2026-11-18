import 'package:drift/drift.dart';

/// 1. Households Table
@DataClassName('HouseholdRow')
class Households extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get currencyCode => text().withDefault(const Constant('TZS'))();
  TextColumn get currencySymbol => text().withDefault(const Constant('TSh'))();
  TextColumn get timezone =>
      text().withDefault(const Constant('Africa/Dar_es_Salaam'))();
  BoolColumn get allowOverdraft =>
      boolean().withDefault(const Constant(false))();
  IntColumn get lowBalanceThresholdCents =>
      integer().withDefault(const Constant(2500000))(); // 25,000 * 100
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 2. Household Members Table
@DataClassName('HouseholdMemberRow')
class HouseholdMembers extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get linkedUserId => text().nullable()();
  TextColumn get displayName => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get role => text().withDefault(const Constant('member'))();
  TextColumn get avatarColor =>
      text().withDefault(const Constant('#167D52'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get joinedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 3. Expense Categories Table
@DataClassName('ExpenseCategoryRow')
class ExpenseCategories extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get name => text()();
  TextColumn get slug => text()();
  TextColumn get iconName =>
      text().withDefault(const Constant('category'))();
  TextColumn get colorHex =>
      text().withDefault(const Constant('#167D52'))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get tracksConsumption =>
      boolean().withDefault(const Constant(false))();
  TextColumn get supplyType =>
      text().withDefault(const Constant('none'))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 4. Household Wallets Table
@DataClassName('HouseholdWalletRow')
class HouseholdWallets extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text().unique()();
  IntColumn get totalContributionsCents =>
      integer().withDefault(const Constant(0))();
  IntColumn get totalExpensesCents =>
      integer().withDefault(const Constant(0))();
  IntColumn get totalAdjustmentsCents =>
      integer().withDefault(const Constant(0))();
  IntColumn get availableBalanceCents =>
      integer().withDefault(const Constant(0))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastTransactionAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 5. Contributions Table (Immutable Financial Ledger)
@DataClassName('ContributionRow')
class Contributions extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get memberId => text()();
  TextColumn get memberName => text()();
  TextColumn get recordedBy => text()();
  IntColumn get amountCents => integer()();
  DateTimeColumn get contributionDate => dateTime()();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get idempotencyKey => text().unique()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 6. Expenses Table (Immutable Financial Ledger)
@DataClassName('ExpenseRow')
class Expenses extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get categoryId => text()();
  TextColumn get categoryName => text()();
  TextColumn get paidByMemberId => text()();
  TextColumn get paidByMemberName => text()();
  TextColumn get recordedBy => text()();
  TextColumn get title => text()();
  IntColumn get amountCents => integer()();
  DateTimeColumn get expenseDate => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get receiptUrl => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get idempotencyKey => text().unique()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 7. Wallet Transactions Table (Strict Ledger Journal)
@DataClassName('WalletTransactionRow')
class WalletTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get walletId => text()();
  TextColumn get transactionType => text()();
  TextColumn get referenceContributionId => text().nullable()();
  TextColumn get referenceExpenseId => text().nullable()();
  TextColumn get parentTransactionId => text().nullable()();
  TextColumn get memberId => text().nullable()();
  TextColumn get memberName => text()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get categoryName => text()();
  IntColumn get amountCents => integer()();
  IntColumn get signedAmountCents => integer()();
  IntColumn get balanceBeforeCents => integer()();
  IntColumn get balanceAfterCents => integer()();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get description => text()();
  TextColumn get recordedBy => text()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 8. Household Budgets Table
@DataClassName('HouseholdBudgetRow')
class HouseholdBudgets extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get categoryId => text()();
  TextColumn get categoryName => text()();
  DateTimeColumn get budgetMonth => dateTime()();
  IntColumn get budgetAmountCents => integer()();
  IntColumn get alertThresholdPercent =>
      integer().withDefault(const Constant(80))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 9. Tracked Supplies Table
@DataClassName('TrackedSupplyRow')
class TrackedSupplies extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get supplyType => text()();
  TextColumn get defaultUnit => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 10. Consumption Records Table
@DataClassName('ConsumptionRecordRow')
class ConsumptionRecords extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get supplyId => text()();
  TextColumn get supplyName => text()();
  TextColumn get supplyType => text()();
  TextColumn get expenseId => text().nullable()();
  DateTimeColumn get purchaseDate => dateTime()();
  IntColumn get amountPaidCents => integer()();
  RealColumn get quantity => real().nullable()();
  TextColumn get unit => text()();
  TextColumn get previousExhaustedState =>
      text().withDefault(const Constant('unknown'))();
  RealColumn get remainingUnits => real().nullable()();
  RealColumn get remainingPercentage => real().nullable()();
  RealColumn get cylinderWeightKg => real().nullable()();
  IntColumn get userEstimatedDurationDays => integer().nullable()();
  DateTimeColumn get actualDepletionDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get recordedBy => text()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 11. Supply Predictions Table
@DataClassName('SupplyPredictionRow')
class SupplyPredictions extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get supplyId => text().unique()();
  TextColumn get supplyName => text()();
  TextColumn get supplyType => text()();
  TextColumn get unit => text()();
  IntColumn get sampleCount => integer().withDefault(const Constant(0))();
  IntColumn get confirmedCycleCount =>
      integer().withDefault(const Constant(0))();
  RealColumn get averageIntervalDays => real().nullable()();
  RealColumn get medianIntervalDays => real().nullable()();
  RealColumn get weightedIntervalDays => real().nullable()();
  RealColumn get intervalStdDevDays => real().nullable()();
  IntColumn get averagePurchaseAmountCents => integer().nullable()();
  RealColumn get averageDailyConsumptionUnits => real().nullable()();
  IntColumn get averageDailyCostCents => integer().nullable()();
  DateTimeColumn get lastPurchaseDate => dateTime().nullable()();
  DateTimeColumn get estimatedNextReplenishmentDate => dateTime().nullable()();
  DateTimeColumn get manualOverrideDate => dateTime().nullable()();
  DateTimeColumn get actualConfirmedDepletionDate => dateTime().nullable()();
  TextColumn get confidenceLevel =>
      text().withDefault(const Constant('insufficientData'))();
  IntColumn get confidenceScore => integer().withDefault(const Constant(0))();
  BoolColumn get isMonetaryEstimateOnly =>
      boolean().withDefault(const Constant(true))();
  TextColumn get explanation => text()();
  TextColumn get trendDirection =>
      text().withDefault(const Constant('stable'))();
  TextColumn get historicalIntervalsJson =>
      text().withDefault(const Constant('[]'))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 12. Recurring Bills Table
@DataClassName('RecurringBillRow')
class RecurringBills extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get categoryId => text()();
  TextColumn get categoryName => text()();
  TextColumn get title => text()();
  TextColumn get providerName => text().nullable()();
  IntColumn get expectedAmountCents => integer()();
  TextColumn get frequency => text()();
  DateTimeColumn get nextDueDate => dateTime()();
  IntColumn get remindDaysBefore =>
      integer().withDefault(const Constant(3))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 13. Household Notifications Table
@DataClassName('HouseholdNotificationRow')
class HouseholdNotifications extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get type => text()();
  TextColumn get severity => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get relatedEntityType => text().nullable()();
  TextColumn get relatedEntityId => text().nullable()();
  TextColumn get dedupKey => text().unique()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  BoolColumn get isDismissed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 14. Audit Logs Table (Immutable History)
@DataClassName('AuditLogRow')
class AuditLogs extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get action => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get performedBy => text()();
  TextColumn get performedByName => text()();
  TextColumn get reason => text()();
  TextColumn get beforeStateJson => text().nullable()();
  TextColumn get afterStateJson => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 15. Offline Sync Queue Table
@DataClassName('SyncQueueRow')
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  TextColumn get householdId => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()(); // 'create' | 'update' | 'delete'
  TextColumn get payloadJson => text()();
  TextColumn get idempotencyKey => text().nullable()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending | in_progress | failed | completed
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
