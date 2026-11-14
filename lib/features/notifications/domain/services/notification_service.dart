import 'package:uuid/uuid.dart';
import '../../../../core/utils/formatters.dart';
import '../../../budgets/domain/entities/budget_entity.dart';
import '../../../consumption/domain/entities/consumption_entities.dart';
import '../../../households/domain/entities/household.dart';
import '../../../predictions/domain/entities/prediction_entity.dart';
import '../../../wallet/domain/entities/wallet_entities.dart';
import '../entities/notification_entity.dart';

/// Smart Notification & Alert Generator Service.
///
/// Generates proactive, deduplicated household notifications based on:
/// 1. Supply predictions (Electricity LUKU, Gas, Water, Groceries).
/// 2. Recurring scheduled bills (Internet, Rent, TV).
/// 3. Low household wallet balance.
/// 4. Monthly category budget warnings & exceeded thresholds.
class NotificationAlertEvaluator {
  final _uuid = const Uuid();

  const NotificationAlertEvaluator();

  List<HouseholdNotification> evaluateAlerts({
    required Household household,
    required HouseholdWallet wallet,
    required List<SupplyPrediction> predictions,
    required List<RecurringBill> recurringBills,
    required List<CategoryBudgetStatus> budgetStatuses,
    required List<HouseholdNotification> existingNotifications,
    required DateTime referenceDate,
    int replenishLeadDays = 3,
  }) {
    final existingDedupKeys =
        existingNotifications.map((n) => n.dedupKey).toSet();
    final List<HouseholdNotification> newAlerts = [];

    void addIfUnique(HouseholdNotification candidate) {
      if (!existingDedupKeys.contains(candidate.dedupKey)) {
        existingDedupKeys.add(candidate.dedupKey);
        newAlerts.add(candidate);
      }
    }

    // 1. Low Wallet Balance Check (Below User Threshold)
    if (wallet.availableBalance <= household.lowBalanceThreshold) {
      final dateKey =
          '${referenceDate.year}-${referenceDate.month}-${referenceDate.day}';
      addIfUnique(
        HouseholdNotification(
          id: _uuid.v4(),
          householdId: household.id,
          type: NotificationType.lowWalletBalance,
          severity: wallet.availableBalance <=
                  (household.lowBalanceThreshold * 0.4)
              ? NotificationSeverity.critical
              : NotificationSeverity.warning,
          title: 'Low Household Wallet Balance',
          body:
              'Your household wallet balance is ${AppFormatters.formatCurrency(wallet.availableBalance, symbol: household.currencySymbol)}, which is below your alert threshold of ${AppFormatters.formatCurrency(household.lowBalanceThreshold, symbol: household.currencySymbol)}.',
          relatedEntityType: 'wallet',
          relatedEntityId: wallet.id,
          dedupKey: 'low_balance_${household.id}_$dateKey',
          createdAt: referenceDate,
        ),
      );
    }

    // 2. Supply Replenishment Predictions
    for (final pred in predictions) {
      if (pred.confidenceLevel == PredictionConfidenceLevel.insufficientData) {
        continue;
      }
      final daysRemaining = pred.daysUntilNextPurchase(referenceDate);
      final targetDate = pred.effectiveNextDate;
      if (daysRemaining == null || targetDate == null) continue;

      if (daysRemaining <= replenishLeadDays) {
        final dateIso = targetDate.toIso8601String().split('T').first;
        final NotificationType type;
        final String body;

        switch (pred.supplyType) {
          case SupplyType.electricity:
            type = NotificationType.electricityReplenishment;
            body = daysRemaining <= 0
                ? 'Your household electricity (LUKU) has reached its estimated replenishment date (${AppFormatters.formatDate(targetDate)}).'
                : 'Your household may need to purchase electricity within approximately $daysRemaining day${daysRemaining == 1 ? '' : 's'}.';
            break;
          case SupplyType.gas:
            type = NotificationType.gasReplenishment;
            body =
                'Your gas cylinder is approaching its estimated replacement date (${AppFormatters.formatDate(targetDate)}).';
            break;
          case SupplyType.water:
            type = NotificationType.waterReplenishment;
            body =
                'Your household water supply may need replenishment within approximately ${daysRemaining < 0 ? 0 : daysRemaining} day(s).';
            break;
          case SupplyType.grocery:
            type = NotificationType.groceryReplenishment;
            body =
                '${pred.supplyName} is approaching its estimated replenishment date (${AppFormatters.formatDate(targetDate)}).';
            break;
        }

        addIfUnique(
          HouseholdNotification(
            id: _uuid.v4(),
            householdId: household.id,
            type: type,
            severity: daysRemaining <= 1
                ? NotificationSeverity.critical
                : NotificationSeverity.warning,
            title: '${pred.supplyName} Replenishment Alert',
            body: body,
            relatedEntityType: 'prediction',
            relatedEntityId: pred.id,
            dedupKey: 'pred_${pred.supplyId}_$dateIso',
            createdAt: referenceDate,
          ),
        );
      }
    }

    // 3. Scheduled Recurring Bills (Internet, Rent, etc.)
    for (final bill in recurringBills) {
      if (!bill.isActive) continue;
      final daysUntil = bill.daysUntilDue(referenceDate);
      if (daysUntil >= 0 && daysUntil <= bill.remindDaysBefore) {
        final dueIso = bill.nextDueDate.toIso8601String().split('T').first;
        addIfUnique(
          HouseholdNotification(
            id: _uuid.v4(),
            householdId: household.id,
            type: NotificationType.recurringBillDue,
            severity: daysUntil <= 1
                ? NotificationSeverity.critical
                : NotificationSeverity.warning,
            title: '${bill.title} Payment Due',
            body:
                'Your ${bill.title.toLowerCase()} payment is due in $daysUntil day${daysUntil == 1 ? '' : 's'} (${AppFormatters.formatCurrency(bill.expectedAmount, symbol: household.currencySymbol)}).',
            relatedEntityType: 'recurring_bill',
            relatedEntityId: bill.id,
            dedupKey: 'bill_${bill.id}_$dueIso',
            createdAt: referenceDate,
          ),
        );
      }
    }

    // 4. Monthly Category Budgets
    for (final status in budgetStatuses) {
      final monthKey =
          '${status.budget.budgetMonth.year}_${status.budget.budgetMonth.month}';
      if (status.isExceeded) {
        addIfUnique(
          HouseholdNotification(
            id: _uuid.v4(),
            householdId: household.id,
            type: NotificationType.budgetExceeded,
            severity: NotificationSeverity.critical,
            title: '${status.budget.categoryName} Budget Exceeded',
            body:
                'Your ${status.budget.categoryName.toLowerCase()} spending (${AppFormatters.formatCurrency(status.amountSpent, symbol: household.currencySymbol)}) has exceeded the monthly budget of ${AppFormatters.formatCurrency(status.budget.budgetAmount, symbol: household.currencySymbol)}.',
            relatedEntityType: 'budget',
            relatedEntityId: status.budget.id,
            dedupKey: 'budget_exceeded_${status.budget.id}_$monthKey',
            createdAt: referenceDate,
          ),
        );
      } else if (status.isApproachingLimit) {
        addIfUnique(
          HouseholdNotification(
            id: _uuid.v4(),
            householdId: household.id,
            type: NotificationType.budgetWarning,
            severity: NotificationSeverity.warning,
            title: '${status.budget.categoryName} Budget Warning',
            body:
                'Your ${status.budget.categoryName.toLowerCase()} spending is approaching the monthly budget (${status.percentageUsed.toStringAsFixed(0)}% used).',
            relatedEntityType: 'budget',
            relatedEntityId: status.budget.id,
            dedupKey: 'budget_warn_${status.budget.id}_$monthKey',
            createdAt: referenceDate,
          ),
        );
      }
    }

    return newAlerts;
  }
}

