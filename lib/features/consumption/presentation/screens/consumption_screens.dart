import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/share_launcher.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../households/presentation/providers/household_providers.dart';
import '../../../predictions/domain/entities/prediction_entity.dart';
import '../../domain/entities/consumption_entities.dart';

/// 1. CONSUMPTION & PREDICTION OVERVIEW SCREEN (Sections 8 & 9)
class ConsumptionOverviewScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;

  const ConsumptionOverviewScreen({super.key, this.onBack});

  @override
  ConsumerState<ConsumptionOverviewScreen> createState() =>
      _ConsumptionOverviewScreenState();
}

class _ConsumptionOverviewScreenState
    extends ConsumerState<ConsumptionOverviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final household = ref.watch(activeHouseholdProvider);
    final predictions = ref.watch(activeHouseholdPredictionsProvider);
    final recurringBills = ref.watch(activeHouseholdRecurringBillsProvider);

    if (household == null) {
      return const Scaffold(body: Center(child: Text('No active household')));
    }

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
          '${ref.tr('Insights & Supplies', 'Utabiri na Mahitaji')} • ${household.name}',
        ),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/reports'),
            icon: const Icon(
              Icons.pie_chart_outline_rounded,
              size: 18,
              color: AppColors.primaryGreen,
            ),
            label: Text(
              ref.tr('Reports', 'Ripoti'),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primaryGreen,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryGreen,
          tabs: [
            Tab(text: ref.tr('All Supplies', 'Mahitaji Yote')),
            Tab(text: ref.tr('Electricity', 'Umeme (LUKU)')),
            Tab(text: ref.tr('Gas', 'Gesi')),
            Tab(text: ref.tr('Water', 'Maji')),
            Tab(text: ref.tr('Groceries', 'Mahitaji ya Jikoni')),
            Tab(text: ref.tr('Recurring Bills', 'Bili za Kila Mwezi')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SupplyPredictionList(
            predictions: predictions,
            currencySymbol: household.currencySymbol,
          ),
          _SupplyPredictionList(
            predictions: predictions
                .where((p) => p.supplyType == SupplyType.electricity)
                .toList(),
            currencySymbol: household.currencySymbol,
          ),
          _SupplyPredictionList(
            predictions: predictions
                .where((p) => p.supplyType == SupplyType.gas)
                .toList(),
            currencySymbol: household.currencySymbol,
          ),
          _SupplyPredictionList(
            predictions: predictions
                .where((p) => p.supplyType == SupplyType.water)
                .toList(),
            currencySymbol: household.currencySymbol,
          ),
          _SupplyPredictionList(
            predictions: predictions
                .where((p) => p.supplyType == SupplyType.grocery)
                .toList(),
            currencySymbol: household.currencySymbol,
          ),
          _RecurringBillsList(
            bills: recurringBills,
            currencySymbol: household.currencySymbol,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('fab_record_supply_purchase'),
        onPressed: () => context.push('/consumption/add-purchase'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.bolt_outlined),
        label: Text(ref.tr('Record Supply Purchase', 'Rekodi Manunuzi')),
      ),
    );
  }
}

class _SupplyPredictionList extends ConsumerWidget {
  final List<SupplyPrediction> predictions;
  final String currencySymbol;

  const _SupplyPredictionList({
    required this.predictions,
    required this.currencySymbol,
  });

  Color _confidenceColor(PredictionConfidenceLevel level) {
    switch (level) {
      case PredictionConfidenceLevel.high:
        return AppColors.successGreen;
      case PredictionConfidenceLevel.medium:
        return AppColors.primaryBlue;
      case PredictionConfidenceLevel.low:
        return AppColors.warningAmber;
      case PredictionConfidenceLevel.insufficientData:
        return AppColors.textSecondary;
    }
  }

