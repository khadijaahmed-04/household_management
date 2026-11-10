import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/share_launcher.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../households/presentation/providers/household_providers.dart';
import '../../../predictions/domain/entities/prediction_entity.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  static const _chartColors = [
    AppColors.primaryGreen,
    AppColors.info,
    AppColors.warning,
    AppColors.error,
    Color(0xFF2E9E6F),
    Color(0xFF0D9488),
    Color(0xFF8B5CF6),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final household = ref.watch(activeHouseholdProvider);
    final summary = ref.watch(activeHouseholdMonthlySummaryProvider);
    final budgets = ref.watch(activeHouseholdBudgetsProvider);
    final predictions = ref.watch(activeHouseholdPredictionsProvider);

    if (household == null || summary == null) {
      return const Scaffold(body: Center(child: Text('No active household')));
    }

    final categoryEntries = summary.expensesByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final memberEntries = summary.contributionsByMember.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    void shareMonthlyReport() {
      final symbol = household.currencySymbol;
      final dueSupplies = predictions
          .where((p) {
            final days = p.daysUntilNextPurchase(DateTime(2026, 11, 9));
            return days != null && days <= 5;
          })
          .map((p) {
            final days = p.daysUntilNextPurchase(DateTime(2026, 11, 9)) ?? 0;
            return '  • ${ref.trItem(p.supplyName)}: ${days <= 0 ? ref.tr('Need refill now', 'Imekwisha') : ref.tr('~$days days left', '~siku $days zimesalia')}';
          })
          .join('\n');

      final contribLines = memberEntries.isEmpty
          ? '  • ${ref.tr('No contributions yet', 'Hakuna michango bado')}'
          : memberEntries
              .map(
                (e) =>
                    '  • ${e.key}: ${AppFormatters.formatCurrency(e.value, symbol: symbol)}',
              )
              .join('\n');

      final message = ref.tr(
        '🏠 *NyumbaSmart Monthly Summary — ${ref.trItem(household.name)}*\n'
        '📅 ${AppFormatters.formatMonthYear(summary.month)}\n\n'
        '💰 *Current Shared Balance*: ${AppFormatters.formatCurrency(summary.remainingBalance, symbol: symbol)}\n'
        '📥 *Total Contributions*: ${AppFormatters.formatCurrency(summary.totalContributions, symbol: symbol)}\n'
        '📤 *Total Expenses*: ${AppFormatters.formatCurrency(summary.totalExpenses, symbol: symbol)}\n\n'
        '👥 *Contributions by Member*:\n$contribLines\n'
        '${dueSupplies.isNotEmpty ? '\n⚠️ *Supplies Nearly Finishing*:\n$dueSupplies\n' : ''}',
        '🏠 *Muhtasari wa Mwezi wa NyumbaSmart — ${ref.trItem(household.name)}*\n'
        '📅 ${AppFormatters.formatMonthYear(summary.month)}\n\n'
        '💰 *Salio la Pamoja*: ${AppFormatters.formatCurrency(summary.remainingBalance, symbol: symbol)}\n'
        '📥 *Jumla ya Michango*: ${AppFormatters.formatCurrency(summary.totalContributions, symbol: symbol)}\n'
        '📤 *Jumla ya Matumizi*: ${AppFormatters.formatCurrency(summary.totalExpenses, symbol: symbol)}\n\n'
        '👥 *Michango kwa Kila Mwanafamilia*:\n$contribLines\n'
        '${dueSupplies.isNotEmpty ? '\n⚠️ *Mahitaji Yanayokaribia Kuisha*:\n$dueSupplies\n' : ''}',
      );

      ShareLauncher.showShareAlertSheet(
        context: context,
        title: ref.tr(
          'Share Monthly Report & Alerts (WhatsApp / SMS)',
          'Tuma Ripoti na Tahadhari (WhatsApp / SMS)',
        ),
        message: message,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${ref.tr('Reports & Analytics', 'Ripoti na Takwimu')} - ${household.name}',
        ),
        actions: [
          IconButton(
            tooltip: ref.tr(
              'Share via WhatsApp / SMS',
              'Tuma kwa WhatsApp / SMS',
            ),
            onPressed: shareMonthlyReport,
            icon: const Icon(
              Icons.send_rounded,
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Monthly Financial Overview Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${ref.tr('Monthly Summary', 'Muhtasari wa Mwezi')} (${AppFormatters.formatMonthYear(summary.month)})',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: shareMonthlyReport,
                        icon: const Icon(
                          Icons.send_rounded,
                          size: 16,
                          color: AppColors.primaryGreen,
                        ),
                        label: Text(
                          ref.tr('WhatsApp / SMS', 'WhatsApp / SMS'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _ReportMetricBox(
                          label: ref.tr(
                            'Total Contributions',
                            'Jumla ya Michango',
                          ),
                          value: AppFormatters.formatCurrency(
                            summary.totalContributions,
                            symbol: household.currencySymbol,
                          ),
                          color: AppColors.successGreen,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ReportMetricBox(
                          label: ref.tr('Total Expenses', 'Jumla ya Matumizi'),
                          value: AppFormatters.formatCurrency(
                            summary.totalExpenses,
                            symbol: household.currencySymbol,
                          ),
                          color: AppColors.secondaryOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ReportMetricBox(
                          label: ref.tr('Remaining Balance', 'Salio Lililobaki'),
                          value: AppFormatters.formatCurrency(
                            summary.remainingBalance,
                            symbol: household.currencySymbol,
                          ),
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ReportMetricBox(
                          label: ref.tr(
                            'Highest Expense Category',
                            'Kundi Lenye Matumizi Makubwa',
                          ),
                          value: summary.highestExpenseCategory ?? 'None',
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 2. Category Breakdown Chart (fl_chart PieChart)
          SectionHeader(
            title: ref.tr(
              'Expense Breakdown by Category',
              'Mchanganuo wa Matumizi kwa Kundi',
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: categoryEntries.isEmpty
                  ? const Text(
                      'No expenses recorded for this month yet.',
                      style: TextStyle(color: AppColors.textSecondary),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 190,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 3,
                              centerSpaceRadius: 42,
                              sections: List.generate(
                                categoryEntries.length,
                                (i) {
                                  final entry = categoryEntries[i];
                                  final pct = summary.totalExpenses > 0
                                      ? (entry.value / summary.totalExpenses) *
                                          100
                                      : 0.0;
                                  return PieChartSectionData(
                                    color:
                                        _chartColors[i % _chartColors.length],
                                    value: entry.value,
                                    title: '${pct.toStringAsFixed(0)}%',
                                    radius: 50,
                                    titleStyle: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(categoryEntries.length, (i) {
                          final entry = categoryEntries[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: _chartColors[
                                            i % _chartColors.length],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  AppFormatters.formatCurrency(
                                    entry.value,
                                    symbol: household.currencySymbol,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Individual Member Contributions Breakdown (Unequal Contributions)
          const SectionHeader(title: 'Member Contribution Breakdown'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: memberEntries.isEmpty
                  ? const Text('No contributions recorded this month.')
                  : Column(
                      children: memberEntries.map((entry) {
                        final sharePct = summary.totalContributions > 0
                            ? (entry.value / summary.totalContributions) * 100
                            : 0.0;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '${AppFormatters.formatCurrency(entry.value, symbol: household.currencySymbol)} (${sharePct.toStringAsFixed(1)}%)',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.successGreen,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              LinearProgressIndicator(
                                value: (sharePct / 100.0).clamp(0.0, 1.0),
                                backgroundColor: AppColors.background,
                                color: AppColors.successGreen,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // 4. Monthly Budget vs Actual Performance (Section 11)
          const SectionHeader(title: 'Monthly Category Budgets'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: budgets.isEmpty
                  ? const Text('No monthly budgets configured.')
                  : Column(
                      children: budgets.map((status) {
                        final pct =
                            (status.percentageUsed / 100.0).clamp(0.0, 1.0);
                        final barColor = status.isExceeded
                            ? AppColors.expenseRed
                            : status.isApproachingLimit
                                ? AppColors.secondaryOrange
                                : AppColors.primaryBlue;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    status.budget.categoryName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '${AppFormatters.formatCurrency(status.amountSpent, symbol: household.currencySymbol)} / ${AppFormatters.formatCurrency(status.budget.budgetAmount, symbol: household.currencySymbol)} (${status.percentageUsed.toStringAsFixed(0)}%)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: barColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              LinearProgressIndicator(
                                value: pct,
                                backgroundColor: AppColors.background,
                                color: barColor,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Remaining budget: ${AppFormatters.formatCurrency(status.remainingBudget, symbol: household.currencySymbol)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // 5. Consumption Trends & Prediction Accuracy Report
          const SectionHeader(title: 'Consumption & Prediction Accuracy'),
          ...predictions
              .where(
                (p) =>
                    p.confidenceLevel !=
                    PredictionConfidenceLevel.insufficientData,
              )
              .map(
                (pred) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        ref.trItem(pred.supplyName),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        'Avg interval: ${pred.averageIntervalDays?.toStringAsFixed(1)} days • Trend: ${pred.trendDirection.toUpperCase()}\nConfidence: ${pred.confidenceLevel.label} (${pred.confidenceScore.toStringAsFixed(0)}%)',
                      ),
                      trailing: Text(
                        pred.effectiveNextDate != null
                            ? AppFormatters.formatDate(pred.effectiveNextDate!)
                            : '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _ReportMetricBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ReportMetricBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
