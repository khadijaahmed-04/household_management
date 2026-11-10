import 'package:equatable/equatable.dart';

enum NotificationType {
  electricityReplenishment,
  gasReplenishment,
  waterReplenishment,
  groceryReplenishment,
  recurringBillDue,
  lowWalletBalance,
  budgetWarning,
  budgetExceeded,
  transactionCorrected,
}

enum NotificationSeverity {
  info,
  warning,
  critical,
}

class HouseholdNotification extends Equatable {
  final String id;
  final String householdId;
  final NotificationType type;
  final NotificationSeverity severity;
  final String title;
  final String body;
  final String? relatedEntityType;
  final String? relatedEntityId;
  final String dedupKey;
  final bool isRead;
  final bool isDismissed;
  final DateTime createdAt;

  const HouseholdNotification({
    required this.id,
    required this.householdId,
    required this.type,
    required this.severity,
    required this.title,
    required this.body,
    this.relatedEntityType,
    this.relatedEntityId,
    required this.dedupKey,
    this.isRead = false,
    this.isDismissed = false,
    required this.createdAt,
  });

  HouseholdNotification copyWith({
    bool? isRead,
    bool? isDismissed,
  }) {
    return HouseholdNotification(
      id: id,
      householdId: householdId,
      type: type,
      severity: severity,
      title: title,
      body: body,
      relatedEntityType: relatedEntityType,
      relatedEntityId: relatedEntityId,
      dedupKey: dedupKey,
      isRead: isRead ?? this.isRead,
      isDismissed: isDismissed ?? this.isDismissed,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        householdId,
        type,
        severity,
        title,
        body,
        relatedEntityType,
        relatedEntityId,
        dedupKey,
        isRead,
        isDismissed,
        createdAt,
      ];
}