  IconData _supplyIcon(SupplyType type) {
    switch (type) {
      case SupplyType.electricity:
        return Icons.bolt_rounded;
      case SupplyType.gas:
        return Icons.local_fire_department_rounded;
      case SupplyType.water:
        return Icons.water_drop_rounded;
      case SupplyType.grocery:
        return Icons.shopping_basket_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (predictions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: EmptyStateCard(
          icon: Icons.auto_graph_outlined,
          title: 'No Supplies in This Category',
          subtitle: 'Record supply purchases to start tracking replenishment cycles.',
        ),
      );
    }

    final referenceToday = DateTime.now();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: predictions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final pred = predictions[index];
        final confColor = _confidenceColor(pred.confidenceLevel);
        final daysLeft = pred.daysUntilNextPurchase(referenceToday);

        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.push('/consumption/prediction/${pred.supplyId}'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSoftGreen
                              : AppColors.primaryBlueLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _supplyIcon(pred.supplyType),
                          color: isDark
                              ? const Color(0xFF34C486)
                              : AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ref.trItem(pred.supplyName),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: primaryText,
                              ),
                            ),
                            Text(
                              '${pred.sampleCount} recorded purchase${pred.sampleCount == 1 ? '' : 's'} • ${pred.confirmedCycleCount} confirmed cycle${pred.confirmedCycleCount == 1 ? '' : 's'}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: confColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          pred.confidenceLevel.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: confColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(),
                  const SizedBox(height: 12),
                  if (pred.confidenceLevel ==
                      PredictionConfidenceLevel.insufficientData)
                    Text(
                      pred.explanation,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else ...[
                    Row(
                      children: [
                        Expanded(
                          child: _MetricTile(
                            label: 'Historical Avg Interval',
                            value:
                                '${pred.averageIntervalDays?.toStringAsFixed(1) ?? '-'} days',
                          ),
                        ),
                        Expanded(
                          child: _MetricTile(
                            label: 'Median Interval',
                            value:
                                '${pred.medianIntervalDays?.toStringAsFixed(1) ?? '-'} days',
                          ),
                        ),
                        Expanded(
                          child: _MetricTile(
                            label: 'Estimated Next Purchase',
                            value: pred.effectiveNextDate != null
                                ? AppFormatters.formatDate(
                                    pred.effectiveNextDate!,
                                  )
                                : '-',
                            highlightColor:
                                (daysLeft != null && daysLeft <= 3)
                                    ? AppColors.secondaryOrange
                                    : (isDark
                                        ? const Color(0xFF34C486)
                                        : AppColors.primaryBlueDark),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (pred.averagePurchaseAmount != null)
                          Flexible(
                            child: Text(
                              '${ref.tr('Avg Spend', 'Wastani')}: ${AppFormatters.formatCurrency(pred.averagePurchaseAmount!, symbol: currencySymbol)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                          onPressed: () {
                            final itemName = ref.trItem(pred.supplyName);
                            final dateText = pred.effectiveNextDate != null
                                ? AppFormatters.formatDate(
                                    pred.effectiveNextDate!,
                                  )
                                : ref.tr('soon', 'hivi karibuni');
                            final msg = ref.tr(
                              '🏠 *NyumbaSmart Replenishment Alert*\n'
                              '⚠️ *$itemName* is expected to finish around *$dateText*${daysLeft != null ? ' (~$daysLeft days left)' : ''}.\n'
                              '${pred.averagePurchaseAmount != null ? '💰 Typical purchase cost: ${AppFormatters.formatCurrency(pred.averagePurchaseAmount!, symbol: currencySymbol)}\n' : ''}'
                              'Please plan or contribute so we can restock on time.',
                              '🏠 *Tahadhari ya Mahitaji NyumbaSmart*\n'
                              '⚠️ *$itemName* inatarajiwa kuisha mnamo *$dateText*${daysLeft != null ? ' (~siku $daysLeft zimesalia)' : ''}.\n'
                              '${pred.averagePurchaseAmount != null ? '💰 Wastani wa gharama: ${AppFormatters.formatCurrency(pred.averagePurchaseAmount!, symbol: currencySymbol)}\n' : ''}'
                              'Tafadhali tupange au kuchangia mapema.',
                            );
                            ShareLauncher.showShareAlertSheet(
                              context: context,
                              title: ref.tr(
                                'Send $itemName Alert (WhatsApp / SMS)',
                                'Tuma Tahadhari ya $itemName (WhatsApp / SMS)',
                              ),
                              message: msg,
                            );
                          },
                          icon: const Icon(
                            Icons.send_rounded,
                            size: 14,
                            color: AppColors.primaryGreen,
                          ),
                          label: Text(
                            ref.tr(
                              'WhatsApp / SMS',
                              'WhatsApp / SMS',
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? highlightColor;

  const _MetricTile({
    required this.label,
    required this.value,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultValColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color:
                isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: highlightColor ?? defaultValColor,
          ),
        ),
      ],
    );
  }
}

class _RecurringBillsList extends StatelessWidget {
  final List<RecurringBill> bills;
  final String currencySymbol;

  const _RecurringBillsList({
    required this.bills,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final referenceToday = DateTime.now();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Scheduled Recurring Bills (Distinct from consumption predictions)',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => context.push('/consumption/add-bill'),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Bill'),
              ),
            ],
          ),
        ),
        Expanded(
          child: bills.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: EmptyStateCard(
                    icon: Icons.event_repeat_outlined,
                    title: 'No Recurring Bills Configured',
                    subtitle:
                        'Add Internet, Rent, or Television subscriptions to receive scheduled due-date reminders.',
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: bills.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final bill = bills[index];
                    final daysUntil = bill.daysUntilDue(referenceToday);
                    return Card(
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryOrangeLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.event_repeat_rounded,
                            color: AppColors.secondaryOrange,
                          ),
                        ),
                        title: Text(
                          bill.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          '${bill.frequency.name.toUpperCase()} • Next due: ${AppFormatters.formatDate(bill.nextDueDate)} (${daysUntil >= 0 ? 'in $daysUntil days' : 'overdue'})',
                        ),
                        trailing: Text(
                          AppFormatters.formatCurrency(
                            bill.expectedAmount,
                            symbol: currencySymbol,
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// 2. RECORD SUPPLY PURCHASE SCREEN (Electricity LUKU, Gas, Water, Groceries)
class RecordSupplyPurchaseScreen extends ConsumerStatefulWidget {
  const RecordSupplyPurchaseScreen({super.key});

  @override
  ConsumerState<RecordSupplyPurchaseScreen> createState() =>
      _RecordSupplyPurchaseScreenState();
}

class _RecordSupplyPurchaseScreenState
    extends ConsumerState<RecordSupplyPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _remainingUnitsCtrl = TextEditingController();
  final _remainingPctCtrl = TextEditingController();
  final _cylinderWeightCtrl = TextEditingController(text: '15');
  final _estimatedDaysCtrl = TextEditingController();
  final _memberNameCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String? _selectedSupplyId;
  PreviousExhaustedState _exhaustedState =
      PreviousExhaustedState.yesCompletelyFinished;
  DateTime _purchaseDate = DateTime.now();
  bool _deductFromWallet = true;
  String? _errorMsg;

  Future<void> _pickPurchaseDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate.isAfter(now) ? now : _purchaseDate,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(now.year + 1, 12, 31),
      helpText: 'Select When the Supply Was Actually Bought',
    );
    if (picked != null) {
      setState(() => _purchaseDate = picked);
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _quantityCtrl.dispose();
    _remainingUnitsCtrl.dispose();
    _remainingPctCtrl.dispose();
    _cylinderWeightCtrl.dispose();
    _estimatedDaysCtrl.dispose();
    _memberNameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final household = ref.read(activeHouseholdProvider);
    final supplies = ref.read(activeHouseholdSuppliesProvider);
    if (household == null || supplies.isEmpty) return;

    final supplyId = _selectedSupplyId ?? supplies.first.id;
    final supply = supplies.firstWhere((s) => s.id == supplyId);
    final amount =
        double.tryParse(_amountCtrl.text.replaceAll(',', '').trim()) ?? 0.0;
    final quantity =
        double.tryParse(_quantityCtrl.text.replaceAll(',', '').trim());
    final remainingUnits =
        double.tryParse(_remainingUnitsCtrl.text.replaceAll(',', '').trim());
    final remainingPct =
        double.tryParse(_remainingPctCtrl.text.replaceAll(',', '').trim());
    final cylinderWeight = supply.supplyType == SupplyType.gas
        ? double.tryParse(_cylinderWeightCtrl.text.trim())
        : null;
    final estimatedDays = int.tryParse(_estimatedDaysCtrl.text.trim());

    try {
      final repo = ref.read(householdLedgerRepositoryProvider);
      final userId = ref.read(currentUserIdProvider);
      String? resolvedMemberId;
      if (_deductFromWallet) {
        final member = await repo.resolveOrCreateMemberByName(
          householdId: household.id,
          actorUserId: userId,
          writtenName: _memberNameCtrl.text,
        );
        resolvedMemberId = member.id;
      }

      await repo.recordSupplyPurchase(
        householdId: household.id,
        actorUserId: userId,
        supplyId: supply.id,
        purchaseDate: _purchaseDate,
        amountPaid: amount,
        quantity: quantity ?? cylinderWeight,
        previousExhaustedState: _exhaustedState,
        remainingUnits: remainingUnits,
        remainingPercentage: remainingPct,
        cylinderWeightKg: cylinderWeight,
        userEstimatedDurationDays: estimatedDays,
        notes: _notesCtrl.text,
        alsoRecordWalletExpense: _deductFromWallet,
        paidByMemberId: resolvedMemberId,
      );
      ref.read(ledgerRevisionProvider.notifier).state++;
      if (_deductFromWallet) {
        final updatedWallet = repo.getWallet(
          householdId: household.id,
          actorUserId: userId,
        );
        if (updatedWallet.availableBalance <= household.lowBalanceThreshold) {
          ShareLauncher.checkAndAutoSendHouseholdAlerts(
            householdId: household.id,
            householdName: household.name,
            currencySymbol: household.currencySymbol,
            availableBalance: updatedWallet.availableBalance,
            lowBalanceThreshold: household.lowBalanceThreshold,
            forceSendNow: true,
          );
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.successGreen,
            content: Text(
              '${supply.name} purchase recorded and prediction updated!',
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
    final supplies = ref.watch(activeHouseholdSuppliesProvider);
    final members = ref.watch(activeHouseholdMembersProvider);

    if (household == null || supplies.isEmpty) {
      return const Scaffold(body: Center(child: Text('No supplies configured')));
    }

    final selectedSupply = supplies.firstWhere(
      (s) => s.id == (_selectedSupplyId ?? supplies.first.id),
      orElse: () => supplies.first,
    );

    final isElectricity = selectedSupply.supplyType == SupplyType.electricity;
    final isGas = selectedSupply.supplyType == SupplyType.gas;

    return Scaffold(
      appBar: AppBar(title: const Text('Record Supply Replenishment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                const SizedBox(height: 16),
              ],
              DropdownButtonFormField<String>(
                key: const Key('supply_selector_dropdown'),
                value: selectedSupply.id,
                decoration: const InputDecoration(
                  labelText: 'Select Household Supply / Product',
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                ),
                items: supplies
                    .map(
                      (s) => DropdownMenuItem(
                        value: s.id,
                        child: Text(
                          '${ref.trItem(s.name)} (${s.defaultUnit})',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedSupplyId = val),
              ),
              const SizedBox(height: 16),
              // Actual Purchase Date Calendar Picker (for accurate interval estimation even when recorded later)
              InkWell(
                key: const Key('supply_purchase_date_picker'),
                onTap: _pickPurchaseDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: isElectricity
                        ? 'When Was Electricity Actually Bought?'
                        : 'Actual Purchase Date (When Was It Bought?)',
                    helperText:
                        'If bought earlier (e.g. yesterday) and recorded today, pick the actual purchase date for accurate prediction.',
                    helperMaxLines: 2,
                    prefixIcon: const Icon(Icons.calendar_month_outlined),
                    suffixIcon: const Icon(Icons.edit_calendar_outlined),
                  ),
                  child: Text(
                    AppFormatters.formatDate(_purchaseDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
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
                    label: const Text('Bought Today', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      setState(() => _purchaseDate = DateTime.now());
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
                        () => _purchaseDate =
                            DateTime.now().subtract(const Duration(days: 1)),
                      );
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.history_outlined, size: 15),
                    label: const Text(
                      '2 Days Ago',
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: () {
                      setState(
                        () => _purchaseDate =
                            DateTime.now().subtract(const Duration(days: 2)),
                      );
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.calendar_month_outlined, size: 15),
                    label: const Text(
                      'Choose on Calendar...',
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: _pickPurchaseDate,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('supply_amount_paid_field'),
                controller: _amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount Paid (${household.currencySymbol})',
                  hintText: isElectricity ? 'e.g. 30000' : 'e.g. 55000',
                  prefixIcon: const Icon(Icons.payments_outlined),
                ),
                validator: (val) {
                  final parsed =
                      double.tryParse((val ?? '').replaceAll(',', '').trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid amount paid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (isGas) ...[
                TextFormField(
                  controller: _cylinderWeightCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Gas Cylinder Weight (kg - e.g. 6kg, 15kg, 38kg)',
                    prefixIcon: Icon(Icons.local_fire_department_outlined),
                  ),
                ),
                const SizedBox(height: 16),
              ] else ...[
                TextFormField(
                  key: const Key('supply_quantity_field'),
                  controller: _quantityCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: isElectricity
                        ? 'Electricity Units Purchased (kWh - Optional)'
                        : 'Quantity (${selectedSupply.defaultUnit} - Optional)',
                    hintText: isElectricity ? 'e.g. 84.5 kWh' : 'e.g. 10',
                    prefixIcon: const Icon(Icons.scale_outlined),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                key: const Key('supply_estimated_days_field'),
                controller: _estimatedDaysCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: ref.tr(
                    'Expected Duration in Days (Optional — for 1st-time purchase)',
                    'Muda Unaotarajiwa kwa Siku (Hiari — kwa ununuzi wa kwanza)',
                  ),
                  hintText: ref.tr(
                    'e.g. 10 days (used until a 2nd purchase is recorded)',
                    'mf. siku 10 (hutumika hadi ununuzi wa pili)',
                  ),
                  prefixIcon: const Icon(Icons.timelapse_outlined),
                ),
              ),
              const SizedBox(height: 16),
              // Section 8.1 Question: "Was the previous electricity/supply finished?"
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isElectricity
                            ? 'Was the previous electricity finished?'
                            : isGas
                                ? 'Was the previous gas cylinder completely empty?'
                                : 'Was the previous ${selectedSupply.name} completely finished?',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...PreviousExhaustedState.values.map(
                        (stateOption) => RadioListTile<PreviousExhaustedState>(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          value: stateOption,
                          groupValue: _exhaustedState,
                          title: Text(stateOption.label),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _exhaustedState = val);
                            }
                          },
                        ),
                      ),
                      if (_exhaustedState ==
                          PreviousExhaustedState.noSomeRemained) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _remainingUnitsCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText:
                                      'Remaining (${selectedSupply.defaultUnit})',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _remainingPctCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Or Remaining (%)',
                                  hintText: 'e.g. 20',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _deductFromWallet,
                title: const Text(
                  'Also deduct this purchase from Household Wallet',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                subtitle: const Text(
                  'Automatically creates a linked expense transaction',
                  style: TextStyle(fontSize: 12),
                ),
                onChanged: (val) => setState(() => _deductFromWallet = val),
              ),
              if (_deductFromWallet) ...[
                const SizedBox(height: 8),
                TextFormField(
                  key: const Key('supply_member_name_field'),
                  controller: _memberNameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Purchased By Member (Write Member Name)',
                    hintText: 'Type member name (e.g. Dida, Asha, Juma)',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (val) =>
                      _deductFromWallet && (val == null || val.trim().isEmpty)
                          ? 'Please write the member name'
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
              ],
              const SizedBox(height: 24),
              ElevatedButton.icon(
                key: const Key('save_supply_purchase_btn'),
                onPressed: _submit,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Save Purchase & Update Prediction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 3. PREDICTION DETAILS & MANUAL OUTCOME LEARNING SCREEN (Section 9.1 & 9.2)
class PredictionDetailsAndOverrideScreen extends ConsumerStatefulWidget {
  final String supplyId;

  const PredictionDetailsAndOverrideScreen({
    super.key,
    required this.supplyId,
  });

  @override
  ConsumerState<PredictionDetailsAndOverrideScreen> createState() =>
      _PredictionDetailsAndOverrideScreenState();
}

class _PredictionDetailsAndOverrideScreenState
    extends ConsumerState<PredictionDetailsAndOverrideScreen> {
  final _reasonCtrl = TextEditingController();

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _recordActualDepletion(SupplyPrediction pred) async {
    final household = ref.read(activeHouseholdProvider);
    if (household == null) return;

    final initialDate =
        pred.effectiveNextDate ?? DateTime.now().add(const Duration(days: 7));
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: pred.lastPurchaseDate?.add(const Duration(days: 1)) ??
          DateTime(2024, 1, 1),
      lastDate: DateTime(2030),
      helpText: 'Select Actual Date Supply Finished',
    );
    if (picked == null) return;

    try {
      await ref
          .read(householdLedgerRepositoryProvider)
          .recordActualDepletionOutcome(
            householdId: household.id,
            actorUserId: ref.read(currentUserIdProvider),
            supplyId: widget.supplyId,
            actualDepletionDate: picked,
            reason: _reasonCtrl.text.trim().isNotEmpty
                ? _reasonCtrl.text.trim()
                : 'Administrator recorded actual supply depletion date',
          );
      ref.read(ledgerRevisionProvider.notifier).state++;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.successGreen,
            content: Text(
              'Learned from actual depletion date (${AppFormatters.formatDate(picked)}). Prediction engine updated!',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final household = ref.watch(activeHouseholdProvider);
    final predictions = ref.watch(activeHouseholdPredictionsProvider);
    final allRecords = ref.watch(activeHouseholdConsumptionRecordsProvider);

    final pred =
        predictions.where((p) => p.supplyId == widget.supplyId).firstOrNull;
    final records =
        allRecords.where((r) => r.supplyId == widget.supplyId).toList();

    if (household == null || pred == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Prediction Details')),
        body: const Center(child: Text('Supply prediction not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${ref.trItem(pred.supplyName)} ${ref.tr('Prediction', 'Utabiri')}',
        ),
        actions: [
          IconButton(
            tooltip: ref.tr(
              'Send Alert via WhatsApp / SMS',
              'Tuma Tahadhari kwa WhatsApp / SMS',
            ),
            icon: const Icon(
              Icons.send_rounded,
              color: AppColors.primaryGreen,
            ),
            onPressed: () {
              final itemName = ref.trItem(pred.supplyName);
              final dateText = pred.effectiveNextDate != null
                  ? AppFormatters.formatDate(pred.effectiveNextDate!)
                  : ref.tr('soon', 'hivi karibuni');
              final msg = ref.tr(
                '🏠 *NyumbaSmart Replenishment Alert (${ref.trItem(household.name)})*\n'
                '⚠️ *$itemName* is expected to finish around *$dateText*.\n'
                '📊 Historical cycle: ~${pred.averageIntervalDays?.toStringAsFixed(0) ?? '-'} days\n'
                '${pred.averagePurchaseAmount != null ? '💰 Typical cost: ${AppFormatters.formatCurrency(pred.averagePurchaseAmount!, symbol: household.currencySymbol)}\n' : ''}'
                'Please plan or contribute so we can restock on time.',
                '🏠 *Tahadhari ya Mahitaji NyumbaSmart (${ref.trItem(household.name)})*\n'
                '⚠️ *$itemName* inatarajiwa kuisha mnamo *$dateText*.\n'
                '📊 Mzunguko wa kawaida: ~siku ${pred.averageIntervalDays?.toStringAsFixed(0) ?? '-'}\n'
                '${pred.averagePurchaseAmount != null ? '💰 Wastani wa gharama: ${AppFormatters.formatCurrency(pred.averagePurchaseAmount!, symbol: household.currencySymbol)}\n' : ''}'
                'Tafadhali tupange au kuchangia mapema.',
              );
              ShareLauncher.showShareAlertSheet(
                context: context,
                title: ref.tr(
                  'Send $itemName Alert (WhatsApp / SMS)',
                  'Tuma Tahadhari ya $itemName (WhatsApp / SMS)',
                ),
                message: msg,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          ref.trItem(pred.supplyName),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Chip(
                        label: Text(
                          '${pred.confidenceLevel.label} (${pred.confidenceScore.toStringAsFixed(0)}%)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pred.explanation,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  _StatLine(
                    label: '1. Historical Average Interval',
                    value: pred.averageIntervalDays != null
                        ? '${pred.averageIntervalDays!.toStringAsFixed(1)} days'
                        : 'Insufficient data',
                  ),
                  _StatLine(
                    label: '2. Median Interval (Outlier-Resistant)',
                    value: pred.medianIntervalDays != null
                        ? '${pred.medianIntervalDays!.toStringAsFixed(1)} days'
                        : 'Insufficient data',
                  ),
                  _StatLine(
                    label: '3. Recency-Weighted Interval',
                    value: pred.weightedIntervalDays != null
                        ? '${pred.weightedIntervalDays!.toStringAsFixed(1)} days'
                        : 'Insufficient data',
                  ),
                  _StatLine(
                    label: '4. Interval Variability (Std Dev)',
                    value: pred.intervalStdDevDays != null
                        ? '±${pred.intervalStdDevDays!.toStringAsFixed(1)} days'
                        : '-',
                  ),
                  _StatLine(
                    label: '5. Estimated Next Replenishment Date',
                    value: pred.estimatedNextReplenishmentDate != null
                        ? AppFormatters.formatDate(
                            pred.estimatedNextReplenishmentDate!,
                          )
                        : 'Need more purchases',
                  ),
                  _StatLine(
                    label: '6. Actual Confirmed Depletion Date',
                    value: pred.actualConfirmedDepletionDate != null
                        ? AppFormatters.formatDate(
                            pred.actualConfirmedDepletionDate!,
                          )
                        : 'Not yet confirmed for latest cycle',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Manual Correction & Learning Card (Section 9.2)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Manual Outcome Correction (Train Prediction Engine)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Did this supply finish earlier or later than predicted? Record the actual date it ran out so future predictions learn from the real outcome.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _reasonCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Optional Note (e.g. Guests visited this month)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    key: const Key('record_actual_depletion_btn'),
                    onPressed: pred.sampleCount > 0
                        ? () => _recordActualDepletion(pred)
                        : null,
                    icon: const Icon(Icons.event_available_outlined),
                    label: const Text('Record Actual Depletion Date'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Historical Purchase Records'),
          ...records.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  title: Text(
                    '${AppFormatters.formatDate(r.purchaseDate)} • ${AppFormatters.formatCurrency(r.amountPaid, symbol: household.currencySymbol)}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    'Quantity: ${r.quantity != null ? '${r.quantity} ${r.unit}' : 'Monetary only'}\nPrevious state: ${r.previousExhaustedState.label}${r.actualDepletionDate != null ? '\nConfirmed finished on: ${AppFormatters.formatDate(r.actualDepletionDate!)}' : ''}',
                  ),
                  isThreeLine: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  final String label;
  final String value;

  const _StatLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// 4. ADD RECURRING BILL SCREEN (Section 8.5)
class AddRecurringBillScreen extends ConsumerStatefulWidget {
  const AddRecurringBillScreen({super.key});

  @override
  ConsumerState<AddRecurringBillScreen> createState() =>
      _AddRecurringBillScreenState();
}

class _AddRecurringBillScreenState
    extends ConsumerState<AddRecurringBillScreen> {
  final _titleCtrl = TextEditingController();
  final _providerCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  BillingFrequency _frequency = BillingFrequency.monthly;
  DateTime _nextDueDate = DateTime.now().add(const Duration(days: 14));

  @override
  void dispose() {
    _titleCtrl.dispose();
    _providerCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final household = ref.read(activeHouseholdProvider);
    final categories = ref.read(activeHouseholdCategoriesProvider);
    if (household == null || categories.isEmpty) return;
    final amount =
        double.tryParse(_amountCtrl.text.replaceAll(',', '').trim()) ?? 0;
    if (_titleCtrl.text.trim().length < 2 || amount <= 0) return;

    await ref.read(householdLedgerRepositoryProvider).upsertRecurringBill(
          householdId: household.id,
          actorUserId: ref.read(currentUserIdProvider),
          categoryId: categories.first.id,
          title: _titleCtrl.text,
          providerName: _providerCtrl.text,
          expectedAmount: amount,
          frequency: _frequency,
          nextDueDate: _nextDueDate,
        );
    ref.read(ledgerRevisionProvider.notifier).state++;
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final household = ref.watch(activeHouseholdProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Scheduled Recurring Bill')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Bill Title (e.g. Fiber Internet, House Rent, Azam TV)',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _providerCtrl,
              decoration: const InputDecoration(
                labelText: 'Provider / Recipient Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText:
                    'Expected Amount (${household?.currencySymbol ?? 'TSh'})',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<BillingFrequency>(
              value: _frequency,
              decoration: const InputDecoration(labelText: 'Billing Frequency'),
              items: BillingFrequency.values
                  .map(
                    (f) => DropdownMenuItem(
                      value: f,
                      child: Text(f.name.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _frequency = v);
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Next Expected Due Date'),
              subtitle: Text(AppFormatters.formatDate(_nextDueDate)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _nextDueDate,
                  firstDate: DateTime(2026),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => _nextDueDate = picked);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Save Recurring Bill'),
            ),
          ],
        ),
      ),
    );
  }
}
