import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../households/presentation/providers/household_providers.dart';
import '../../domain/entities/wallet_entities.dart';

/// 1. ADD CONTRIBUTION SCREEN (Section 6.1)
class AddContributionScreen extends ConsumerStatefulWidget {
  const AddContributionScreen({super.key});

  @override
  ConsumerState<AddContributionScreen> createState() =>
      _AddContributionScreenState();
}

class _AddContributionScreenState extends ConsumerState<AddContributionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _memberNameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;
  String? _errorMsg;

  @override
  void dispose() {
    _memberNameCtrl.dispose();
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final household = ref.read(activeHouseholdProvider);
    if (household == null) return;

    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '').trim());
    if (amount == null || amount <= 0) {
      setState(() => _errorMsg = 'Please enter a valid positive amount.');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMsg = null;
    });

    try {
      final repo = ref.read(householdLedgerRepositoryProvider);
      final userId = ref.read(currentUserIdProvider);
      final member = await repo.resolveOrCreateMemberByName(
        householdId: household.id,
        actorUserId: userId,
        writtenName: _memberNameCtrl.text,
      );

      await repo.recordContribution(
        householdId: household.id,
        actorUserId: userId,
        memberId: member.id,
        amount: amount,
        contributionDate: _selectedDate,
        description: _descCtrl.text,
      );
      ref.read(ledgerRevisionProvider.notifier).state++;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.successGreen,
            content: Text(
              'Contribution of ${AppFormatters.formatCurrency(amount, symbol: household.currencySymbol)} by ${member.displayName} recorded!',
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      setState(() => _errorMsg = e.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final households = ref.watch(userHouseholdsProvider);
    final activeHousehold = ref.watch(activeHouseholdProvider);
    final members = ref.watch(activeHouseholdMembersProvider);
    final wallet = ref.watch(activeHouseholdWalletProvider);

    if (activeHousehold == null || wallet == null) {
      return const Scaffold(body: Center(child: Text('No active household')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Record Member Contribution')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.successGreenLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Household Balance:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      AppFormatters.formatCurrency(
                        wallet.availableBalance,
                        symbol: activeHousehold.currencySymbol,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.successGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_errorMsg != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.expenseRedLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _errorMsg!,
                    style: const TextStyle(
                      color: AppColors.expenseRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              DropdownButtonFormField<String>(
                value: activeHousehold.id,
                decoration: const InputDecoration(
                  labelText: 'Select Household',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
                items: households
                    .map(
                      (h) => DropdownMenuItem(
                        value: h.id,
                        child: Text(h.name),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    ref.read(selectedHouseholdIdProvider.notifier).state = val;
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('contribution_member_name_field'),
                controller: _memberNameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Write Member Name (Who Contributed?)',
                  hintText: 'Type member name (e.g. Dida, Asha, Juma)',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please write the contributing member name'
                    : null,
              ),
              if (members.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: members
                      .map(
                        (m) => ActionChip(
                          avatar: const Icon(Icons.person, size: 14),
                          label: Text(
                            m.displayName,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              _memberNameCtrl.text = m.displayName;
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('contribution_amount_field'),
                controller: _amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText:
                      'Contribution Amount (${activeHousehold.currencySymbol})',
                  hintText: 'e.g. 100000',
                  prefixIcon: const Icon(Icons.add_card_outlined),
                ),
                validator: (val) {
                  final parsed =
                      double.tryParse((val ?? '').replaceAll(',', '').trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Enter an amount greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Contribution Date',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(AppFormatters.formatDate(_selectedDate)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('contribution_desc_field'),
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Optional Description',
                  hintText: 'e.g. Monthly household pool contribution',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Note: Household members can contribute different amounts. All contributions go into the shared household pool without creating personal debt between members.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                key: const Key('contribution_save_btn'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.successGreen,
                ),
                onPressed: _isSaving ? null : _submit,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Save Contribution'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 2. ADD EXPENSE SCREEN (Section 6.2 & 6.3 Insufficient Balance Protection)
class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _memberNameCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;
  String? _errorMsg;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _memberNameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final household = ref.read(activeHouseholdProvider);
    final categories =
        ref.read(activeHouseholdCategoriesProvider).where((c) => c.isActive);

    final categoryId = _selectedCategoryId ?? categories.firstOrNull?.id;
    if (household == null || categoryId == null) return;

    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '').trim());
    if (amount == null || amount <= 0) {
      setState(() => _errorMsg = 'Please enter a valid expense amount.');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMsg = null;
    });

    try {
      final repo = ref.read(householdLedgerRepositoryProvider);
      final userId = ref.read(currentUserIdProvider);
      final member = await repo.resolveOrCreateMemberByName(
        householdId: household.id,
        actorUserId: userId,
        writtenName: _memberNameCtrl.text,
      );

      await repo.recordExpense(
        householdId: household.id,
        actorUserId: userId,
        categoryId: categoryId,
        paidByMemberId: member.id,
        title: _titleCtrl.text,
        amount: amount,
        expenseDate: _selectedDate,
        notes: _notesCtrl.text,
      );
      ref.read(ledgerRevisionProvider.notifier).state++;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Expense of ${AppFormatters.formatCurrency(amount, symbol: household.currencySymbol)} by ${member.displayName} recorded and deducted from wallet!',
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      setState(() => _errorMsg = e.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final households = ref.watch(userHouseholdsProvider);
    final activeHousehold = ref.watch(activeHouseholdProvider);
    final categories = ref
        .watch(activeHouseholdCategoriesProvider)
        .where((c) => c.isActive)
        .toList();
    final members = ref.watch(activeHouseholdMembersProvider);
    final wallet = ref.watch(activeHouseholdWalletProvider);

    if (activeHousehold == null || wallet == null) {
      return const Scaffold(body: Center(child: Text('No active household')));
    }

    final effectiveCategoryId =
        _selectedCategoryId ?? categories.firstOrNull?.id;
    final enteredAmount =
        double.tryParse(_amountCtrl.text.replaceAll(',', '').trim()) ?? 0.0;
    final exceedsBalance = enteredAmount > wallet.availableBalance;

    return Scaffold(
      appBar: AppBar(title: const Text('Record Household Expense')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: exceedsBalance
                      ? AppColors.expenseRedLight
                      : AppColors.primaryBlueLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Available Household Balance:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          AppFormatters.formatCurrency(
                            wallet.availableBalance,
                            symbol: activeHousehold.currencySymbol,
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: exceedsBalance
                                ? AppColors.expenseRed
                                : AppColors.primaryBlueDark,
                          ),
                        ),
                      ],
                    ),
                    if (exceedsBalance) ...[
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.expenseRed,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Warning: Insufficient household balance! Expenses cannot make the wallet balance negative.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.expenseRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_errorMsg != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.expenseRedLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _errorMsg!,
                    style: const TextStyle(
                      color: AppColors.expenseRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              DropdownButtonFormField<String>(
                value: activeHousehold.id,
                decoration: const InputDecoration(
                  labelText: 'Select Household',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
                items: households
                    .map(
                      (h) => DropdownMenuItem(value: h.id, child: Text(h.name)),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    ref.read(selectedHouseholdIdProvider.notifier).state = val;
                    setState(() {
                      _selectedCategoryId = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: const Key('expense_category_dropdown'),
                value: effectiveCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Expense Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: categories
                    .map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('expense_title_field'),
                controller: _titleCtrl,
                decoration: InputDecoration(
                  labelText: ref.tr(
                    'Expense Item / Title (What was purchased?)',
                    'Bidhaa Iliyonunuliwa',
                  ),
                  hintText: ref.tr(
                    'e.g. Flour, Sugar, Cooking Oil, Spices, Seasonings, Electricity',
                    'mf. Unga, Sukari, Mafuta ya Kupikia, Viungo, Umeme',
                  ),
                  prefixIcon: const Icon(Icons.shopping_bag_outlined),
                ),
                validator: (val) => val == null || val.trim().length < 2
                    ? ref.tr(
                        'Enter what was purchased',
                        'Andika kilichonunuliwa',
                      )
                    : null,
              ),
              if (categories
                      .where((c) => c.id == effectiveCategoryId)
                      .firstOrNull
                      ?.slug ==
                  'groceries') ...[
                const SizedBox(height: 8),
                Text(
                  ref.tr(
                    'Select a separate Grocery Item (or type above):',
                    'Chagua Bidhaa ya Jikoni (au andika hapo juu):',
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: (ref.watch(appLanguageProvider) ==
                              AppLanguage.swahili
                          ? const [
                              'Unga',
                              'Sukari',
                              'Mafuta ya Kupikia',
                              'Viungo vya Pilau',
                              'Viungo',
                              'Mchele',
                              'Maziwa',
                              'Mayai',
                              'Sabuni',
                            ]
                          : const [
                              'Flour',
                              'Sugar',
                              'Cooking Oil',
                              'Spices',
                              'Seasonings',
                              'Rice',
                              'Milk',
                              'Eggs',
                              'Soap',
                            ])
                      .map(
                        (item) => ActionChip(
                          avatar: const Icon(
                            Icons.shopping_basket_outlined,
                            size: 14,
                          ),
                          label: Text(
                            item,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              _titleCtrl.text = item;
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('expense_amount_field'),
                controller: _amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText:
                      'Amount Spent (${activeHousehold.currencySymbol})',
                  hintText: 'e.g. 50000',
                  prefixIcon: const Icon(Icons.payments_outlined),
                ),
                validator: (val) {
                  final parsed =
                      double.tryParse((val ?? '').replaceAll(',', '').trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid positive amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('expense_member_name_field'),
                controller: _memberNameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Who Made the Purchase? (Write Member Name)',
                  hintText: 'Type member name (e.g. Dida, Asha, Juma)',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please write the name of the member who made the purchase'
                    : null,
              ),
              if (members.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: members
                      .map(
                        (m) => ActionChip(
                          avatar: const Icon(Icons.person, size: 14),
                          label: Text(
                            m.displayName,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              _memberNameCtrl.text = m.displayName;
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Actual Purchase Date (When Was It Bought?)',
                    helperText:
                        'If bought earlier (e.g. yesterday) and recorded today, select when it was actually bought.',
                    helperMaxLines: 2,
                    prefixIcon: Icon(Icons.calendar_month_outlined),
                    suffixIcon: Icon(Icons.edit_calendar_outlined),
                  ),
                  child: Text(
                    AppFormatters.formatDate(_selectedDate),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.today_outlined, size: 15),
                    label: const Text(
                      'Bought Today',
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: () {
                      setState(() => _selectedDate = DateTime.now());
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.history_outlined, size: 15),
                    label: const Text(
                      'Bought Yesterday',
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: () {
                      setState(
                        () => _selectedDate =
                            DateTime.now().subtract(const Duration(days: 1)),
                      );
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.calendar_month_outlined, size: 15),
                    label: const Text(
                      'Choose on Calendar...',
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: _pickDate,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(
                  labelText: 'Optional Notes',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                key: const Key('expense_save_btn'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryOrange,
                ),
                onPressed: (_isSaving || exceedsBalance) ? null : _submit,
                icon: const Icon(Icons.receipt_long_outlined),
                label: const Text('Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 3. UNIFIED WALLET & TRANSACTION HISTORY SCREEN (Section 6.4)
class TransactionHistoryScreen extends ConsumerWidget {
  final VoidCallback? onBack;

  const TransactionHistoryScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final household = ref.watch(activeHouseholdProvider);
    final wallet = ref.watch(activeHouseholdWalletProvider);
    final transactions = ref.watch(activeHouseholdTransactionsProvider);
    final members = ref.watch(activeHouseholdMembersProvider);
    final categories = ref.watch(activeHouseholdCategoriesProvider);
    final filter = ref.watch(transactionFilterProvider);

    if (household == null || wallet == null) {
      return const Scaffold(body: Center(child: Text('No active household')));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: onBack,
              )
            : null,
        title: Text(
          '${ref.tr('Activity & Ledger', 'Miamala na Leja')} • ${household.name}',
        ),
        actions: [
          IconButton(
            tooltip: ref.tr('Audit Log', 'Ukaguzi wa Miamala'),
            icon: const Icon(Icons.history_edu_outlined),
            onPressed: () => context.push('/wallet/audit-logs'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Wallet Summary Bar
          Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 10),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.primaryGreenDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ref.tr(
                    'Available Shared Balance',
                    'Salio la Pamoja Linalopatikana',
                  ),
                  style: const TextStyle(
                    color: Color(0xFFD8EFE3),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppFormatters.formatCurrency(
                    wallet.availableBalance,
                    symbol: household.currencySymbol,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${ref.tr('Contributions', 'Michango')}: ${AppFormatters.formatCurrency(wallet.totalContributions, symbol: household.currencySymbol)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${ref.tr('Expenses', 'Matumizi')}: ${AppFormatters.formatCurrency(wallet.totalExpenses, symbol: household.currencySymbol)}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filter Chips Bar (Member, Category, Type)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              children: [
                FilterChip(
                  label: Text(ref.tr('All Types', 'Aina Zote')),
                  selected: filter.transactionType == null,
                  onSelected: (_) {
                    ref.read(transactionFilterProvider.notifier).state =
                        filter.copyWith(clearType: true);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(ref.tr('Contributions Only', 'Michango Pekee')),
                  selected: filter.transactionType ==
                      WalletTransactionType.contribution,
                  onSelected: (_) {
                    ref.read(transactionFilterProvider.notifier).state =
                        filter.copyWith(
                      transactionType: WalletTransactionType.contribution,
                    );
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(ref.tr('Expenses Only', 'Matumizi Pekee')),
                  selected:
                      filter.transactionType == WalletTransactionType.expense,
                  onSelected: (_) {
                    ref.read(transactionFilterProvider.notifier).state =
                        filter.copyWith(
                      transactionType: WalletTransactionType.expense,
                    );
                  },
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String?>(
                  tooltip: 'Filter by Member',
                  onSelected: (memberId) {
                    ref.read(transactionFilterProvider.notifier).state =
                        memberId == null
                            ? filter.copyWith(clearMember: true)
                            : filter.copyWith(memberId: memberId);
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem<String?>(
                      value: null,
                      child: Text('All Members'),
                    ),
                    ...members.map(
                      (m) => PopupMenuItem<String?>(
                        value: m.id,
                        child: Text(m.displayName),
                      ),
                    ),
                  ],
                  child: Chip(
                    avatar: const Icon(Icons.person_outline, size: 16),
                    label: Text(
                      filter.memberId == null
                          ? 'Member: All'
                          : 'Member Filtered',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String?>(
                  tooltip: 'Filter by Category',
                  onSelected: (catId) {
                    ref.read(transactionFilterProvider.notifier).state =
                        catId == null
                            ? filter.copyWith(clearCategory: true)
                            : filter.copyWith(categoryId: catId);
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem<String?>(
                      value: null,
                      child: Text('All Categories'),
                    ),
                    ...categories.map(
                      (c) => PopupMenuItem<String?>(
                        value: c.id,
                        child: Text(c.name),
                      ),
                    ),
                  ],
                  child: Chip(
                    avatar: const Icon(Icons.category_outlined, size: 16),
                    label: Text(
                      filter.categoryId == null
                          ? 'Category: All'
                          : 'Category Filtered',
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: transactions.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: EmptyStateCard(
                      icon: Icons.receipt_long_outlined,
                      title: 'No Matching Transactions',
                      subtitle:
                          'Record a member contribution or household expense to see the chronological ledger.',
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    itemCount: transactions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      return TransactionRowCard(
                        title: ref.trItem(tx.description),
                        memberName: tx.memberName,
                        categoryName: ref.trItem(tx.categoryName),
                        date: tx.transactionDate,
                        signedAmount: tx.signedAmount,
                        currencySymbol: household.currencySymbol,
                        runningBalanceAfter: tx.balanceAfter,
                        onTap: () =>
                            context.push('/wallet/transaction/${tx.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                  ),
                  onPressed: () => context.push('/wallet/contribute'),
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                  label: Text(ref.tr('Add Contribution', 'Weka Mchango')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/wallet/expense'),
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 18,
                    color: AppColors.error,
                  ),
                  label: Text(ref.tr('Add Expense', 'Rekodi Matumizi')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 4. TRANSACTION DETAILS & AUDIT-LOGGED CORRECTION / REVERSAL SCREEN
class TransactionDetailsAndCorrectionScreen extends ConsumerStatefulWidget {
  final String transactionId;

  const TransactionDetailsAndCorrectionScreen({
    super.key,
    required this.transactionId,
  });

  @override
  ConsumerState<TransactionDetailsAndCorrectionScreen> createState() =>
      _TransactionDetailsAndCorrectionScreenState();
}

class _TransactionDetailsAndCorrectionScreenState
    extends ConsumerState<TransactionDetailsAndCorrectionScreen> {
  final _newAmountCtrl = TextEditingController();
  final _newDescCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  String? _errorMsg;

  @override
  void dispose() {
    _newAmountCtrl.dispose();
    _newDescCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _applyCorrection({
    required WalletTransaction tx,
    required bool isReversal,
  }) async {
    final household = ref.read(activeHouseholdProvider);
    if (household == null) return;

    final targetAmount = isReversal
        ? 0.0
        : (double.tryParse(_newAmountCtrl.text.replaceAll(',', '').trim()) ??
            -1.0);
    if (targetAmount < 0) {
      setState(() => _errorMsg = 'Enter a valid non-negative amount.');
      return;
    }

    try {
      await ref
          .read(householdLedgerRepositoryProvider)
          .correctOrReverseTransaction(
            householdId: household.id,
            actorUserId: ref.read(currentUserIdProvider),
            walletTransactionId: tx.id,
            newAmount: targetAmount,
            newDescription: _newDescCtrl.text.trim().isNotEmpty
                ? _newDescCtrl.text.trim()
                : tx.description,
            reason: _reasonCtrl.text,
          );
      ref.read(ledgerRevisionProvider.notifier).state++;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isReversal
                  ? 'Transaction reversed with full audit trail.'
                  : 'Transaction corrected with compensating ledger entry.',
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      setState(() => _errorMsg = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final household = ref.watch(activeHouseholdProvider);
    final transactions = ref.watch(activeHouseholdTransactionsProvider);
    final tx =
        transactions.where((t) => t.id == widget.transactionId).firstOrNull;

    if (household == null || tx == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transaction Details')),
        body: const Center(child: Text('Transaction not found')),
      );
    }

    if (_newAmountCtrl.text.isEmpty) {
      _newAmountCtrl.text = tx.amount.toStringAsFixed(0);
      _newDescCtrl.text = tx.description;
    }

    final canCorrect =
        tx.transactionType == WalletTransactionType.contribution ||
            tx.transactionType == WalletTransactionType.expense;

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction & Audit Control')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.description,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      label: 'Type',
                      value: tx.transactionType.name.toUpperCase(),
                    ),
                    _DetailRow(
                      label: 'Person Responsible',
                      value: tx.memberName,
                    ),
                    _DetailRow(
                      label: 'Category',
                      value: tx.categoryName,
                    ),
                    _DetailRow(
                      label: 'Date',
                      value: AppFormatters.formatDate(tx.transactionDate),
                    ),
                    _DetailRow(
                      label: 'Amount',
                      value: AppFormatters.formatCurrency(
                        tx.signedAmount,
                        symbol: household.currencySymbol,
                        showSign: true,
                      ),
                    ),
                    _DetailRow(
                      label: 'Balance Before',
                      value: AppFormatters.formatCurrency(
                        tx.balanceBefore,
                        symbol: household.currencySymbol,
                      ),
                    ),
                    _DetailRow(
                      label: 'Balance After',
                      value: AppFormatters.formatCurrency(
                        tx.balanceAfter,
                        symbol: household.currencySymbol,
                      ),
                    ),
                    _DetailRow(
                      label: 'Household',
                      value: household.name,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (canCorrect) ...[
              const Text(
                'Correct or Reverse Transaction (Audit Logged)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'Historical records are never silently overwritten. Corrections append a compensating adjustment entry and record the before/after state in the immutable Audit Trail.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              if (_errorMsg != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.expenseRedLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _errorMsg!,
                    style: const TextStyle(color: AppColors.expenseRed),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: _newAmountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:
                      'Corrected Amount (${household.currencySymbol})',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _newDescCtrl,
                decoration: const InputDecoration(
                  labelText: 'Updated Description',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('correction_reason_field'),
                controller: _reasonCtrl,
                decoration: const InputDecoration(
                  labelText: 'Mandatory Audit Reason (e.g. Receipt typo fix)',
                  prefixIcon: Icon(Icons.policy_outlined),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      key: const Key('apply_correction_btn'),
                      onPressed: () =>
                          _applyCorrection(tx: tx, isReversal: false),
                      child: const Text('Save Correction'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('reverse_transaction_btn'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.expenseRed,
                        side: const BorderSide(color: AppColors.expenseRed),
                      ),
                      onPressed: () async {
                        final confirmed =
                            await showDestructiveConfirmationDialog(
                          context: context,
                          title: 'Reverse Transaction?',
                          message:
                              'This will create a compensating reversal entry on the household ledger and log the reversal in the audit history.',
                          confirmLabel: 'Reverse',
                        );
                        if (confirmed) {
                          await _applyCorrection(tx: tx, isReversal: true);
                        }
                      },
                      child: const Text('Reverse Entry'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

/// 5. IMMUTABLE AUDIT LOGS SCREEN
class AuditLogsScreen extends ConsumerWidget {
  const AuditLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(activeHouseholdAuditLogsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Financial & Prediction Audit Trail')),
      body: logs.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: EmptyStateCard(
                icon: Icons.verified_user_outlined,
                title: 'No Audit Entries Yet',
                subtitle:
                    'All contributions, expenses, corrections, reversals, and manual prediction overrides are logged here.',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final log = logs[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlueLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${log.entityType.toUpperCase()} • ${log.action.toUpperCase()}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryBlueDark,
                                ),
                              ),
                            ),
                            Text(
                              AppFormatters.formatDateTime(log.createdAt),
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Reason: ${log.reason}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        if (log.previousState != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Before: ${log.previousState}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        if (log.newState != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'After: ${log.newState}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
