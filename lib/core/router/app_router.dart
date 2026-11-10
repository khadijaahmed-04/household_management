import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/auth_screens.dart';
import '../../features/consumption/presentation/screens/consumption_screens.dart';
import '../../features/dashboard/presentation/screens/main_dashboard_screen.dart';
import '../../features/households/presentation/screens/household_screens.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screens.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (_, __) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (_, __) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (_, __) => const MainDashboardScreen(),
      ),
      GoRoute(
        path: '/households',
        builder: (_, __) => const HouseholdSelectionScreen(),
        routes: [
          GoRoute(
            path: 'create',
            builder: (_, __) => const CreateHouseholdScreen(),
          ),
          GoRoute(
            path: 'edit',
            builder: (_, __) => const EditHouseholdScreen(),
          ),
          GoRoute(
            path: 'details',
            builder: (_, __) => const HouseholdDetailsScreen(),
          ),
          GoRoute(
            path: 'members',
            builder: (_, __) => const ManageHouseholdMembersScreen(),
          ),
          GoRoute(
            path: 'categories',
            builder: (_, __) => const ManageCategoriesScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/wallet',
        builder: (_, __) => const TransactionHistoryScreen(),
        routes: [
          GoRoute(
            path: 'contribute',
            builder: (_, __) => const AddContributionScreen(),
          ),
          GoRoute(
            path: 'expense',
            builder: (_, __) => const AddExpenseScreen(),
          ),
          GoRoute(
            path: 'audit-logs',
            builder: (_, __) => const AuditLogsScreen(),
          ),
          GoRoute(
            path: 'transaction/:id',
            builder: (_, state) => TransactionDetailsAndCorrectionScreen(
              transactionId: state.pathParameters['id'] ?? '',
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/consumption',
        builder: (_, __) => const ConsumptionOverviewScreen(),
        routes: [
          GoRoute(
            path: 'add-purchase',
            builder: (_, __) => const RecordSupplyPurchaseScreen(),
          ),
          GoRoute(
            path: 'add-bill',
            builder: (_, __) => const AddRecurringBillScreen(),
          ),
          GoRoute(
            path: 'prediction/:supplyId',
            builder: (_, state) => PredictionDetailsAndOverrideScreen(
              supplyId: state.pathParameters['supplyId'] ?? '',
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/reports',
        builder: (_, __) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, __) => const SettingsScreen(),
      ),
    ],
  );
});
