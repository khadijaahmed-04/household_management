import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_management/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'End-to-end flow: Splash -> Dashboard -> Switch Household -> View Wallet',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: NyumbaSmartApp()));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('My Family'), findsOneWidget);
    expect(find.text('TSh 250,000'), findsWidgets);

    // Navigate to Wallet tab
    await tester.tap(find.byIcon(Icons.account_balance_wallet_outlined));
    await tester.pumpAndSettle();

    expect(find.textContaining('Wallet & Ledger'), findsOneWidget);
  });
}
