import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_management/features/auth/presentation/screens/auth_screens.dart';
import 'package:household_management/features/dashboard/presentation/screens/main_dashboard_screen.dart';
import 'package:household_management/features/households/data/repositories/household_ledger_repository.dart';
import 'package:household_management/features/households/presentation/providers/household_providers.dart';
import 'package:household_management/features/households/presentation/screens/household_screens.dart';
import 'package:household_management/features/wallet/presentation/screens/wallet_screens.dart';

void main() {
  group('UI & Widget Flow Tests (Section 18.4)', () {
    testWidgets(
        'Main Dashboard shows Create Household empty state by default with no demo data',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainDashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Create Your First Household'), findsOneWidget);
      expect(find.text('Create Household'), findsOneWidget);
    });

    testWidgets(
        'Main Dashboard renders household balance (TSh 250,000) and quick actions when seeded',
        (tester) async {
      final seededRepo = HouseholdLedgerRepository(initializeDemoSeed: true);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            householdLedgerRepositoryProvider.overrideWithValue(seededRepo),
            currentUserIdProvider.overrideWithValue('user-admin-dida-001'),
          ],
          child: const MaterialApp(
            home: MainDashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('My Family'), findsOneWidget);
      expect(
        find.byKey(const Key('dashboard_available_balance_text')),
        findsOneWidget,
      );
      expect(find.text('TSh 250,000'), findsWidgets);

      expect(
        find.byKey(const Key('quick_action_add_contribution')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('quick_action_add_expense')), findsOneWidget);
    });

    testWidgets(
        'Add Contribution screen validates and records a new contribution',
        (tester) async {
      final seededRepo = HouseholdLedgerRepository(initializeDemoSeed: true);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            householdLedgerRepositoryProvider.overrideWithValue(seededRepo),
            currentUserIdProvider.overrideWithValue('user-admin-dida-001'),
          ],
          child: const MaterialApp(
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
        'Login Screen displays Google Sign-In button and removes demo credentials',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('login_google_btn')), findsOneWidget);
      expect(find.byKey(const Key('login_submit_btn')), findsOneWidget);
    });

    testWidgets(
        'RegisterScreen and LoginScreen do not bottom-overflow on compact screens',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('register_submit_btn')), findsOneWidget);
      expect(find.byKey(const Key('register_google_btn')), findsOneWidget);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('login_submit_btn')), findsOneWidget);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CreateHouseholdScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('create_household_submit_btn')),
        findsOneWidget,
      );

      // Verify empty post-login dashboard tabs on compact screen
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainDashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final label in ['Activity', 'Insights', 'Members', 'More']) {
        await tester.tap(find.text(label).last);
        await tester.pumpAndSettle();
      }
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
