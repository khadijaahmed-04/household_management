import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/share_launcher.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../consumption/presentation/screens/consumption_screens.dart';
import '../../../households/presentation/providers/household_providers.dart';
import '../../../households/presentation/screens/household_screens.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../wallet/presentation/screens/wallet_screens.dart';

/// Allows any screen or quick link inside the shell to switch the active bottom tab.
final dashboardTabIndexProvider = StateProvider<int>((ref) => 0);

class MainDashboardScreen extends ConsumerStatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  ConsumerState<MainDashboardScreen> createState() =>
      _MainDashboardScreenState();
}

class _MainDashboardScreenState extends ConsumerState<MainDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ShareLauncher.requestAlertPermissions();
      _triggerAutoAlertsForActiveHousehold();
    });
  }

  void _triggerAutoAlertsForActiveHousehold() {
    final household = ref.read(activeHouseholdProvider);
    if (household == null) return;
    final repo = ref.read(householdLedgerRepositoryProvider);
    final userId = ref.read(currentUserIdProvider);

    // Read directly from repository to ensure 100% fresh, up-to-date wallet balance & threshold
    final wallet =
        repo.getWallet(householdId: household.id, actorUserId: userId);
    final freshHousehold = repo.getHouseholdById(
      householdId: household.id,
      actorUserId: userId,
    );
    final predictions = repo.getPredictions(
      householdId: household.id,
      actorUserId: userId,
    );
    final bills = repo.getRecurringBills(
      householdId: household.id,
      actorUserId: userId,
    );

    ShareLauncher.checkAndAutoSendHouseholdAlerts(
      householdId: freshHousehold.id,
      householdName: freshHousehold.name,
      currencySymbol: freshHousehold.currencySymbol,
      availableBalance: wallet.availableBalance,
      lowBalanceThreshold: freshHousehold.lowBalanceThreshold,
      predictions: predictions,
      recurringBills: bills,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(ledgerRevisionProvider, (_, __) {
      _triggerAutoAlertsForActiveHousehold();
    });
    final currentTabIndex = ref.watch(dashboardTabIndexProvider);
    void goHome() => ref.read(dashboardTabIndexProvider.notifier).state = 0;

    final pages = [
      const _DashboardHomeTab(),
      TransactionHistoryScreen(onBack: goHome),
      ConsumptionOverviewScreen(onBack: goHome),
      ManageHouseholdMembersScreen(embeddedInTab: true, onBack: goHome),
      SettingsScreen(onBack: goHome),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: currentTabIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && currentTabIndex != 0) {
          goHome();
        }
      },
      child: Scaffold(
        body: pages[currentTabIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.border,
                width: 1,
              ),
            ),
          ),
          child: NavigationBar(
            selectedIndex: currentTabIndex,
            onDestinationSelected: (idx) =>
                ref.read(dashboardTabIndexProvider.notifier).state = idx,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: ref.tr('Home', 'Nyumbani'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.receipt_long_outlined),
                selectedIcon: const Icon(Icons.receipt_long_rounded),
                label: ref.tr('Activity', 'Miamala'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.insights_outlined),
                selectedIcon: const Icon(Icons.insights_rounded),
                label: ref.tr('Insights', 'Utabiri'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.people_outline_rounded),
                selectedIcon: const Icon(Icons.people_rounded),
                label: ref.tr('Members', 'Wanafamilia'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.grid_view_outlined),
                selectedIcon: const Icon(Icons.grid_view_rounded),
                label: ref.tr('More', 'Zaidi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardHomeTab extends ConsumerWidget {
  const _DashboardHomeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull;
    final households = ref.watch(userHouseholdsProvider);
    final household = ref.watch(activeHouseholdProvider);
    final wallet = ref.watch(activeHouseholdWalletProvider);
    final members = ref.watch(activeHouseholdMembersProvider);
    final summary = ref.watch(activeHouseholdMonthlySummaryProvider);
    final transactions = ref.watch(activeHouseholdTransactionsProvider);
    final predictions = ref.watch(activeHouseholdPredictionsProvider);
    final notifications = ref.watch(activeHouseholdNotificationsProvider);
    final syncState = ref.watch(syncStatusProvider);

    if (household == null || wallet == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('NyumbaSmart')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: EmptyStateCard(
              icon: Icons.home_work_outlined,
              title: ref.tr(
                'Create Your First Household',
                'Unda Nyumba Yako ya Kwanza',
              ),
              subtitle: ref.tr(
                'Start tracking shared contributions, expenses, and supply replenishment predictions.',
                'Anza kufuatilia michango ya pamoja, matumizi na utabiri wa manunuzi ya nyumbani.',
              ),
              actionLabel: ref.tr('Create Household', 'Unda Nyumba'),
              onAction: () => context.push('/households/create'),
            ),
          ),
        ),
      );
    }

    final firstName =
        (user?.fullName ?? 'Member').trim().split(' ').firstOrNull ?? 'Member';
    final unreadCount = notifications.where((n) => !n.isRead).length;

    // Option 1: Only surface supplies that are running low (<= 3 days remaining)
    final urgentSupplies = predictions.where((p) {
      final days = p.daysUntilNextPurchase(DateTime.now());
      return days != null && days <= 3;
    }).toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryText =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final cardSurface = isDark ? AppColors.darkSurface : AppColors.surface;
    final cardBorder =
        isDark ? AppColors.darkSoftGreenBorder : AppColors.softGreenBorder;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // =================================================================
            // 1. FRIENDLY GREETING, HOUSEHOLD SELECTOR & NOTIFICATION SHORTCUT
            // =================================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ref.tr(
                          'Hello, $firstName 👋',
                          'Habari, $firstName 👋',
                        ),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: secondaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      PopupMenuButton<String>(
                        key: const Key('dashboard_household_switcher'),
                        tooltip: ref.tr(
                          'Switch Active Household',
                          'Badilisha Nyumba',
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onSelected: (id) {
                          if (id == '__manage__') {
                            context.push('/households');
                          } else {
                            ref
                                .read(selectedHouseholdIdProvider.notifier)
                                .state = id;
                          }
                        },
                        itemBuilder: (_) => [
                          ...households.map(
                            (h) => PopupMenuItem<String>(
                              value: h.id,
                              child: Row(
                                children: [
                                  Icon(
                                    h.id == household.id
                                        ? Icons.check_circle_rounded
                                        : Icons.circle_outlined,
                                    size: 18,
                                    color: h.id == household.id
                                        ? AppColors.primaryGreen
                                        : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      h.name,
                                      style: TextStyle(
                                        fontWeight: h.id == household.id
                                            ? FontWeight.w800
                                            : FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<String>(
                            value: '__manage__',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.settings_suggest_outlined,
                                  size: 18,
                                  color: AppColors.primaryGreen,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  ref.tr(
                                    'Manage All Households...',
                                    'Simamia Nyumba Zote...',
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSoftGreen
                                : AppColors.softGreen,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkSoftGreenBorder
                                  : AppColors.softGreenBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.home_rounded,
                                color: isDark
                                    ? const Color(0xFF34C486)
                                    : AppColors.primaryGreen,
                                size: 18,
                              ),
                              const SizedBox(width: 7),
                              Flexible(
                                child: Text(
                                  household.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: primaryText,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: isDark
                                    ? const Color(0xFF34C486)
                                    : AppColors.primaryGreen,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Language Switcher Pill
                PopupMenuButton<AppLanguage>(
                  key: const Key('dashboard_language_switcher'),
                  tooltip: ref.tr('Switch Language', 'Badilisha Lugha'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  onSelected: (lang) {
                    ref.read(appLanguageProvider.notifier).state = lang;
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem<AppLanguage>(
                      value: AppLanguage.english,
                      child: Row(
                        children: [
                          Icon(
                            ref.watch(appLanguageProvider) ==
                                    AppLanguage.english
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            size: 18,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 8),
                          const Text('🇬🇧 English (EN)'),
                        ],
                      ),
                    ),
                    PopupMenuItem<AppLanguage>(
                      value: AppLanguage.swahili,
                      child: Row(
                        children: [
                          Icon(
                            ref.watch(appLanguageProvider) ==
                                    AppLanguage.swahili
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            size: 18,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 8),
                          const Text('🇹🇿 Kiswahili (SW)'),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: cardSurface,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: cardBorder),
                    ),
                    child: Text(
                      ref.watch(appLanguageProvider) == AppLanguage.swahili
                          ? '🇹🇿 SW'
                          : '🇬🇧 EN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: primaryText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Notification Shortcut Button
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    InkWell(
                      onTap: () => context.push('/notifications'),
                      borderRadius: BorderRadius.circular(13),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cardSurface,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: cardBorder),
                        ),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          size: 22,
                          color: primaryText,
                        ),
                      ),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.background,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),

            if (!syncState.isOnline) ...[
              SyncStatusBanner(
                isOnline: syncState.isOnline,
                message: syncState.lastSyncMessage ?? 'Offline',
              ),
              const SizedBox(height: 14),
            ],

            // =================================================================
            // 2. MAIN SHARED HOUSEHOLD BALANCE & TOTAL CONTRIBUTIONS/EXPENSES
            // =================================================================
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryGreen, AppColors.primaryGreenDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          ref.tr(
                            'Shared Household Balance',
                            'Salio la Pamoja la Nyumbani',
                          ),
                          style: const TextStyle(
                            color: Color(0xFFD8EFE3),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          household.currencyCode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    key: const Key('dashboard_available_balance_text'),
                    AppFormatters.formatCurrency(
                      wallet.availableBalance,
                      symbol: household.currencySymbol,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.south_west_rounded,
                                    size: 14,
                                    color: Color(0xFFB7E8CE),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      ref.tr(
                                        'Total Contributions',
                                        'Jumla ya Michango',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFFD8EFE3),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppFormatters.formatCurrency(
                                  wallet.totalContributions,
                                  symbol: household.currencySymbol,
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 34,
                          color: Colors.white.withValues(alpha: 0.2),
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.north_east_rounded,
                                    size: 14,
                                    color: Color(0xFFFECACA),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      ref.tr(
                                        'Total Expenses',
                                        'Jumla ya Matumizi',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFFD8EFE3),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppFormatters.formatCurrency(
                                  wallet.totalExpenses,
                                  symbol: household.currencySymbol,
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // =================================================================
            // 3. QUICK ACTIONS: ADD CONTRIBUTION & ADD EXPENSE (+ LOG SUPPLY)
            // =================================================================
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    key: const Key('quick_action_add_contribution'),
                    onPressed: () => context.push('/wallet/contribute'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon:
                        const Icon(Icons.add_circle_outline_rounded, size: 20),
                    label: Text(
                      ref.tr('Add Contribution', 'Weka Mchango'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('quick_action_add_expense'),
                    onPressed: () => context.push('/wallet/expense'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: cardSurface,
                      foregroundColor: primaryText,
                      side: BorderSide(color: cardBorder),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 20,
                      color: AppColors.error,
                    ),
                    label: Text(
                      ref.tr('Add Expense', 'Rekodi Matumizi'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // =================================================================
            // 4. HOUSEHOLD MEMBERS COUNT & CURRENT MONTH'S SPENDING
            // =================================================================
            Row(
              children: [
                Expanded(
                  child: AppSurfaceCard(
                    padding: const EdgeInsets.all(14),
                    onTap: () => context.push('/households/members'),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSoftGreen
                                : AppColors.softGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.people_alt_outlined,
                            color: isDark
                                ? const Color(0xFF34C486)
                                : AppColors.primaryGreen,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ref.tr('Members', 'Wanafamilia'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: secondaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${members.length} ${ref.tr('active', 'hai')}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: primaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppSurfaceCard(
                    padding: const EdgeInsets.all(14),
                    onTap: () => context.push('/reports'),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.warning.withValues(alpha: 0.2)
                                : AppColors.warningSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.warning,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ref.tr('Month Spending', 'Matumizi Mwezi Huu'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: secondaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppFormatters.formatCurrency(
                                  summary?.totalExpenses ??
                                      wallet.totalExpenses,
                                  symbol: household.currencySymbol,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: primaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // =================================================================
            // 5. COMPACT URGENT SUPPLY ALERT BANNER (Option 1: only if <= 3 days)
            // =================================================================
            if (urgentSupplies.isNotEmpty) ...[
              Builder(
                builder: (context) {
                  final names = urgentSupplies
                      .map((p) => ref.trItem(p.supplyName))
                      .join(', ');
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.warning.withValues(alpha: 0.16)
                          : AppColors.warningSoft,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cardSurface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.warning,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => ref
                                .read(dashboardTabIndexProvider.notifier)
                                .state = 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ref.tr(
                                    'Running Low: $names',
                                    'Zinakaribia Kuisha: $names',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: primaryText,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  ref.tr(
                                    '<= 3 days left • Tap to view in Insights ->',
                                    '<= siku 3 zimesalia • Gusa kuona Utabiri ->',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.warning,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            final lines = urgentSupplies.map((p) {
                              final d = p.daysUntilNextPurchase(
                                    DateTime.now(),
                                  ) ??
                                  0;
                              return '• *${ref.trItem(p.supplyName)}*: ${d <= 0 ? ref.tr('Needs refill now', 'Imekwisha') : ref.tr('~$d days left', '~siku $d zimesalia')}';
                            }).join('\n');
                            final msg = ref.tr(
                              '🏠 *NyumbaSmart Alert (${ref.trItem(household.name)})*\n'
                              '⚠️ The following household supplies are nearly finished:\n'
                              '$lines\n\n'
                              '💰 Shared Balance: ${AppFormatters.formatCurrency(wallet.availableBalance, symbol: household.currencySymbol)}',
                              '🏠 *Tahadhari ya NyumbaSmart (${ref.trItem(household.name)})*\n'
                              '⚠️ Mahitaji yafuatayo yanakaribia kuisha:\n'
                              '$lines\n\n'
                              '💰 Salio la Pamoja: ${AppFormatters.formatCurrency(wallet.availableBalance, symbol: household.currencySymbol)}',
                            );
                            ShareLauncher.showShareAlertSheet(
                              context: context,
                              title: ref.tr(
                                'Send Low-Supply Alert (WhatsApp / SMS)',
                                'Tuma Tahadhari (WhatsApp / SMS)',
                              ),
                              message: msg,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.send_rounded,
                              size: 16,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
            ],

            // =================================================================
            // 6. RECENT HOUSEHOLD ACTIVITY
            // =================================================================
            SectionHeader(
              title: ref.tr(
                'Recent Household Activity',
                'Miamala ya Hivi Karibuni',
              ),
              actionLabel: ref.tr('See All', 'Ona Yote'),
              onActionTap: () =>
                  ref.read(dashboardTabIndexProvider.notifier).state = 1,
            ),
            if (transactions.isEmpty)
              EmptyStateCard(
                icon: Icons.receipt_long_outlined,
                title: ref.tr('No Activity Yet', 'Hakuna Miamala Bado'),
                subtitle: ref.tr(
                  'Contributions and shared household purchases will appear here.',
                  'Michango na manunuzi ya pamoja yataonekana hapa.',
                ),
              )
            else
              ...transactions.take(5).map(
                    (tx) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TransactionRowCard(
                        title: ref.trItem(tx.description),
                        memberName: tx.memberName,
                        categoryName: ref.trItem(tx.categoryName),
                        date: tx.transactionDate,
                        signedAmount: tx.signedAmount,
                        currencySymbol: household.currencySymbol,
                        runningBalanceAfter: tx.balanceAfter,
                        onTap: () =>
                            context.push('/wallet/transaction/${tx.id}'),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
