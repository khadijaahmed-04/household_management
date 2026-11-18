import 'package:equatable/equatable.dart';

enum SupplyType {
  electricity,
  gas,
  water,
  grocery,
}

enum PreviousExhaustedState {
  yesCompletelyFinished, // "Yes, completely finished."
  noSomeRemained, // "No, some electricity/supply remained."
  unknown, // "I don't know."
}

extension PreviousExhaustedStateX on PreviousExhaustedState {
  String get label {
    switch (this) {
      case PreviousExhaustedState.yesCompletelyFinished:
        return 'Yes, completely finished';
      case PreviousExhaustedState.noSomeRemained:
        return 'No, some remained';
      case PreviousExhaustedState.unknown:
        return "I don't know";
    }
  }

  String get dbValue {
    switch (this) {
      case PreviousExhaustedState.yesCompletelyFinished:
        return 'yes_completely_finished';
      case PreviousExhaustedState.noSomeRemained:
        return 'no_some_remained';
      case PreviousExhaustedState.unknown:
        return 'unknown';
    }
  }

  static PreviousExhaustedState fromDb(String? val) {
    switch (val) {
      case 'yes_completely_finished':
        return PreviousExhaustedState.yesCompletelyFinished;
      case 'no_some_remained':
        return PreviousExhaustedState.noSomeRemained;
      default:
        return PreviousExhaustedState.unknown;
    }
  }
}

class TrackedSupply extends Equatable {
  final String id;
  final String householdId;
  final String? categoryId;
  final String name;
  final SupplyType supplyType;
  final String defaultUnit;
  final bool isActive;

  const TrackedSupply({
    required this.id,
    required this.householdId,
    this.categoryId,
    required this.name,
    required this.supplyType,
    required this.defaultUnit,
    this.isActive = true,
  });

  static List<TrackedSupply> createDefaultsForHousehold(String householdId) {
    return [
      TrackedSupply(
        id: 'supply-${householdId}-luku',
        householdId: householdId,
        categoryId: 'cat-${householdId}-electricity',
        name: 'Electricity',
        supplyType: SupplyType.electricity,
        defaultUnit: 'kWh',
      ),
      TrackedSupply(
        id: 'supply-${householdId}-gas',
        householdId: householdId,
        categoryId: 'cat-${householdId}-gas',
        name: 'Cooking Gas',
        supplyType: SupplyType.gas,
        defaultUnit: 'kg',
      ),
      TrackedSupply(
        id: 'supply-${householdId}-water',
        householdId: householdId,
        categoryId: 'cat-${householdId}-water',
        name: 'Water Supply',
        supplyType: SupplyType.water,
        defaultUnit: 'liters',
      ),
      TrackedSupply(
        id: 'supply-${householdId}-unga',
        householdId: householdId,
        categoryId: 'cat-${householdId}-groceries',
        name: 'Flour',
        supplyType: SupplyType.grocery,
        defaultUnit: 'kg',
      ),
      TrackedSupply(
        id: 'supply-${householdId}-sukari',
        householdId: householdId,
        categoryId: 'cat-${householdId}-groceries',
        name: 'Sugar',
        supplyType: SupplyType.grocery,
        defaultUnit: 'kg',
      ),
      TrackedSupply(
        id: 'supply-${householdId}-mafuta',
        householdId: householdId,
        categoryId: 'cat-${householdId}-groceries',
        name: 'Cooking Oil',
        supplyType: SupplyType.grocery,
        defaultUnit: 'liters',
      ),
      TrackedSupply(
        id: 'supply-${householdId}-spices',
        householdId: householdId,
        categoryId: 'cat-${householdId}-groceries',
        name: 'Spices',
        supplyType: SupplyType.grocery,
        defaultUnit: 'packs',
      ),
      TrackedSupply(
        id: 'supply-${householdId}-viungo',
        householdId: householdId,
        categoryId: 'cat-${householdId}-groceries',
        name: 'Seasonings',
        supplyType: SupplyType.grocery,
        defaultUnit: 'kg',
      ),
      TrackedSupply(
        id: 'supply-${householdId}-rice',
        householdId: householdId,
        categoryId: 'cat-${householdId}-groceries',
        name: 'Rice',
        supplyType: SupplyType.grocery,
        defaultUnit: 'kg',
      ),
      TrackedSupply(
        id: 'supply-${householdId}-milk',
        householdId: householdId,
        categoryId: 'cat-${householdId}-groceries',
        name: 'Milk',
        supplyType: SupplyType.grocery,
        defaultUnit: 'liters',
      ),
      TrackedSupply(
        id: 'supply-${householdId}-eggs',
        householdId: householdId,
        categoryId: 'cat-${householdId}-groceries',
        name: 'Eggs',
        supplyType: SupplyType.grocery,
        defaultUnit: 'trays',
      ),
      TrackedSupply(
        id: 'supply-${householdId}-soap',
        householdId: householdId,
        categoryId: 'cat-${householdId}-groceries',
        name: 'Soap',
        supplyType: SupplyType.grocery,
        defaultUnit: 'bars',
      ),
    ];
  }

