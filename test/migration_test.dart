import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_management/core/database/app_database.dart';
import 'package:household_management/core/database/connection/native.dart';
import 'package:household_management/core/database/migration/shared_preferences_migrator.dart';
import 'package:household_management/core/utils/currency_precision.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late SharedPreferencesToDriftMigrator migrator;

  setUp(() async {
    db = AppDatabase.forTesting(openInMemoryConnection());
    SharedPreferences.setMockInitialValues({});
    migrator = SharedPreferencesToDriftMigrator(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Migrates SharedPreferences JSON snapshot into Drift SQLite accurately and idempotently',
      () async {
    final prefs = await SharedPreferences.getInstance();
    const userId = 'user-test-01';
    const householdId = 'h-test-001';

    final snapshot = {
      'households': {
        householdId: {
          'id': householdId,
          'ownerId': userId,
          'name': 'Test Family',
          'lowBalanceThreshold': 35000.0,
          'createdAt': '2026-11-01T10:00:00.000Z',
        }
      },
      'wallets': {
        householdId: {
          'id': 'wallet-$householdId',
          'householdId': householdId,
          'totalContributions': 100000.0,
          'totalExpenses': 40000.0,
          'totalAdjustments': 0.0,
          'availableBalance': 60000.0,
          'version': 1,
        }
      },
      'members': {
        householdId: [
          {
            'id': 'm-1',
            'householdId': householdId,
            'displayName': 'Admin User',
            'role': 'admin',
            'joinedAt': '2026-11-01T10:00:00.000Z',
          }
        ]
      },
      'contributions': {
        householdId: [
          {
            'id': 'c-1',
            'householdId': householdId,
            'memberId': 'm-1',
            'memberName': 'Admin User',
            'recordedBy': userId,
            'amount': 100000.0,
            'contributionDate': '2026-11-01T12:00:00.000Z',
            'idempotencyKey': 'idemp-c-1',
            'createdAt': '2026-11-01T12:00:00.000Z',
          }
        ]
      },
      'expenses': {
        householdId: [
          {
            'id': 'e-1',
            'householdId': householdId,
            'categoryId': 'cat-1',
            'categoryName': 'LUKU',
            'paidByMemberId': 'm-1',
            'paidByMemberName': 'Admin User',
            'recordedBy': userId,
            'title': 'Electricity token',
            'amount': 40000.0,
            'expenseDate': '2026-11-02T10:00:00.000Z',
            'idempotencyKey': 'idemp-e-1',
            'createdAt': '2026-11-02T10:00:00.000Z',
          }
        ]
      },
    };

    await prefs.setString(
      'nyumbasmart_ledger_snapshot_v2_$userId',
      jsonEncode(snapshot),
    );

    // 1. First migration run
    final count = await migrator.migrateIfNecessary(userId);
    expect(count, 1);

    // Verify household row
    final households = await db.select(db.households).get();
    expect(households.length, 1);
    expect(households.first.name, 'Test Family');
    expect(
      CurrencyPrecision.fromMinorUnits(
        households.first.lowBalanceThresholdCents,
      ),
      35000.0,
    );

    // Verify wallet row and exact integer math
    final wallets = await db.select(db.householdWallets).get();
    expect(wallets.length, 1);
    expect(
      CurrencyPrecision.fromMinorUnits(wallets.first.availableBalanceCents),
      60000.0,
    );

    // Verify contributions
    final contribs = await db.select(db.contributions).get();
    expect(contribs.length, 1);
    expect(contribs.first.idempotencyKey, 'idemp-c-1');
    expect(
      CurrencyPrecision.fromMinorUnits(contribs.first.amountCents),
      100000.0,
    );

    // 2. Second migration run (idempotency check)
    final secondCount = await migrator.migrateIfNecessary(userId);
    expect(secondCount, 0); // Already migrated, skips safely

    // Ensure records are not duplicated
    final householdsAfter = await db.select(db.households).get();
    expect(householdsAfter.length, 1);
  });
}
