import 'package:flutter_test/flutter_test.dart';
import 'package:household_management/core/errors/app_exceptions.dart';
import 'package:household_management/features/households/data/repositories/household_ledger_repository.dart';
import 'package:household_management/features/households/domain/entities/household_member.dart';

void main() {
  group('Security & Access Control Tests (Section 18.3)', () {
    late HouseholdLedgerRepository repository;
    const ownerAdminId = 'admin-owner-001';
    const outsiderUserId = 'outsider-user-999';
    const readOnlyMemberUserId = 'readonly-member-002';

    setUp(() {
      repository = HouseholdLedgerRepository(initializeDemoSeed: false);
    });

    test('Unauthorized user cannot view or modify another admin household',
        () async {
      final household = await repository.createHousehold(
        ownerId: ownerAdminId,
        adminDisplayName: 'Dida',
        name: 'Private Family Household',
      );

      expect(
        () => repository.getWallet(
          householdId: household.id,
          actorUserId: outsiderUserId,
        ),
        throwsA(isA<UnauthorizedHouseholdAccessException>()),
      );

      final memberId = repository
          .getMembers(householdId: household.id, actorUserId: ownerAdminId)
          .first
          .id;

      expect(
        () => repository.recordContribution(
          householdId: household.id,
          actorUserId: outsiderUserId,
          memberId: memberId,
          amount: 50000,
          contributionDate: DateTime(2026, 11, 1),
        ),
        throwsA(isA<UnauthorizedHouseholdAccessException>()),
      );
    });

    test(
        'Read-only household member can view balance and history but cannot add contributions, expenses, or edit transactions',
        () async {
      final household = await repository.createHousehold(
        ownerId: ownerAdminId,
        adminDisplayName: 'Dida',
        name: 'Shared House',
      );

      final member = await repository.addMember(
        householdId: household.id,
        actorUserId: ownerAdminId,
        displayName: 'Read-Only Member B',
        linkedUserId: readOnlyMemberUserId,
        role: HouseholdRole.member,
      );

      await repository.recordContribution(
        householdId: household.id,
        actorUserId: ownerAdminId,
        memberId: member.id,
        amount: 100000,
        contributionDate: DateTime(2026, 11, 1),
      );

      // Read-only member CAN view wallet balance, transactions, predictions, and reports
      final wallet = repository.getWallet(
        householdId: household.id,
        actorUserId: readOnlyMemberUserId,
      );
      expect(wallet.availableBalance, 100000);

      final txs = repository.getWalletTransactions(
        householdId: household.id,
        actorUserId: readOnlyMemberUserId,
      );
      expect(txs.length, 1);

      // Read-only member CANNOT add contribution
      expect(
        () => repository.recordContribution(
          householdId: household.id,
          actorUserId: readOnlyMemberUserId,
          memberId: member.id,
          amount: 20000,
          contributionDate: DateTime(2026, 11, 2),
        ),
        throwsA(isA<ReadOnlyMemberRestrictionException>()),
      );

      // Read-only member CANNOT record expense
      final catId = repository
          .getCategories(
            householdId: household.id,
            actorUserId: readOnlyMemberUserId,
          )
          .first
          .id;

      expect(
        () => repository.recordExpense(
          householdId: household.id,
          actorUserId: readOnlyMemberUserId,
          categoryId: catId,
          paidByMemberId: member.id,
          title: 'Unauthorized Expense',
          amount: 10000,
          expenseDate: DateTime(2026, 11, 2),
        ),
        throwsA(isA<ReadOnlyMemberRestrictionException>()),
      );

      // Read-only member CANNOT edit or reverse transactions
      expect(
        () => repository.correctOrReverseTransaction(
          householdId: household.id,
          actorUserId: readOnlyMemberUserId,
          walletTransactionId: txs.first.id,
          newAmount: 0,
          newDescription: 'Tamper attempt',
          reason: 'Attempting reversal as member',
        ),
        throwsA(isA<ReadOnlyMemberRestrictionException>()),
      );
    });
  });
}
