import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/share_launcher.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../households/presentation/providers/household_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Future<void> _showSetBudgetDialog() async {
    final household = ref.read(activeHouseholdProvider);
    final categories = ref.read(activeHouseholdCategoriesProvider);
    if (household == null || categories.isEmpty) return;

    String selectedCatId = categories.first.id;
    final amountCtrl = TextEditingController(text: '150000');

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Set Monthly Category Budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedCatId,
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories
                    .map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) setDialogState(() => selectedCatId = val);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Monthly Budget (${household.currencySymbol})',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final amount =
                    double.tryParse(amountCtrl.text.replaceAll(',', '').trim());
                if (amount == null || amount <= 0) return;
                await ref
                    .read(householdLedgerRepositoryProvider)
                    .setMonthlyCategoryBudget(
                      householdId: household.id,
                      actorUserId: ref.read(currentUserIdProvider),
                      categoryId: selectedCatId,
                      month: ref.read(selectedReportMonthProvider),
                      budgetAmount: amount,
                    );
                ref.read(ledgerRevisionProvider.notifier).state++;
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: const Text('Save Budget'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCurrencyDialog() async {
    final household = ref.read(activeHouseholdProvider);
    if (household == null) return;

    await showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Select Household Currency'),
        children: SupportedCurrency.all
            .map(
              (c) => SimpleDialogOption(
                onPressed: () async {
                  await ref
                      .read(householdLedgerRepositoryProvider)
                      .updateHousehold(
                        householdId: household.id,
                        actorUserId: ref.read(currentUserIdProvider),
                        name: household.name,
                        description: household.description,
                        address: household.address,
                        currencyCode: c.code,
                        currencySymbol: c.symbol,
                      );
                  ref.read(ledgerRevisionProvider.notifier).state++;
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    '${c.name} (${c.symbol} - ${c.code})',
                    style: TextStyle(
                      fontWeight: c.code == household.currencyCode
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: c.code == household.currencyCode
                          ? AppColors.primaryBlue
                          : AppColors.textDark,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> _showEditProfileDialog() async {
    final user = ref.read(authControllerProvider).valueOrNull;
    if (user == null) return;
    final nameCtrl = TextEditingController(text: user.fullName);
    final phoneCtrl = TextEditingController(text: user.phoneNumber ?? '');

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ref.tr('Edit Administrator Profile', 'Hariri Wasifu')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: ref.tr('Full Name', 'Jina Kamili'),
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: ref.tr('Phone Number', 'Namba ya Simu'),
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(ref.tr('Cancel', 'Ghairi')),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              await ref.read(authControllerProvider.notifier).updateProfile(
                    user.copyWith(
                      fullName: nameCtrl.text.trim(),
                      phoneNumber: phoneCtrl.text.trim(),
                    ),
                  );
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: Text(ref.tr('Save Profile', 'Hifadhi')),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditAlertPhoneDialog() async {
    final alertSettings = ref.read(autoAlertSettingsProvider);
    final phoneCtrl = TextEditingController(text: alertSettings.preferredPhone);
    String selectedChannel = alertSettings.preferredChannel;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(
            ref.tr(
              'Preferred Automatic Alert Number',
              'Namba ya Kupokea Tahadhari za Moja kwa Moja',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                ref.tr(
                  'When any supply (LUKU, Gas, Water, Groceries) has <= 3 days left, NyumbaSmart will automatically send an alert to this number even if you do not open the app.',
                  'Bidhaa ikibakiza siku <= 3, NyumbaSmart itatuma ujumbe wa tahadhari moja kwa moja kwenye namba hii.',
                ),
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: ref.tr(
                    'Alert Phone Number (+255...)',
                    'Namba ya Simu (+255...)',
                  ),
                  prefixIcon: const Icon(Icons.phone_android_rounded),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: selectedChannel,
                decoration: InputDecoration(
                  labelText: ref.tr(
                    'Preferred Automatic Channel',
                    'Njia ya Kutuma Tahadhari',
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'sms',
                    child: Text(
                      ref.tr(
                        '📲 Auto Direct SMS (Background)',
                        '📲 SMS ya Moja kwa Moja',
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'whatsapp',
                    child: Text(
                      ref.tr(
                        '💬 WhatsApp Message',
                        '💬 Ujumbe wa WhatsApp',
                      ),
                    ),
                  ),
                ],
                onChanged: (v) {
                  if (v != null) setDialogState(() => selectedChannel = v);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(ref.tr('Cancel', 'Ghairi')),
            ),
            ElevatedButton(
              onPressed: () async {
                if (phoneCtrl.text.trim().isEmpty) return;
                await ref
                    .read(autoAlertSettingsProvider.notifier)
                    .saveAlertPreferences(
                      preferredPhone: phoneCtrl.text.trim(),
                      preferredChannel: selectedChannel,
                    );
                await ShareLauncher.requestAlertPermissions();
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: Text(ref.tr('Save Number', 'Hifadhi Namba')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).valueOrNull;
    final household = ref.watch(activeHouseholdProvider);
    final budgets = ref.watch(activeHouseholdBudgetsProvider);
    final syncState = ref.watch(syncStatusProvider);
    final currentLang = ref.watch(appLanguageProvider);
    final currentThemeMode = ref.watch(appThemeModeProvider);
    final autoAlertSettings = ref.watch(autoAlertSettingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryText =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          ref.tr('More & Settings', 'Zaidi na Mipangilio'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          SyncStatusBanner(
            isOnline: syncState.isOnline,
            message: syncState.lastSyncMessage ??
                ref.tr('Synced', 'Imelandanishwa'),
          ),
          const SizedBox(height: 16),

          // 1. Administrator Profile Card (Tappable to Edit Profile)
          AppSurfaceCard(
            onTap: _showEditProfileDialog,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor:
                      isDark ? AppColors.darkSoftGreen : AppColors.softGreen,
                  child: Text(
                    (user?.fullName ?? 'A').characters.first.toUpperCase(),
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF34C486)
                          : AppColors.primaryGreen,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.fullName ?? 'Dida Mwakasege',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: primaryText,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${user?.email ?? 'dida@rahisi.co.tz'} • ${ref.tr('Administrator', 'Msimamizi')}',
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: isDark
                      ? const Color(0xFF34C486)
                      : AppColors.primaryGreen,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Appearance / Theme Mode (Light & Dark Mode)
          SectionHeader(
            title: ref.tr('Appearance (Light / Dark Mode)', 'Muonekano wa Programu'),
          ),
          AppSurfaceCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: isDark
                          ? const Color(0xFF34C486)
                          : AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        ref.tr(
                          'Choose Theme Mode',
                          'Chagua Mwanga au Giza',
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: primaryText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        key: const Key('theme_chip_light'),
                        label: Center(
                          child: Text(
                            ref.tr('☀️ Light Mode', '☀️ Mwanga (Light)'),
                          ),
                        ),
                        selected: currentThemeMode == ThemeMode.light,
                        selectedColor: isDark
                            ? AppColors.darkSoftGreen
                            : AppColors.softGreen,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: currentThemeMode == ThemeMode.light
                              ? (isDark
                                  ? const Color(0xFF34C486)
                                  : AppColors.primaryGreenDark)
                              : primaryText,
                        ),
                        onSelected: (_) {
                          ref
                              .read(appThemeModeProvider.notifier)
                              .setThemeMode(ThemeMode.light);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        key: const Key('theme_chip_dark'),
                        label: Center(
                          child: Text(
                            ref.tr('🌙 Dark Mode', '🌙 Giza (Dark)'),
                          ),
                        ),
                        selected: currentThemeMode == ThemeMode.dark,
                        selectedColor: isDark
                            ? AppColors.darkSoftGreen
                            : AppColors.softGreen,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: currentThemeMode == ThemeMode.dark
                              ? (isDark
                                  ? const Color(0xFF34C486)
                                  : AppColors.primaryGreenDark)
                              : primaryText,
                        ),
                        onSelected: (_) {
                          ref
                              .read(appThemeModeProvider.notifier)
                              .setThemeMode(ThemeMode.dark);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Language / Lugha Switcher Card
          SectionHeader(
            title: ref.tr('Language / Lugha ya Programu', 'Lugha ya Programu'),
          ),
          AppSurfaceCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.language_rounded,
                      color: isDark
                          ? const Color(0xFF34C486)
                          : AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        ref.tr(
                          'Choose Application Language',
                          'Chagua Lugha ya Programu',
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: primaryText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        key: const Key('language_chip_english'),
                        label: const Center(
                          child: Text('🇬🇧 English (EN)'),
                        ),
                        selected: currentLang == AppLanguage.english,
                        selectedColor: isDark
                            ? AppColors.darkSoftGreen
                            : AppColors.softGreen,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: currentLang == AppLanguage.english
                              ? (isDark
                                  ? const Color(0xFF34C486)
                                  : AppColors.primaryGreenDark)
                              : primaryText,
                        ),
                        onSelected: (_) {
                          ref.read(appLanguageProvider.notifier).state =
                              AppLanguage.english;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        key: const Key('language_chip_swahili'),
                        label: const Center(
                          child: Text('🇹🇿 Kiswahili (SW)'),
                        ),
                        selected: currentLang == AppLanguage.swahili,
                        selectedColor: isDark
                            ? AppColors.darkSoftGreen
                            : AppColors.softGreen,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: currentLang == AppLanguage.swahili
                              ? (isDark
                                  ? const Color(0xFF34C486)
                                  : AppColors.primaryGreenDark)
                              : primaryText,
                        ),
                        onSelected: (_) {
                          ref.read(appLanguageProvider.notifier).state =
                              AppLanguage.swahili;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          SectionHeader(
            title: ref.tr(
              'Household, Analytics & Categories',
              'Nyumba, Ripoti na Makundi',
            ),
          ),
          AppSurfaceCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.home_work_outlined,
                    color: AppColors.primaryGreen,
                  ),
                  title: Text(
                    ref.tr(
                      'Switch or Manage Households',
                      'Badilisha au Simamia Nyumba',
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    '${ref.tr('Active', 'Inayotumika')}: ${household?.name ?? 'None'}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/households'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.pie_chart_outline_rounded,
                    color: AppColors.info,
                  ),
                  title: Text(
                    ref.tr(
                      'Reports & Monthly Analytics',
                      'Ripoti na Takwimu za Mwezi',
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    ref.tr(
                      'Category breakdown, member contributions & export',
                      'Mchanganuo wa matumizi, michango na ripoti',
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/reports'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.group_outlined,
                    color: AppColors.primaryGreen,
                  ),
                  title: Text(
                    ref.tr(
                      'Manage Household Members',
                      'Simamia Wanafamilia / Washiriki',
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    ref.tr(
                      'Add or view members sharing expenses',
                      'Ongeza au angalia wanaochangia matumizi',
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/households/members'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.category_outlined,
                    color: AppColors.warning,
                  ),
                  title: Text(
                    ref.tr('Expense Categories', 'Makundi ya Matumizi'),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    ref.tr(
                      'Create, rename, or deactivate categories',
                      'Unda au badilisha makundi ya matumizi',
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/households/categories'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.payments_outlined,
                    color: AppColors.primaryGreen,
                  ),
                  title: Text(
                    ref.tr('Currency & Region', 'Sarafu na Eneo'),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    '${household?.currencyCode ?? 'TZS'} (${household?.currencySymbol ?? 'TSh'}) • ${household?.timezone ?? 'Africa/Dar_es_Salaam'}',
                  ),
                  trailing: const Icon(Icons.edit_outlined, size: 18),
                  onTap: _showCurrencyDialog,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.cleaning_services_outlined,
                    color: AppColors.warning,
                  ),
                  title: Text(
                    ref.tr(
                      'Start Fresh / Clear Demo Data',
                      'Anza Upya / Futa Data ya Mfano',
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.warning,
                    ),
                  ),
                  subtitle: Text(
                    ref.tr(
                      'Reset current household balance to 0 and clear sample transactions',
                      'Weka salio kuwa 0 na ufute miamala ya mfano',
                    ),
                  ),
                  trailing: const Icon(
                    Icons.restart_alt_rounded,
                    color: AppColors.warning,
                  ),
                  onTap: () async {
                    if (household == null) return;
                    final confirmed = await showDestructiveConfirmationDialog(
                      context: context,
                      title: ref.tr(
                        'Clear Demo Data & Start Fresh?',
                        'Futa Data ya Mfano na Uanze Upya?',
                      ),
                      message: ref.tr(
                        'This will reset ${household.name}\'s shared wallet balance to 0 and clear its sample transactions and consumption history so you can record your real household data.',
                        'Hii itaweka salio la ${household.name} kuwa 0 na kufuta miamala ya mfano ili uanze kurekodi data zako halisi.',
                      ),
                      confirmLabel: ref.tr('Start Fresh', 'Anza Upya'),
                    );
                    if (confirmed && context.mounted) {
                      await ref
                          .read(householdLedgerRepositoryProvider)
                          .clearHouseholdDemoData(
                            householdId: household.id,
                            actorUserId: ref.read(currentUserIdProvider),
                          );
                      ref.read(ledgerRevisionProvider.notifier).state++;
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.primaryGreen,
                            content: Text(
                              ref.tr(
                                '${household.name} has been reset to 0. Ready for your real data!',
                                '${household.name} imewekwa upya kuwa 0. Tayari kwa data zako halisi!',
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          SectionHeader(
            title: 'Monthly Category Budgets (${budgets.length})',
            actionLabel: '+ Set Budget',
            onActionTap: _showSetBudgetDialog,
          ),
          Card(
            child: Column(
              children: [
                ...budgets.map(
                  (b) => ListTile(
                    title: Text(
                      b.budget.categoryName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      'Spent: ${AppFormatters.formatCurrency(b.amountSpent, symbol: household?.currencySymbol ?? 'TSh')} (${b.percentageUsed.toStringAsFixed(0)}%)',
                    ),
                    trailing: Text(
                      AppFormatters.formatCurrency(
                        b.budget.budgetAmount,
                        symbol: household?.currencySymbol ?? 'TSh',
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.add_chart_outlined,
                    color: AppColors.primaryBlue,
                  ),
                  title: const Text('Configure Monthly Category Budget'),
                  onTap: _showSetBudgetDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const SectionHeader(title: 'Notifications, Offline Sync & Security'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: autoAlertSettings.isAutoEnabled,
                  title: Text(
                    ref.tr(
                      'Automatic Low-Supply SMS / WhatsApp Alerts',
                      'Tahadhari za Moja kwa Moja (SMS / WhatsApp)',
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    ref.tr(
                      'Automatically send an alert to ${autoAlertSettings.preferredPhone} when a supply has <= 3 days left',
                      'Tuma ujumbe moja kwa moja kwenda ${autoAlertSettings.preferredPhone} bidhaa ikibakiza siku <= 3',
                    ),
                  ),
                  onChanged: (val) {
                    ref
                        .read(autoAlertSettingsProvider.notifier)
                        .saveAlertPreferences(
                          preferredPhone: autoAlertSettings.preferredPhone,
                          isAutoEnabled: val,
                        );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.phone_callback_rounded,
                    color: AppColors.primaryGreen,
                  ),
                  title: Text(
                    ref.tr(
                      'Preferred Alert Phone Number',
                      'Namba ya Kupokea Tahadhari',
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    '${autoAlertSettings.preferredPhone} • ${autoAlertSettings.preferredChannel == 'whatsapp' ? 'WhatsApp' : 'Auto Direct SMS'}',
                  ),
                  trailing: const Icon(Icons.edit_outlined, size: 18),
                  onTap: _showEditAlertPhoneDialog,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.send_to_mobile_rounded,
                    color: AppColors.info,
                  ),
                  title: Text(
                    ref.tr(
                      'Send Automatic Alert Now (Test)',
                      'Tuma Tahadhari ya Majaribio Sasa',
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    ref.tr(
                      'Dispatch low-supply alert immediately to ${autoAlertSettings.preferredPhone}',
                      'Tuma tahadhari sasa hivi kwenda ${autoAlertSettings.preferredPhone}',
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    if (household == null) return;
                    final wallet = ref.read(activeHouseholdWalletProvider);
                    final predictions =
                        ref.read(activeHouseholdPredictionsProvider);
                    await ShareLauncher.checkAndAutoSendLowSupplyAlerts(
                      householdId: household.id,
                      householdName: household.name,
                      currencySymbol: household.currencySymbol,
                      availableBalance: wallet?.availableBalance ?? 0,
                      predictions: predictions,
                      forceSendNow: true,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.primaryGreen,
                          content: Text(
                            ref.tr(
                              'Automatic alert dispatched to ${autoAlertSettings.preferredPhone}!',
                              'Tahadhari imetumwa kwenda ${autoAlertSettings.preferredPhone}!',
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                const Divider(),
                SwitchListTile(
                  value: !syncState.isOnline,
                  title: const Text('Simulate Offline Network Interruption'),
                  subtitle: const Text(
                    'Test offline resilience and ledger sync status banner',
                  ),
                  onChanged: (offline) {
                    ref
                        .read(syncStatusProvider.notifier)
                        .setOfflineMode(offline);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.history_edu_outlined,
                    color: AppColors.primaryBlue,
                  ),
                  title: const Text('View Immutable Financial Audit Trail'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/wallet/audit-logs'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.lock_reset_outlined,
                    color: AppColors.textDark,
                  ),
                  title: const Text('Change Administrator Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/reset-password'),
                ),
                const Divider(),
                ListTile(
                  key: const Key('settings_logout_tile'),
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.expenseRed,
                  ),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: AppColors.expenseRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () async {
                    final confirmed = await showDestructiveConfirmationDialog(
                      context: context,
                      title: 'Log Out?',
                      message:
                          'Are you sure you want to log out of your administrator account?',
                      confirmLabel: 'Log Out',
                    );
                    if (confirmed && context.mounted) {
                      await ref.read(authControllerProvider.notifier).logout();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
