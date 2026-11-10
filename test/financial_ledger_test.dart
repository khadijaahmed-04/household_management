import 'package:flutter_test/flutter_test.dart';
import 'package:household_management/core/errors/app_exceptions.dart';
import 'package:household_management/features/households/data/repositories/household_ledger_repository.dart';
import 'package:household_management/features/wallet/domain/entities/wallet_entities.dart';

void main() {
  group('Financial Ledger & Wallet Calculations Tests (Section 18.1)', () {
    late HouseholdLedgerRepository repository;
    const adminId = 'admin-user-1';

    setUp(() {
      repository = HouseholdLedgerRepository(initializeDemoSeed: false);
    });

    test(
        'Unequal member contributions and expense deduction match exact TZS ledger equation',
        () async {
      final household = await repository.createHousehold(
        ownerId: adminId,
        adminDisplayName: 'Dida',
        name: 'My Family',
      );

      final members = repository.getMembers(
        householdId: household.id,
        actorUserId: adminId,
      );
      final didaId = members.first.id;
      final memberB = await repository.addMember(
        householdId: household.id,
        actorUserId: adminId,
        displayName: 'Member B',
      );
      final memberC = await repository.addMember(
        householdId: household.id,
        actorUserId: adminId,
        displayName: 'Member C',
      );

      // Dida contributes TSh 100,000; Member B contributes TSh 50,000; Member C contributes TSh 150,000
      await repository.recordContribution(
        householdId: household.id,
        actorUserId: adminId,
        memberId: didaId,
        amount: 100000,
        contributionDate: DateTime(2026, 11, 1),
      );
      await repository.recordContribution(
        householdId: household.id,
        actorUserId: adminId,
        memberId: memberB.id,
        amount: 50000,
        contributionDate: DateTime(2026, 11, 2),
      );
      await repository.recordContribution(
        householdId: household.id,
        actorUserId: adminId,
        memberId: memberC.id,
        amount: 150000,
        contributionDate: DateTime(2026, 11, 3),
      );

      var wallet = repository.getWallet(
        householdId: household.id,
        actorUserId: adminId,
      );
      expect(wallet.totalContributions, 300000);
      expect(wallet.availableBalance, 300000);
      expect(wallet.isLedgerBalanced, isTrue);

      // Dida purchases groceries for TSh 50,000 -> Balance decreases to TSh 250,000
      final categories = repository.getCategories(
        householdId: household.id,
        actorUserId: adminId,
      );
      final groceriesCat =
          categories.firstWhere((c) => c.slug == 'groceries');

      await repository.recordExpense(
        householdId: household.id,
        actorUserId: adminId,
        categoryId: groceriesCat.id,
        paidByMemberId: didaId,
        title: 'Market Groceries',
        amount: 50000,
        expenseDate: DateTime(2026, 11, 4),
      );

      wallet = repository.getWallet(
        householdId: household.id,
        actorUserId: adminId,
      );
      expect(wallet.totalContributions, 300000);
      expect(wallet.totalExpenses, 50000);
      expect(wallet.availableBalance, 250000);
      expect(wallet.isLedgerBalanced, isTrue);
    });

    test(
        'Insufficient balance prevents expense from making wallet balance negative',
        () async {
      final household = await repository.createHousehold(
        ownerId: adminId,
        adminDisplayName: 'Dida',
        name: 'Test Home',
      );
      final didaId = repository
          .getMembers(householdId: household.id, actorUserId: adminId)
          .first
          .id;
      final catId = repository
          .getCategories(householdId: household.id, actorUserId: adminId)
          .first
          .id;

      await repository.recordContribution(
        householdId: household.id,
        actorUserId: adminId,
        memberId: didaId,
        amount: 40000,
        contributionDate: DateTime(2026, 11, 1),
      );

      expect(
        () => repository.recordExpense(
          householdId: household.id,
          actorUserId: adminId,
          categoryId: catId,
          paidByMemberId: didaId,
          title: 'Oversized Purchase',
          amount: 45000,
          expenseDate: DateTime(2026, 11, 2),
        ),
        throwsA(isA<InsufficientBalanceException>()),
      );

      final wallet = repository.getWallet(
        householdId: household.id,
        actorUserId: adminId,
      );
      expect(wallet.availableBalance, 40000);
    });

    test('Multiple households maintain completely independent wallet balances',
        () async {
      final family = await repository.createHousehold(
        ownerId: adminId,
        adminDisplayName: 'Dida',
        name: 'My Family',
      );
      final apartment = await repository.createHousehold(
        ownerId: adminId,
        adminDisplayName: 'Dida',
        name: 'My Apartment',
      );

      final familyMemberId = repository
          .getMembers(householdId: family.id, actorUserId: adminId)
          .first
          .id;
      final aptMemberId = repository
          .getMembers(householdId: apartment.id, actorUserId: adminId)
          .first
          .id;
      final familyCatId = repository
          .getCategories(householdId: family.id, actorUserId: adminId)
          .first
          .id;

      await repository.recordContribution(
        householdId: family.id,
        actorUserId: adminId,
        memberId: familyMemberId,
        amount: 200000,
        contributionDate: DateTime(2026, 11, 1),
      );
      await repository.recordContribution(
        householdId: apartment.id,
        actorUserId: adminId,
        memberId: aptMemberId,
        amount: 90000,
        contributionDate: DateTime(2026, 11, 1),
      );

      // Expense in Family must never affect Apartment
      await repository.recordExpense(
        householdId: family.id,
        actorUserId: adminId,
        categoryId: familyCatId,
        paidByMemberId: familyMemberId,
        title: 'Family Electricity',
        amount: 35000,
        expenseDate: DateTime(2026, 11, 2),
      );

      final familyWallet = repository.getWallet(
        householdId: family.id,
        actorUserId: adminId,
      );
      final aptWallet = repository.getWallet(
        householdId: apartment.id,
        actorUserId: adminId,
      );

      expect(familyWallet.availableBalance, 165000);
      expect(aptWallet.availableBalance, 90000);
    });

    test(
        'Transaction reversal and correction preserve history and write audit logs',
        () async {
      final household = await repository.createHousehold(
        ownerId: adminId,
        adminDisplayName: 'Dida',
        name: 'Audit Household',
      );
      final didaId = repository
          .getMembers(householdId: household.id, actorUserId: adminId)
          .first
          .id;
      final catId = repository
          .getCategories(householdId: household.id, actorUserId: adminId)
          .first
          .id;

      await repository.recordContribution(
        householdId: household.id,
        actorUserId: adminId,
        memberId: didaId,
        amount: 100000,
        contributionDate: DateTime(2026, 11, 1),
      );
      await repository.recordExpense(
        householdId: household.id,
        actorUserId: adminId,
        categoryId: catId,
        paidByMemberId: didaId,
        title: 'Cooking Gas',
        amount: 60000,
        expenseDate: DateTime(2026, 11, 2),
      );

      final txList = repository.getWalletTransactions(
        householdId: household.id,
        actorUserId: adminId,
      );
      final expenseTx = txList.firstWhere(
        (t) => t.transactionType == WalletTransactionType.expense,
      );

      // Reverse the 60,000 expense -> wallet balance returns to 100,000
      await repository.correctOrReverseTransaction(
        householdId: household.id,
        actorUserId: adminId,
        walletTransactionId: expenseTx.id,
        newAmount: 0,
        newDescription: 'Cooking Gas',
        reason: 'Entered on wrong household',
      );

      final wallet = repository.getWallet(
        householdId: household.id,
        actorUserId: adminId,
      );
      expect(wallet.availableBalance, 100000);
      expect(wallet.isLedgerBalanced, isTrue);

      final updatedTxs = repository.getWalletTransactions(
        householdId: household.id,
        actorUserId: adminId,
      );
      // Original contribution + original expense + compensating reversal = 3 ledger rows
      expect(updatedTxs.length, 3);

      final audits = repository.getAuditLogs(
        householdId: household.id,
        actorUserId: adminId,
      );
      expect(audits.any((a) => a.action == 'reverse'), isTrue);
    });
  });
}
