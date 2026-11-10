import 'package:equatable/equatable.dart';
import '../../../consumption/domain/entities/consumption_entities.dart';

enum PredictionConfidenceLevel {
  insufficientData,
  low,
  medium,
  high,
}

extension PredictionConfidenceLevelX on PredictionConfidenceLevel {
  String get label {
    switch (this) {
      case PredictionConfidenceLevel.insufficientData:
        return 'Insufficient data';
      case PredictionConfidenceLevel.low:
        return 'Low confidence';
      case PredictionConfidenceLevel.medium:
        return 'Medium confidence';
      case PredictionConfidenceLevel.high:
        return 'High confidence';
    }
  }

  String get dbValue {
    switch (this) {
      case PredictionConfidenceLevel.insufficientData:
        return 'insufficient_data';
      case PredictionConfidenceLevel.low:
        return 'low';
      case PredictionConfidenceLevel.medium:
        return 'medium';
      case PredictionConfidenceLevel.high:
        return 'high';
    }
  }
}

class SupplyPrediction extends Equatable {
  final String id;
  final String householdId;
  final String supplyId;
  final String supplyName;
  final SupplyType supplyType;
  final String unit;
  final int sampleCount;
  final int confirmedCycleCount;
  final double? averageIntervalDays;
  final double? medianIntervalDays;
  final double? weightedIntervalDays;
  final double? intervalStdDevDays;
  final double? averagePurchaseAmount;
  final double? averageDailyConsumptionUnits;
  final double? averageDailyCost;
  final DateTime? lastPurchaseDate;
  final DateTime? estimatedNextReplenishmentDate;
  final DateTime? manualOverrideDate;
  final DateTime? actualConfirmedDepletionDate;
  final PredictionConfidenceLevel confidenceLevel;
  final double confidenceScore; // 0..100
  final bool isMonetaryEstimateOnly;
  final String explanation;
  final String trendDirection; // 'increasing', 'stable', 'decreasing'
  final List<double> historicalIntervalsDays;
  final DateTime updatedAt;

  const SupplyPrediction({
    required this.id,
    required this.householdId,
    required this.supplyId,
    required this.supplyName,
    required this.supplyType,
    required this.unit,
    required this.sampleCount,
    required this.confirmedCycleCount,
    this.averageIntervalDays,
    this.medianIntervalDays,
    this.weightedIntervalDays,
    this.intervalStdDevDays,
    this.averagePurchaseAmount,
    this.averageDailyConsumptionUnits,
    this.averageDailyCost,
    this.lastPurchaseDate,
    this.estimatedNextReplenishmentDate,
    this.manualOverrideDate,
    this.actualConfirmedDepletionDate,
    required this.confidenceLevel,
    required this.confidenceScore,
    required this.isMonetaryEstimateOnly,
    required this.explanation,
    this.trendDirection = 'stable',
    this.historicalIntervalsDays = const [],
    required this.updatedAt,
  });

  DateTime? get effectiveNextDate =>
      manualOverrideDate ?? estimatedNextReplenishmentDate;

  int? daysUntilNextPurchase(DateTime referenceDate) {
    final target = effectiveNextDate;
    if (target == null) return null;
    final ref =
        DateTime(referenceDate.year, referenceDate.month, referenceDate.day);
    final tgt = DateTime(target.year, target.month, target.day);
    return tgt.difference(ref).inDays;
  }

  SupplyPrediction copyWith({
    DateTime? manualOverrideDate,
    DateTime? actualConfirmedDepletionDate,
    DateTime? estimatedNextReplenishmentDate,
    String? explanation,
  }) {
    return SupplyPrediction(
      id: id,
      householdId: householdId,
      supplyId: supplyId,
      supplyName: supplyName,
      supplyType: supplyType,
      unit: unit,
      sampleCount: sampleCount,
      confirmedCycleCount: confirmedCycleCount,
      averageIntervalDays: averageIntervalDays,
      medianIntervalDays: medianIntervalDays,
      weightedIntervalDays: weightedIntervalDays,
      intervalStdDevDays: intervalStdDevDays,
      averagePurchaseAmount: averagePurchaseAmount,
      averageDailyConsumptionUnits: averageDailyConsumptionUnits,
      averageDailyCost: averageDailyCost,
      lastPurchaseDate: lastPurchaseDate,
      estimatedNextReplenishmentDate:
          estimatedNextReplenishmentDate ?? this.estimatedNextReplenishmentDate,
      manualOverrideDate: manualOverrideDate ?? this.manualOverrideDate,
      actualConfirmedDepletionDate:
          actualConfirmedDepletionDate ?? this.actualConfirmedDepletionDate,
      confidenceLevel: confidenceLevel,
      confidenceScore: confidenceScore,
      isMonetaryEstimateOnly: isMonetaryEstimateOnly,
      explanation: explanation ?? this.explanation,
      trendDirection: trendDirection,
      historicalIntervalsDays: historicalIntervalsDays,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        householdId,
        supplyId,
        supplyName,
        supplyType,
        unit,
        sampleCount,
        confirmedCycleCount,
        averageIntervalDays,
        medianIntervalDays,
        weightedIntervalDays,
        intervalStdDevDays,
        averagePurchaseAmount,
        averageDailyConsumptionUnits,
        averageDailyCost,
        lastPurchaseDate,
        estimatedNextReplenishmentDate,
        manualOverrideDate,
        actualConfirmedDepletionDate,
        confidenceLevel,
        confidenceScore,
        isMonetaryEstimateOnly,
        explanation,
        trendDirection,
        historicalIntervalsDays,
        updatedAt,
      ];
}

