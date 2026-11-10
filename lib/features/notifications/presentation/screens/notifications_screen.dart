import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/share_launcher.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../households/presentation/providers/household_providers.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Color _severityColor(NotificationSeverity severity) {
    switch (severity) {
      case NotificationSeverity.critical:
        return AppColors.error;
      case NotificationSeverity.warning:
        return AppColors.warning;
      case NotificationSeverity.info:
        return AppColors.info;
    }
  }

  IconData _notificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.electricityReplenishment:
        return Icons.bolt_rounded;
      case NotificationType.gasReplenishment:
        return Icons.local_fire_department_rounded;
      case NotificationType.waterReplenishment:
        return Icons.water_drop_rounded;
      case NotificationType.groceryReplenishment:
        return Icons.shopping_basket_rounded;
      case NotificationType.recurringBillDue:
        return Icons.event_repeat_rounded;
      case NotificationType.lowWalletBalance:
        return Icons.account_balance_wallet_rounded;
      case NotificationType.budgetWarning:
      case NotificationType.budgetExceeded:
        return Icons.pie_chart_outline_rounded;
      case NotificationType.transactionCorrected:
        return Icons.policy_outlined;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final household = ref.watch(activeHouseholdProvider);
    final wallet = ref.watch(activeHouseholdWalletProvider);
    final notifications = ref.watch(activeHouseholdNotificationsProvider);

    if (household == null) {
      return const Scaffold(body: Center(child: Text('No active household')));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          '${ref.tr('Smart Alerts', 'Tahadhari')} • ${household.name}',
        ),
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              tooltip: ref.tr(
                'Send All Alerts via WhatsApp / SMS',
                'Tuma Tahadhari Zote kwa WhatsApp / SMS',
              ),
              icon: const Icon(
                Icons.share_outlined,
                color: AppColors.primaryGreen,
              ),
              onPressed: () {
                final buffer = StringBuffer()
                  ..writeln('🏠 *NyumbaSmart Alert — ${household.name}*')
                  ..writeln(
                    '💰 ${ref.tr('Available Balance', 'Salio Linalopatikana')}: ${AppFormatters.formatCurrency(wallet?.availableBalance ?? 0, symbol: household.currencySymbol)}',
                  )
                  ..writeln('');
                for (final n in notifications) {
                  buffer.writeln('⚠️ *${n.title}*: ${n.body}');
                }
                ShareLauncher.showShareAlertSheet(
                  context: context,
                  title: ref.tr(
                    'Send Household Alerts (WhatsApp / SMS)',
                    'Tuma Tahadhari za Nyumbani (WhatsApp / SMS)',
                  ),
                  message: buffer.toString().trim(),
                );
              },
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: EmptyStateCard(
                icon: Icons.notifications_none_rounded,
                title: ref.tr('All Caught Up!', 'Hakuna Tahadhari Mpya!'),
                subtitle: ref.tr(
                  'You have no active replenishment, bill, budget, or low-balance alerts.',
                  'Hakuna tahadhari za manunuzi, bili, au salio dogo kwa sasa.',
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final n = notifications[index];
                final color = _severityColor(n.severity);

                return AppSurfaceCard(
                  borderColor: n.isRead ? AppColors.border : color,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _notificationIcon(n.type),
                              color: color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              n.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: n.isRead
                                    ? FontWeight.w600
                                    : FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            AppFormatters.formatDate(n.createdAt),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        n.body,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              side: const BorderSide(
                                color: AppColors.softGreenBorder,
                              ),
                              backgroundColor: AppColors.softGreen,
                            ),
                            onPressed: () {
                              final alertMsg =
                                  '🏠 *NyumbaSmart (${household.name})*\n'
                                  '⚠️ *${n.title}*\n'
                                  '${n.body}\n'
                                  '💰 ${ref.tr('Shared Balance', 'Salio la Nyumbani')}: ${AppFormatters.formatCurrency(wallet?.availableBalance ?? 0, symbol: household.currencySymbol)}';
                              ShareLauncher.showShareAlertSheet(
                                context: context,
                                title: ref.tr(
                                  'Send Alert via WhatsApp / SMS',
                                  'Tuma Tahadhari kwa WhatsApp / SMS',
                                ),
                                message: alertMsg,
                              );
                            },
                            icon: const Icon(
                              Icons.send_rounded,
                              size: 14,
                              color: AppColors.primaryGreen,
                            ),
                            label: Text(
                              ref.tr(
                                'Send WhatsApp / SMS',
                                'Tuma WhatsApp / SMS',
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!n.isRead)
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .read(householdLedgerRepositoryProvider)
                                        .markNotificationRead(
                                          householdId: household.id,
                                          actorUserId:
                                              ref.read(currentUserIdProvider),
                                          notificationId: n.id,
                                        );
                                    ref
                                        .read(ledgerRevisionProvider.notifier)
                                        .state++;
                                  },
                                  child: Text(
                                    ref.tr('Mark Read', 'imesomwa'),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(householdLedgerRepositoryProvider)
                                      .dismissNotification(
                                        householdId: household.id,
                                        actorUserId:
                                            ref.read(currentUserIdProvider),
                                        notificationId: n.id,
                                      );
                                  ref
                                      .read(ledgerRevisionProvider.notifier)
                                      .state++;
                                },
                                child: Text(
                                  ref.tr('Dismiss', 'Ondoa'),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
