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
import '../../../sync/presentation/providers/sync_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;

  const SettingsScreen({super.key, this.onBack});

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

  Future<void> _showLowBalanceThresholdDialog() async {
    final household = ref.read(activeHouseholdProvider);
    if (household == null) return;

    final thresholdCtrl = TextEditingController(
      text: household.lowBalanceThreshold.toStringAsFixed(0),
    );

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.warning,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ref.tr(
                    'Low Balance Alert Threshold',
                    'Kiwango cha Tahadhari ya Salio',
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ref.tr(
                    'Set the minimum wallet balance that triggers low-balance warnings and pop-up notifications:',
                    'Weka kiasi cha chini cha salio la pochi kitakachotuma tahadhari ya salio kuwa chini:',
                  ),
                  style: const TextStyle(fontSize: 12.5),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: thresholdCtrl,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: ref.tr(
                      'Alert Threshold (${household.currencySymbol})',
                      'Kiwango cha Tahadhari (${household.currencySymbol})',
                    ),
                    prefixIcon: const Icon(Icons.notifications_active_outlined),
                    hintText: 'e.g. 25000',
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [20000, 30000, 50000, 100000].map((preset) {
                    return ActionChip(
                      label: Text(
                        AppFormatters.formatCurrency(
                          preset.toDouble(),
                          symbol: household.currencySymbol,
                        ),
                        style: const TextStyle(fontSize: 11.5),
                      ),
                      onPressed: () {
                        thresholdCtrl.text = preset.toString();
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(ref.tr('Cancel', 'Ghairi')),
            ),
            ElevatedButton(
              onPressed: () async {
                final amount = AppFormatters.tryParseAmount(thresholdCtrl.text);
                if (amount == null || amount < 0) return;

                final repo = ref.read(householdLedgerRepositoryProvider);
                final userId = ref.read(currentUserIdProvider);

                await repo.updateHousehold(
                  householdId: household.id,
                  actorUserId: userId,
                  name: household.name,
                  description: household.description,
                  address: household.address,
                  currencyCode: household.currencyCode,
                  currencySymbol: household.currencySymbol,
                  lowBalanceThreshold: amount,
                );
                ref.read(ledgerRevisionProvider.notifier).state++;

                if (ctx.mounted) Navigator.of(ctx).pop();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: AppColors.primaryGreen,
                      content: Text(
                        ref.tr(
                          'Alert threshold updated to ${AppFormatters.formatCurrency(amount, symbol: household.currencySymbol)}.',
                          'Kiwango cha tahadhari kimesasishwa kuwa ${AppFormatters.formatCurrency(amount, symbol: household.currencySymbol)}.',
                        ),
                      ),
                    ),
                  );
              },
              child: Text(ref.tr('Save Threshold', 'Hifadhi Kiwango')),
            ),
          ],
        ),
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

  Future<void> _showDailyReminderTimePicker() async {
    final alertSettings = ref.read(autoAlertSettingsProvider);
    final initialTime = TimeOfDay(
      hour: alertSettings.reminderHour,
      minute: alertSettings.reminderMinute,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: ref.tr(
        'Select Daily Supply Reminder Time',
        'Chagua Muda wa Tahadhari za Kila Siku',
      ),
    );
    if (picked != null) {
      await ref.read(autoAlertSettingsProvider.notifier).saveAlertPreferences(
            reminderHour: picked.hour,
            reminderMinute: picked.minute,
          );
      await ShareLauncher.requestAlertPermissions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primaryGreen,
            content: Text(
              ref.tr(
                'Daily reminder time set to ${picked.format(context)}',
                'Muda wa tahadhari umewekwa kuwa ${picked.format(context)}',
              ),
            ),
          ),
        );
      }
    }
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
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: widget.onBack,
              )
            : null,
        title: Text(
          ref.tr('More & Settings', 'Zaidi na Mipangilio'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          SyncStatusBanner(
            isOnline: syncState.isOnline,
            message:
                syncState.lastSyncMessage ?? ref.tr('Synced', 'Imelandanishwa'),
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
                        user?.fullName ?? 'NyumbaSmart User',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: primaryText,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${user?.email ?? 'Not signed in'} • ${ref.tr('Administrator', 'Msimamizi')}',
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
                  color:
                      isDark ? const Color(0xFF34C486) : AppColors.primaryGreen,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Appearance / Theme Mode (Light & Dark Mode)
          SectionHeader(
            fontSize: 14.5,
            title: ref.tr(
                'Appearance (Light / Dark Mode)', 'Muonekano wa Programu'),
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
                          fontSize: 13.5,
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
                          fontSize: 12.5,
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
                          fontSize: 12.5,
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
            fontSize: 14.5,
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
                          fontSize: 13.5,
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
                          fontSize: 12.5,
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
                          fontSize: 12.5,
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
            fontSize: 14.5,
            title: ref.tr(
              'Household, Analytics & Categories',
              'Nyumba, Ripoti na Makundi',
            ),
          ),
          AppSurfaceCard(
            padding: EdgeInsets.zero,
            child: ListTileTheme(
              data: ListTileThemeData(
                dense: true,
                titleTextStyle: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: primaryText,
                ),
                subtitleTextStyle: TextStyle(
                  fontSize: 11.5,
                  color: secondaryText,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.home_work_outlined,
                      size: 20,
                      color: AppColors.primaryGreen,
                    ),
                    title: Text(
                      ref.tr(
                        'Switch or Manage Households',
                        'Badilisha au Simamia Nyumba',
                      ),
                    ),
                    subtitle: Text(
                      '${ref.tr('Active', 'Inayotumika')}: ${household?.name ?? 'None'}',
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => context.push('/households'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.pie_chart_outline_rounded,
                      size: 20,
                      color: AppColors.info,
                    ),
                    title: Text(
                      ref.tr(
                        'Reports & Monthly Analytics',
                        'Ripoti na Takwimu za Mwezi',
                      ),
                    ),
                    subtitle: Text(
                      ref.tr(
                        'Category breakdown, member contributions & export',
                        'Mchanganuo wa matumizi, michango na ripoti',
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => context.push('/reports'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.group_outlined,
                      size: 20,
                      color: AppColors.primaryGreen,
                    ),
                    title: Text(
                      ref.tr(
                        'Manage Household Members',
                        'Simamia Wanafamilia / Washiriki',
                      ),
                    ),
                    subtitle: Text(
                      ref.tr(
                        'Add or view members sharing expenses',
                        'Ongeza au angalia wanaochangia matumizi',
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => context.push('/households/members'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.category_outlined,
                      size: 20,
                      color: AppColors.warning,
                    ),
                    title: Text(
                      ref.tr('Expense Categories', 'Makundi ya Matumizi'),
                    ),
                    subtitle: Text(
                      ref.tr(
                        'Create, rename, or deactivate categories',
                        'Unda au badilisha makundi ya matumizi',
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => context.push('/households/categories'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.payments_outlined,
                      size: 20,
                      color: AppColors.primaryGreen,
                    ),
                    title: Text(
                      ref.tr('Currency & Region', 'Sarafu na Eneo'),
                    ),
                    subtitle: Text(
                      '${household?.currencyCode ?? 'TZS'} (${household?.currencySymbol ?? 'TSh'}) • ${household?.timezone ?? 'Africa/Dar_es_Salaam'}',
                    ),
                    trailing: const Icon(Icons.edit_outlined, size: 16),
                    onTap: _showCurrencyDialog,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 20,
                      color: AppColors.warning,
                    ),
                    title: Text(
                      ref.tr(
                        'Low Balance Alert Threshold',
                        'Kiwango cha Tahadhari ya Salio',
                      ),
                    ),
                    subtitle: Text(
                      '${ref.tr('Alert when balance drops below', 'Tahadharisha salio likiwa chini ya')}: ${AppFormatters.formatCurrency(household?.lowBalanceThreshold ?? 25000, symbol: household?.currencySymbol ?? 'TSh')}',
                    ),
                    trailing: const Icon(Icons.edit_outlined, size: 16),
                    onTap: _showLowBalanceThresholdDialog,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.edit_note_rounded,
                      size: 20,
                      color: AppColors.primaryGreen,
                    ),
                    title: Text(
                      ref.tr(
                        'Household Details & Settings',
                        'Taarifa za Kaya na Mipangilio',
                      ),
                    ),
                    subtitle: Text(
                      ref.tr(
                        'Edit household name, address & settings',
                        'Badilisha jina la kaya, anwani na mipangilio',
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => context.push('/households/edit'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.cleaning_services_outlined,
                      size: 20,
                      color: AppColors.warning,
                    ),
                    title: Text(
                      ref.tr(
                        'Start Fresh / Clear Demo Data',
                        'Anza Upya / Futa Data ya Mfano',
                      ),
                      style: const TextStyle(
                        fontSize: 13.5,
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
                      size: 18,
                      color: AppColors.warning,
                    ),
                    onTap: () async {
                      if (household == null) return;
                      final confirmed =
                          await showDestructiveConfirmationDialog(
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
          ),
          const SizedBox(height: 20),

          SectionHeader(
            fontSize: 14.5,
            title: 'Monthly Category Budgets (${budgets.length})',
            actionLabel: '+ Set Budget',
            onActionTap: _showSetBudgetDialog,
          ),
          Card(
            child: ListTileTheme(
              data: ListTileThemeData(
                dense: true,
                titleTextStyle: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: primaryText,
                ),
                subtitleTextStyle: TextStyle(
                  fontSize: 11.5,
                  color: secondaryText,
                ),
              ),
              child: Column(
                children: [
                  ...budgets.map(
                    (b) => ListTile(
                      title: Text(b.budget.categoryName),
                      subtitle: Text(
                        'Spent: ${AppFormatters.formatCurrency(b.amountSpent, symbol: household?.currencySymbol ?? 'TSh')} (${b.percentageUsed.toStringAsFixed(0)}%)',
                      ),
                      trailing: Text(
                        AppFormatters.formatCurrency(
                          b.budget.budgetAmount,
                          symbol: household?.currencySymbol ?? 'TSh',
                        ),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.add_chart_outlined,
                      size: 20,
                      color: AppColors.primaryBlue,
                    ),
                    title: const Text('Configure Monthly Category Budget'),
                    onTap: _showSetBudgetDialog,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const SectionHeader(
            fontSize: 14.5,
            title: 'Notifications, Offline Sync & Security',
          ),
          Card(
            child: ListTileTheme(
              data: ListTileThemeData(
                dense: true,
                titleTextStyle: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: primaryText,
                ),
                subtitleTextStyle: TextStyle(
                  fontSize: 11.5,
                  color: secondaryText,
                ),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: autoAlertSettings.isAutoEnabled,
                    title: Text(
                      ref.tr(
                        'Automatic Pop-Up Supply Reminders',
                        'Tahadhari za Programu za Moja kwa Moja',
                      ),
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: primaryText,
                      ),
                    ),
                    subtitle: Text(
                      ref.tr(
                        'Free background push notification pops up (with sound) when any supply has <= 3 days left — even if the app is closed',
                        'Tahadhari itajitokeza juu ya simu kwa mlio bure bidhaa ikibakiza siku <= 3 — hata programu ikiwa imefungwa',
                      ),
                      style: TextStyle(fontSize: 11.5, color: secondaryText),
                    ),
                    onChanged: (val) {
                      ref
                          .read(autoAlertSettingsProvider.notifier)
                          .saveAlertPreferences(
                            isAutoEnabled: val,
                          );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.access_time_rounded,
                      size: 20,
                      color: AppColors.primaryGreen,
                    ),
                    title: Text(
                      ref.tr(
                        'Daily Reminder Time',
                        'Muda wa Tahadhari wa Kila Siku',
                      ),
                    ),
                    subtitle: Text(
                      ref.tr(
                        '${autoAlertSettings.formattedTime} (Tap to change)',
                        'Saa ${autoAlertSettings.formattedTime} (Gusa kubadilisha)',
                      ),
                    ),
                    trailing: const Icon(Icons.edit_outlined, size: 16),
                    onTap: _showDailyReminderTimePicker,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 20,
                      color: AppColors.warning,
                    ),
                    title: Text(
                      ref.tr(
                        'Wallet Balance Alert Threshold',
                        'Kiwango cha Tahadhari ya Salio',
                      ),
                    ),
                    subtitle: Text(
                      '${ref.tr('Alerts fire when balance drops to', 'Tahadhari inatoka salio likifikia')}: ${AppFormatters.formatCurrency(household?.lowBalanceThreshold ?? 25000, symbol: household?.currencySymbol ?? 'TSh')}',
                    ),
                    trailing: const Icon(Icons.edit_outlined, size: 16),
                    onTap: _showLowBalanceThresholdDialog,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.alarm_on_rounded,
                      size: 20,
                      color: AppColors.info,
                    ),
                    title: Text(
                      ref.tr(
                        'Test Pop-Up Reminder (5 Seconds)',
                        'Jaribu Tahadhari ya Simu (Sekunde 5)',
                      ),
                    ),
                    subtitle: Text(
                      ref.tr(
                        'Schedules a heads-up pop-up alert in 5 seconds. Minimize/close app to watch it pop up!',
                        'Inaratibu tahadhari itakayojitokeza baada ya sekunde 5. Funga programu ili uione ikitokea!',
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () async {
                      await ShareLauncher.scheduleBackgroundPopupReminder(
                        title:
                            '🏠 NyumbaSmart • ${household?.name ?? 'Household'}',
                        message: ref.tr(
                          '⚠️ Reminder: LUKU Electricity & Gas are running low. Tap to review shared supplies!',
                          '⚠️ Tahadhari: Umeme wa LUKU na Gesi vinakaribia kuisha. Gusa kuangalia mahitaji!',
                        ),
                        delay: const Duration(seconds: 5),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.primaryGreen,
                            duration: const Duration(seconds: 5),
                            content: Text(
                              ref.tr(
                                '⏰ Pop-up reminder scheduled in 5 seconds! Close or minimize the app now to see it pop down like a message!',
                                '⏰ Tahadhari itatokea baada ya sekunde 5! Funga au weka programu pembeni sasa uione ikijitokeza juu ya kioo!',
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.sync_rounded,
                      size: 20,
                      color: AppColors.primaryGreen,
                    ),
                    title: const Text('Sync Now with Cloud Firestore'),
                    subtitle: Text(
                      syncState.lastSyncMessage ??
                          'Pushes offline queue and pulls latest cloud records',
                    ),
                    trailing: syncState.syncStatus == SyncStatus.syncing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh_rounded, size: 20),
                    onTap: syncState.syncStatus == SyncStatus.syncing
                        ? null
                        : () async {
                            final success = await ref
                                .read(offlineSyncCoordinatorProvider)
                                .syncAll(force: true);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: success
                                      ? AppColors.primaryGreen
                                      : AppColors.expenseRed,
                                  content: Text(
                                    success
                                        ? 'Cloud sync completed successfully.'
                                        : 'Sync paused: offline or could not reach Firestore.',
                                  ),
                                ),
                              );
                            }
                          },
                  ),
                  const Divider(),
                  SwitchListTile(
                    value: !syncState.isOnline,
                    title: Text(
                      'Simulate Offline Network Interruption',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: primaryText,
                      ),
                    ),
                    subtitle: Text(
                      'Test offline resilience and ledger sync status banner',
                      style: TextStyle(fontSize: 11.5, color: secondaryText),
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
                      size: 20,
                      color: AppColors.primaryBlue,
                    ),
                    title: const Text('View Immutable Financial Audit Trail'),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => context.push('/wallet/audit-logs'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.lock_reset_outlined,
                      size: 20,
                      color: primaryText,
                    ),
                    title: const Text('Change Administrator Password'),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => context.push('/reset-password'),
                  ),
                  const Divider(),
                  ListTile(
                    key: const Key('settings_logout_tile'),
                    leading: const Icon(
                      Icons.logout_rounded,
                      size: 20,
                      color: AppColors.expenseRed,
                    ),
                    title: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.expenseRed,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () async {
                      final confirmed =
                          await showDestructiveConfirmationDialog(
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
          ),
        ],
      ),
    );
  }
}
