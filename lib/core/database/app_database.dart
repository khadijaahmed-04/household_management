import 'package:drift/drift.dart';

import 'connection/native.dart' as conn;
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Households,
  HouseholdMembers,
  ExpenseCategories,
  HouseholdWallets,
  Contributions,
  Expenses,
  WalletTransactions,
  HouseholdBudgets,
  TrackedSupplies,
  ConsumptionRecords,
  SupplyPredictions,
  RecurringBills,
  HouseholdNotifications,
  AuditLogs,
  SyncQueue,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? conn.openConnection()) {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  AppDatabase.forTesting(super.connection) {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // Future migrations handled incrementally here
        },
      );
}