  @override
  List<Object?> get props => [
        id,
        householdId,
        categoryId,
        name,
        supplyType,
        defaultUnit,
        isActive,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'household_id': householdId,
      'category_id': categoryId,
      'name': name,
      'supply_type': supplyType.name,
      'default_unit': defaultUnit,
      'is_active': isActive,
    };
  }

  factory TrackedSupply.fromJson(Map<String, dynamic> json) {
    return TrackedSupply(
      id: json['id'] as String,
      householdId: json['household_id'] as String,
      categoryId: json['category_id'] as String?,
      name: json['name'] as String,
      supplyType: SupplyType.values.firstWhere(
        (v) => v.name == json['supply_type'],
        orElse: () => SupplyType.grocery,
      ),
      defaultUnit: json['default_unit'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

class ConsumptionRecord extends Equatable {
  final String id;
  final String householdId;
  final String supplyId;
  final String supplyName;
  final SupplyType supplyType;
  final String? expenseId;
  final DateTime purchaseDate;
  final double amountPaid;
  final double? quantity; // e.g., kWh for LUKU, kg for Gas/Rice, liters for Water
  final String unit;
  final PreviousExhaustedState previousExhaustedState;
  final double? remainingUnits;
  final double? remainingPercentage;
  final double? cylinderWeightKg;
  final int? userEstimatedDurationDays;
  final DateTime? actualDepletionDate;
  final String? notes;
  final String recordedBy;
  final DateTime createdAt;

  const ConsumptionRecord({
    required this.id,
    required this.householdId,
    required this.supplyId,
    required this.supplyName,
    required this.supplyType,
    this.expenseId,
    required this.purchaseDate,
    required this.amountPaid,
    this.quantity,
    required this.unit,
    this.previousExhaustedState = PreviousExhaustedState.unknown,
    this.remainingUnits,
    this.remainingPercentage,
    this.cylinderWeightKg,
    this.userEstimatedDurationDays,
    this.actualDepletionDate,
    this.notes,
    required this.recordedBy,
    required this.createdAt,
  });

  ConsumptionRecord copyWith({
    DateTime? actualDepletionDate,
    PreviousExhaustedState? previousExhaustedState,
    double? remainingUnits,
    double? remainingPercentage,
    String? notes,
  }) {
    return ConsumptionRecord(
      id: id,
      householdId: householdId,
      supplyId: supplyId,
      supplyName: supplyName,
      supplyType: supplyType,
      expenseId: expenseId,
      purchaseDate: purchaseDate,
      amountPaid: amountPaid,
      quantity: quantity,
      unit: unit,
      previousExhaustedState:
          previousExhaustedState ?? this.previousExhaustedState,
      remainingUnits: remainingUnits ?? this.remainingUnits,
      remainingPercentage: remainingPercentage ?? this.remainingPercentage,
      cylinderWeightKg: cylinderWeightKg,
      userEstimatedDurationDays: userEstimatedDurationDays,
      actualDepletionDate: actualDepletionDate ?? this.actualDepletionDate,
      notes: notes ?? this.notes,
      recordedBy: recordedBy,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        householdId,
        supplyId,
        supplyName,
        supplyType,
        expenseId,
        purchaseDate,
        amountPaid,
        quantity,
        unit,
        previousExhaustedState,
        remainingUnits,
        remainingPercentage,
        cylinderWeightKg,
        userEstimatedDurationDays,
        actualDepletionDate,
        notes,
        recordedBy,
        createdAt,
      ];
}

enum BillingFrequency {
  weekly,
  monthly,
  quarterly,
  yearly,
}

class RecurringBill extends Equatable {
  final String id;
  final String householdId;
  final String categoryId;
  final String categoryName;
  final String title;
  final String? providerName;
  final double expectedAmount;
  final BillingFrequency frequency;
  final DateTime nextDueDate;
  final DateTime? lastPaidDate;
  final int remindDaysBefore;
  final bool isActive;
  final String? notes;

  const RecurringBill({
    required this.id,
    required this.householdId,
    required this.categoryId,
    required this.categoryName,
    required this.title,
    this.providerName,
    required this.expectedAmount,
    this.frequency = BillingFrequency.monthly,
    required this.nextDueDate,
    this.lastPaidDate,
    this.remindDaysBefore = 3,
    this.isActive = true,
    this.notes,
  });

  int daysUntilDue(DateTime referenceDate) {
    final normalizedRef =
        DateTime(referenceDate.year, referenceDate.month, referenceDate.day);
    final normalizedDue =
        DateTime(nextDueDate.year, nextDueDate.month, nextDueDate.day);
    return normalizedDue.difference(normalizedRef).inDays;
  }

  RecurringBill copyWith({
    String? title,
    String? providerName,
    double? expectedAmount,
    BillingFrequency? frequency,
    DateTime? nextDueDate,
    DateTime? lastPaidDate,
    int? remindDaysBefore,
    bool? isActive,
    String? notes,
  }) {
    return RecurringBill(
      id: id,
      householdId: householdId,
      categoryId: categoryId,
      categoryName: categoryName,
      title: title ?? this.title,
      providerName: providerName ?? this.providerName,
      expectedAmount: expectedAmount ?? this.expectedAmount,
      frequency: frequency ?? this.frequency,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      lastPaidDate: lastPaidDate ?? this.lastPaidDate,
      remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        householdId,
        categoryId,
        categoryName,
        title,
        providerName,
        expectedAmount,
        frequency,
        nextDueDate,
        lastPaidDate,
        remindDaysBefore,
        isActive,
        notes,
      ];
}

