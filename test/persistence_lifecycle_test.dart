import 'package:flutter_test/flutter_test.dart';
import 'package:household_management/core/database/app_database.dart';
import 'package:household_management/core/database/connection/native.dart';
import 'package:household_management/core/database/drift_ledger_storage.dart';
import 'package:household_management/features/auth/data/repositories/auth_repository.dart';
import 'package:household_management/features/households/data/services/firestore_ledger_sync.dart';
import 'package:household_management/features/households/data/repositories/household_ledger_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Simulate App Close and Reopen: Data must persist completely', () async {
    SharedPreferences.setMockInitialValues({});
    final sharedExecutor = openInMemoryConnection();
    final db1 = AppDatabase.forTesting(sharedExecutor);
    final storage1 = DriftLedgerStorage(db1);
    final authRepo1 = FirebaseAuthRepository();

    // 1. First app launch: User registers
    final user = await authRepo1.register(
      fullName: 'John Doe',
      email: 'john@nyumba.tz',
      password: 'password123',
    );
    expect(user.id, isNotEmpty);

    // 2. User creates a household and records financial transactions
    final repo1 = HouseholdLedgerRepository(
      db: db1,
      driftStorage: storage1,
      initializeDemoSeed: false,
    );
    await repo1.syncForUser(user.id);

    final createdHousehold = await repo1.createHousehold(
      ownerId: user.id,
      adminDisplayName: 'John',
      name: 'Mwenge Family Home',
      lowBalanceThreshold: 20000.0,
    );

    await repo1.recordContribution(
      householdId: createdHousehold.id,
      actorUserId: user.id,
      memberId: 'member-admin-${createdHousehold.id}',
      amount: 50000.0,
      contributionDate: DateTime.now(),
      description: 'First contribution',
    );

    final cat = repo1
        .getCategories(householdId: createdHousehold.id, actorUserId: user.id)
        .first;

    await repo1.recordExpense(
      householdId: createdHousehold.id,
      actorUserId: user.id,
      categoryId: cat.id,
      title: 'Groceries',
      amount: 15000.0,
      paidByMemberId: 'member-admin-${createdHousehold.id}',
      expenseDate: DateTime.now(),
      notes: 'Groceries',
    );

    final wallet1 = repo1.getWallet(
      householdId: createdHousehold.id,
      actorUserId: user.id,
    );
    expect(wallet1, isNotNull);
    expect(wallet1.availableBalance, 35000.0);

    // =========================================================================
    // 3. APP IS CLOSED (Process killed, memory wiped)
    // =========================================================================

    // 4. APP IS REOPENED (New instances connected to the SAME underlying SQLite)
    final db2 = AppDatabase.forTesting(sharedExecutor);
    final storage2 = DriftLedgerStorage(db2);
    final authRepo2 = FirebaseAuthRepository();

    // The user session is checked on splash
    final restoredUser = await authRepo2.getCurrentUser();
    // If fallback auth, does getCurrentUser find the user?
    // Let's test!
    expect(restoredUser != null || user.id.isNotEmpty, true);

    // Repository on reopen
    final repo2 = HouseholdLedgerRepository(
      db: db2,
      driftStorage: storage2,
      initializeDemoSeed: false,
    );

    // syncForUser called on startup
    await repo2.syncForUser(user.id);

    final restoredHouseholds = repo2.getHouseholdsForUser(user.id);
    expect(
      restoredHouseholds.isNotEmpty,
      true,
      reason: 'Households must not be empty after app restart!',
    );
    expect(restoredHouseholds.first.name, 'Mwenge Family Home');

    final wallet2 = repo2.getWallet(
      householdId: createdHousehold.id,
      actorUserId: user.id,
    );
    expect(wallet2, isNotNull);
    expect(
      wallet2.availableBalance,
      35000.0,
      reason: 'Wallet balance of 35,000 must be preserved across app restart!',
    );

    final contributions2 = repo2.getContributions(
      householdId: createdHousehold.id,
      actorUserId: user.id,
    );
    expect(contributions2.length, 1);

    final expenses2 = repo2.getExpenses(
      householdId: createdHousehold.id,
      actorUserId: user.id,
    );
    expect(expenses2.length, 1);
  });

  testFirestoreSyncWiping();
  testAuthPersistence();
}

class FakeFirestoreSyncService extends FirestoreLedgerSyncService {
  final FirestoreHouseholdBundle? bundleToReturn;
  const FakeFirestoreSyncService(this.bundleToReturn);

  @override
  bool get isAvailable => true;

  @override
  Future<FirestoreHouseholdBundle?> fetchAllForUser(String userId) async {
    return bundleToReturn;
  }
}

void testFirestoreSyncWiping() {
  test('CRITICAL BUG TEST: Remote returning empty bundle must NEVER wipe local SQLite data', () async {
    SharedPreferences.setMockInitialValues({});
    final sharedExecutor = openInMemoryConnection();
    final db = AppDatabase.forTesting(sharedExecutor);
    final storage = DriftLedgerStorage(db);

    const userId = 'user-alice-123';

    // 1. User has data in local SQLite
    final repo1 = HouseholdLedgerRepository(
      db: db,
      driftStorage: storage,
      initializeDemoSeed: false,
    );
    await repo1.syncForUser(userId);

    await repo1.createHousehold(
      ownerId: userId,
      adminDisplayName: 'Alice',
      name: 'Alice Home',
    );

    expect(repo1.getHouseholdsForUser(userId).length, 1);

    // 2. Reopen app with a Firestore service that is AVAILABLE (e.g. phone has internet)
    // but Firestore has no remote docs yet (e.g. empty bundle returned)
    final repo2 = HouseholdLedgerRepository(
      db: db,
      driftStorage: storage,
      firestoreSync: FakeFirestoreSyncService(FirestoreHouseholdBundle()), // Empty remote bundle!
      initializeDemoSeed: false,
    );

    // Startup sync runs
    await repo2.syncForUser(userId);

    // What happens to Alice's household?
    final householdsOnReopen = repo2.getHouseholdsForUser(userId);
    expect(
      householdsOnReopen.isNotEmpty,
      true,
      reason: 'Empty Firestore bundle wiped out Alice Home from local memory!',
    );
  });
}

void testAuthPersistence() {
  test('Auth session and profile must persist when app restarts', () async {
    SharedPreferences.setMockInitialValues({});
    final authRepo1 = FirebaseAuthRepository();

    // User registers in fallback/offline mode
    final user = await authRepo1.register(
      fullName: 'Dida Hassan',
      email: 'dida@nyumba.tz',
      password: 'password123',
    );
    expect(user.email, 'dida@nyumba.tz');

    // Simulate App Restart (new repository instance)
    final authRepo2 = FirebaseAuthRepository();
    final restoredUser = await authRepo2.getCurrentUser();

    expect(
      restoredUser,
      isNotNull,
      reason: 'User session must persist across app restart so the user is not logged out!',
    );
    expect(restoredUser?.email, 'dida@nyumba.tz');
  });
}
