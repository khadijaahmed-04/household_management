import 'package:equatable/equatable.dart';

class HouseholdBudget extends Equatable {
  final String id;
  final String householdId;
  final String categoryId;
  final String categoryName;
  final DateTime budgetMonth; // Normalized to first day of month
  final double budgetAmount;
  final double alertThresholdPercent;
  final bool isActive;

  const HouseholdBudget({
    required this.id,
    required this.householdId,
    required this.categoryId,
    required this.categoryName,
    required this.budgetMonth,
    required this.budgetAmount,
    this.alertThresholdPercent = 80.0,
    this.isActive = true,
  });

  HouseholdBudget copyWith({
    double? budgetAmount,
    double? alertThresholdPercent,
    bool? isActive,
  }) {
    return HouseholdBudget(
      id: id,
      householdId: householdId,
      categoryId: categoryId,
      categoryName: categoryName,
      budgetMonth: budgetMonth,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      alertThresholdPercent:
          alertThresholdPercent ?? this.alertThresholdPercent,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        householdId,
        categoryId,
        categoryName,
        budgetMonth,
        budgetAmount,
        alertThresholdPercent,
        isActive,
      ];
}

class CategoryBudgetStatus extends Equatable {
  final HouseholdBudget budget;
  final double amountSpent;

  const CategoryBudgetStatus({
    required this.budget,
    required this.amountSpent,
  });

  double get remainingBudget => budget.budgetAmount - amountSpent;

  double get percentageUsed => budget.budgetAmount > 0
      ? (amountSpent / budget.budgetAmount) * 100.0
      : 0.0;

  bool get isExceeded => amountSpent > budget.budgetAmount;

  bool get isApproachingLimit =>
      !isExceeded && percentageUsed >= budget.alertThresholdPercent;

  @override
  List<Object?> get props => [budget, amountSpent];
}

