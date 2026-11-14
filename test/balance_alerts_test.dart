import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_management/core/utils/formatters.dart';
import 'package:household_management/core/utils/share_launcher.dart';
import 'package:household_management/features/households/domain/entities/household.dart';
import 'package:household_management/features/notifications/domain/entities/notification_entity.dart';
import 'package:household_management/features/notifications/domain/services/notification_service.dart';
import 'package:household_management/features/wallet/domain/entities/wallet_entities.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Wallet Balance Threshold Alerts', () {
    late NotificationAlertEvaluator notificationEvaluator;
    final testDate = DateTime(2026, 11, 14, 10, 0);

    final household = Household(
      id: 'household-test-01',
      name: 'Test Household',
      ownerId: 'owner-01',
      lowBalanceThreshold: 50000.0,
      currencyCode: 'TZS',
      currencySymbol: 'TSh',
      createdAt: DateTime(2026, 1, 1),
    );

    setUp(() {
      notificationEvaluator = const NotificationAlertEvaluator();
    });

    test(
        'Balance above lowBalanceThreshold does NOT generate low balance notification',
        () {
      const wallet = HouseholdWallet(
        id: 'wallet-01',
        householdId: 'household-test-01',
        totalContributions: 100000,
        totalExpenses: 20000,
        availableBalance: 80000, // 80,000 > 50,000 threshold
      );

      final alerts = notificationEvaluator.evaluateAlerts(
        household: household,
        wallet: wallet,
        predictions: const [],
        recurringBills: const [],
        budgetStatuses: const [],
        existingNotifications: const [],
        referenceDate: testDate,
      );

      final lowBalanceAlerts = alerts
          .where((n) => n.type == NotificationType.lowWalletBalance)
          .toList();
      expect(lowBalanceAlerts, isEmpty);
    });

    test(
        'Balance below threshold mentions user-configured threshold amount and balance without saying completely finished',
        () {
      const wallet = HouseholdWallet(
        id: 'wallet-01',
        householdId: 'household-test-01',
        totalContributions: 100000,
        totalExpenses: 70000,
        availableBalance: 30000, // 30,000 <= 50,000 threshold
      );

      final alerts = notificationEvaluator.evaluateAlerts(
        household: household,
        wallet: wallet,
        predictions: const [],
        recurringBills: const [],
        budgetStatuses: const [],
        existingNotifications: const [],
        referenceDate: testDate,
      );

      final lowBalanceAlerts = alerts
          .where((n) => n.type == NotificationType.lowWalletBalance)
          .toList();
      expect(lowBalanceAlerts.length, 1);
      final alert = lowBalanceAlerts.first;
      expect(alert.title, 'Low Household Wallet Balance');
      // Mentions the remaining amount
      expect(alert.body, contains('30,000'));
      // Mentions user's threshold amount
      expect(alert.body, contains('50,000'));
      // Does NOT say completely finished
      expect(alert.body.toLowerCase(), isNot(contains('completely finished')));
      expect(alert.dedupKey, startsWith('low_balance_household-test-01'));
    });

    test(
        'Zero balance also mentions user-configured threshold amount without saying completely finished',
        () {
      const wallet = HouseholdWallet(
        id: 'wallet-01',
        householdId: 'household-test-01',
        totalContributions: 100000,
        totalExpenses: 100000,
        availableBalance: 0,
      );

      final alerts = notificationEvaluator.evaluateAlerts(
        household: household,
        wallet: wallet,
        predictions: const [],
        recurringBills: const [],
        budgetStatuses: const [],
        existingNotifications: const [],
        referenceDate: testDate,
      );

      final balanceAlerts = alerts
          .where((n) => n.type == NotificationType.lowWalletBalance)
          .toList();
      expect(balanceAlerts.length, 1);
      final alert = balanceAlerts.first;
      expect(alert.title, 'Low Household Wallet Balance');
      // Mentions user's threshold amount
      expect(alert.body, contains('50,000'));
      // Does NOT say completely finished
      expect(alert.body.toLowerCase(), isNot(contains('completely finished')));
    });

    test(
        'ShareLauncher.checkAndAutoSendHouseholdAlerts mentions user threshold and does not say completely finished',
        () async {
      SharedPreferences.setMockInitialValues({});
      final methodCalls = <MethodCall>[];

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('nyumbasmart/share'),
        (MethodCall call) async {
          methodCalls.add(call);
          return true;
        },
      );

      await ShareLauncher.checkAndAutoSendHouseholdAlerts(
        householdId: 'household-test-01',
        householdName: 'Test Household',
        currencySymbol: 'TSh',
        availableBalance: 15000,
        lowBalanceThreshold: 50000,
        forceSendNow: true,
      );

      final showNotifications = methodCalls
          .where((c) => c.method == 'showSystemNotification')
          .toList();
      expect(showNotifications.isNotEmpty, isTrue);
      final notificationArgs =
          showNotifications.first.arguments as Map<dynamic, dynamic>;
      expect(notificationArgs['title'], contains('Salio Liko Chini'));
      // Mentions remaining balance
      expect(notificationArgs['text'], contains('15,000'));
      // Mentions user threshold
      expect(notificationArgs['text'], contains('50,000'));
      // Does NOT say completely finished
      expect(
        (notificationArgs['text'] as String).toLowerCase(),
        isNot(contains('completely finished')),
      );
    });

    test('AppFormatters.tryParseAmount handles 10k, 15K, and 10,000 accurately',
        () {
      expect(AppFormatters.tryParseAmount('10k'), 10000.0);
      expect(AppFormatters.tryParseAmount('10K'), 10000.0);
      expect(AppFormatters.tryParseAmount('15k'), 15000.0);
      expect(AppFormatters.tryParseAmount('10,000'), 10000.0);
      expect(AppFormatters.tryParseAmount('10 000'), 10000.0);
    });

    test(
        'When threshold is 10,000 and balance is 15,000, NO alert is generated or sent',
        () async {
      SharedPreferences.setMockInitialValues({});
      final methodCalls = <MethodCall>[];

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('nyumbasmart/share'),
        (MethodCall call) async {
          methodCalls.add(call);
          return true;
        },
      );

      const wallet = HouseholdWallet(
        id: 'wallet-01',
        householdId: 'household-test-01',
        totalContributions: 15000,
        totalExpenses: 0,
        availableBalance: 15000, // 15k > 10k
      );

      final householdWith10k = household.copyWith(lowBalanceThreshold: 10000);

      final alerts = notificationEvaluator.evaluateAlerts(
        household: householdWith10k,
        wallet: wallet,
        predictions: const [],
        recurringBills: const [],
        budgetStatuses: const [],
        existingNotifications: const [],
        referenceDate: testDate,
      );

      final lowBalanceAlerts = alerts
          .where((n) => n.type == NotificationType.lowWalletBalance)
          .toList();
      expect(lowBalanceAlerts, isEmpty);

      await ShareLauncher.checkAndAutoSendHouseholdAlerts(
        householdId: householdWith10k.id,
        householdName: householdWith10k.name,
        currencySymbol: householdWith10k.currencySymbol,
        availableBalance: wallet.availableBalance,
        lowBalanceThreshold: householdWith10k.lowBalanceThreshold,
      );

      // Verify no showSystemNotification call was triggered
      final showCalls = methodCalls
          .where((c) => c.method == 'showSystemNotification')
          .toList();
      expect(showCalls, isEmpty);
    });
  });
}
