import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:household_management/core/database/app_database.dart';
import 'package:household_management/core/database/connection/native.dart';
import 'package:household_management/core/database/drift_ledger_storage.dart';
import 'package:household_management/core/errors/app_exceptions.dart';
import 'package:household_management/core/utils/currency_precision.dart';
import 'package:household_management/features/households/data/repositories/household_ledger_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late DriftLedgerStorage storage;
  late HouseholdLedgerRepository repository;

  const userA = 'user-admin-alice-01';
  const userB = 'user-admin-bob-02';

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase.forTesting(openInMemoryConnection());
    storage = DriftLedgerStorage(db);
    repository = HouseholdLedgerRepository(
      db: db,
      driftStorage: storage,
      initializeDemoSeed: false,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift SQLite Offline-First & Financial Precision Tests', () {
    test('Recording contribution offline saves to SQLite with integer precision and queues sync',
        () async {
      // 1. Create household for User A
      final household = await repository.createHousehold(
        ownerId: userA,
        adminDisplayName: 'Alice',
        name: 'Alice Household',
      );

      final members = repository.getMembers(
        householdId: household.id,
        actorUserId: userA,
      );
      final aliceMember = members.first;

      // 2. Record contribution of TSh 150,000
      final contribution = await repository.recordContribution(
        householdId: household.id,
        actorUserId: userA,
        memberId: aliceMember.id,
        amount: 150000.0,
        contributionDate: DateTime(2026, 11, 10),
        description: 'November budget top-up',
        idempotencyKey: 'idemp-alice-c-1',
      );

      expect(contribution.amount, 150000.0);

      // 3. Verify SQLite stored exact integer minor units (150,000 * 100 = 15,000,000 cents)
      final contribRows = await db.select(db.contributions).get();
      expect(contribRows.length, 1);
      expect(contribRows.first.amountCents, 15000000);
      expect(
        CurrencyPrecision.fromMinorUnits(contribRows.first.amountCents),
        150000.0,
      );

      // 4. Verify wallet row balance in SQLite
      final walletRows = await db.select(db.householdWallets).get();
      expect(walletRows.length, 1);
      expect(walletRows.first.availableBalanceCents, 15000000);

      // 5. Verify operation was queued in SyncQueue for cloud sync
      final queueRows = await db.select(db.syncQueue).get();
      expect(queueRows.any((q) => q.entityType == 'contribution'), isTrue);
    });

    test('Recording expense offline enforces non-negative balance guard and integer math',
        () async {
      final household = await repository.createHousehold(
        ownerId: userA,
        adminDisplayName: 'Alice',
        name: 'Alice Household',
      );
      final members = repository.getMembers(
        householdId: household.id,
        actorUserId: userA,
      );
      final categories = repository.getCategories(
        householdId: household.id,
        actorUserId: userA,
      );

      // Attempt expense of TSh 50,000 when wallet is 0 -> Must throw InsufficientBalanceException
      expect(
        () => repository.recordExpense(
          householdId: household.id,
          actorUserId: userA,
          categoryId: categories.first.id,
          paidByMemberId: members.first.id,
          title: 'Electricity token',
          amount: 50000.0,
          expenseDate: DateTime(2026, 11, 11),
        ),
        throwsA(isA<InsufficientBalanceException>()),
      );

      // Fund wallet with TSh 100,000
      await repository.recordContribution(
        householdId: household.id,
        actorUserId: userA,
        memberId: members.first.id,
        amount: 100000.0,
        contributionDate: DateTime(2026, 11, 10),
      );

      // Now record valid expense of TSh 35,000
      final expense = await repository.recordExpense(
        householdId: household.id,
        actorUserId: userA,
        categoryId: categories.first.id,
        paidByMemberId: members.first.id,
        title: 'LUKU recharge',
        amount: 35000.0,
        expenseDate: DateTime(2026, 11, 11),
        idempotencyKey: 'idemp-exp-35k',
      );

      expect(expense.amount, 35000.0);

      // Verify available balance = 100,000 - 35,000 = 65,000 (6,500,000 minor units)
      final wallet = repository.getWallet(
        householdId: household.id,
        actorUserId: userA,
      );
      expect(wallet.availableBalance, 65000.0);

      final walletRow = await db.select(db.householdWallets).getSingle();
      expect(walletRow.availableBalanceCents, 6500000);
    });

    test('Duplicate financial records with same idempotencyKey are rejected',
        () async {
      final household = await repository.createHousehold(
        ownerId: userA,
        adminDisplayName: 'Alice',
        name: 'Alice Household',
      );
      final members = repository.getMembers(
        householdId: household.id,
        actorUserId: userA,
      );

      const idemKey = 'unique-key-abc-123';

      // First contribution succeeds
      await repository.recordContribution(
        householdId: household.id,
        actorUserId: userA,
        memberId: members.first.id,
        amount: 50000.0,
        contributionDate: DateTime(2026, 11, 10),
        idempotencyKey: idemKey,
      );

      // Rapid second contribution with same key throws DuplicateTransactionException
      expect(
        () => repository.recordContribution(
          householdId: household.id,
          actorUserId: userA,
          memberId: members.first.id,
          amount: 50000.0,
          contributionDate: DateTime(2026, 11, 10),
          idempotencyKey: idemKey,
        ),
        throwsA(isA<DuplicateTransactionException>()),
      );

      // Verify only 1 contribution was stored
      final count = await db.contributions.count().getSingle();
      expect(count, 1);
    });

    test('User data isolation: User A records are isolated from User B',
        () async {
      // User A creates a household
      final householdA = await repository.createHousehold(
        ownerId: userA,
        adminDisplayName: 'Alice',
        name: 'Alice Sanctuary',
      );

      // User B creates a separate household
      final householdB = await repository.createHousehold(
        ownerId: userB,
        adminDisplayName: 'Bob',
        name: 'Bob Quarters',
      );

      // User A only sees household A
      final userAHouseholds = repository.getHouseholdsForUser(userA);
      expect(userAHouseholds.length, 1);
      expect(userAHouseholds.first.id, householdA.id);

      // User B only sees household B
      final userBHouseholds = repository.getHouseholdsForUser(userB);
      expect(userBHouseholds.length, 1);
      expect(userBHouseholds.first.id, householdB.id);

      // User B cannot access User A's members or wallet
      expect(
        () => repository.getWallet(
          householdId: householdA.id,
          actorUserId: userB,
        ),
        throwsA(isA<UnauthorizedHouseholdAccessException>()),
      );
    });

    test('Application restart simulation: SQLite restores exact ledger state without loss',
        () async {
      // Session 1: Create household, fund wallet, record expense
      final household = await repository.createHousehold(
        ownerId: userA,
        adminDisplayName: 'Alice',
        name: 'Persistent House',
      );
      final members = repository.getMembers(
        householdId: household.id,
        actorUserId: userA,
      );
      final categories = repository.getCategories(
        householdId: household.id,
        actorUserId: userA,
      );

      await repository.recordContribution(
        householdId: household.id,
        actorUserId: userA,
        memberId: members.first.id,
        amount: 80000.0,
        contributionDate: DateTime(2026, 11, 10),
      );
      await repository.recordExpense(
        householdId: household.id,
        actorUserId: userA,
        categoryId: categories.first.id,
        paidByMemberId: members.first.id,
        title: 'Gas Cylinder',
        amount: 45000.0,
        expenseDate: DateTime(2026, 11, 11),
      );

      // Simulate App Process Restart: Create fresh repository connected to same SQLite DB
      final restartedRepository = HouseholdLedgerRepository(
        db: db,
        driftStorage: storage,
        initializeDemoSeed: false,
      );

      // Cold start restore for User A
      final restored = await restartedRepository.restoreFromLocalStorage(
        userId: userA,
      );
      expect(restored, isTrue);

      final restoredHouseholds =
          restartedRepository.getHouseholdsForUser(userA);
      expect(restoredHouseholds.length, 1);
      expect(restoredHouseholds.first.name, 'Persistent House');

      final wallet = restartedRepository.getWallet(
        householdId: household.id,
        actorUserId: userA,
      );
      // 80,000 - 45,000 = 35,000
      expect(wallet.availableBalance, 35000.0);
      expect(wallet.totalContributions, 80000.0);
      expect(wallet.totalExpenses, 45000.0);
    });
  });
}
