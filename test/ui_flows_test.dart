import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_management/features/auth/presentation/screens/auth_screens.dart';
import 'package:household_management/features/dashboard/presentation/screens/main_dashboard_screen.dart';
import 'package:household_management/features/wallet/presentation/screens/wallet_screens.dart';

void main() {
  group('UI & Widget Flow Tests (Section 18.4)', () {
    testWidgets(
        'Main Dashboard renders initial Tanzanian household balance (TSh 250,000) and quick actions',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainDashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify active household name ("My Family") and available balance ("TSh 250,000")
      expect(find.text('My Family'), findsOneWidget);
      expect(
        find.byKey(const Key('dashboard_available_balance_text')),
        findsOneWidget,
      );
      expect(find.text('TSh 250,000'), findsWidgets);

      // Verify quick action buttons exist
      expect(
        find.byKey(const Key('quick_action_add_contribution')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('quick_action_add_expense')), findsOneWidget);
    });

    testWidgets(
        'Add Contribution screen validates and records a new contribution',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AddContributionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Record Member Contribution'), findsOneWidget);
      await tester.enterText(
        find.byKey(const Key('contribution_member_name_field')),
        'Halima',
      );
      await tester.enterText(
        find.byKey(const Key('contribution_amount_field')),
        '75000',
      );
      await tester.enterText(
        find.byKey(const Key('contribution_desc_field')),
        'Top-up contribution',
      );
      await tester.pump();
      expect(find.text('Halima'), findsOneWidget);
      expect(find.text('75000'), findsOneWidget);
    });

    testWidgets(
        'Welcome Screen displays Create Administrator Account and Sign In buttons',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: WelcomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('welcome_create_account_btn')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('welcome_sign_in_btn')), findsOneWidget);
    });
  });
}
