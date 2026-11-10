import 'dart:math' as math;
import '../../../consumption/domain/entities/consumption_entities.dart';
import '../entities/prediction_entity.dart';

/// Statistical Consumption & Replenishment Prediction Engine.
///
/// Implements the exact requirements of Sections 8 and 9:
/// - Collects historical replenishment dates sorted chronologically.
/// - Calculates intervals between replenishment events, accounting for:
///   * Confirmed depletion (`yesCompletelyFinished`) vs remaining balance (`noSomeRemained`).
///   * Actual confirmed depletion outcomes (`actualDepletionDate`) recorded by the administrator.
/// - Computes arithmetic mean, median (to suppress outlier distortion), recency-weighted interval,
///   and sample standard deviation / coefficient of variation (CV).
/// - Clearly distinguishes between monetary interval estimates and physical unit (kWh/kg/L) rates.
class PredictionEngine {
  const PredictionEngine();

  SupplyPrediction computePrediction({
    required TrackedSupply supply,
    required List<ConsumptionRecord> records,
    DateTime? manualOverrideDate,
  }) {
    final sorted = List<ConsumptionRecord>.from(records)
      ..sort((a, b) => a.purchaseDate.compareTo(b.purchaseDate));

    final sampleCount = sorted.length;
    if (sampleCount == 0) {
      return SupplyPrediction(
        id: 'pred-${supply.id}',
        householdId: supply.householdId,
        supplyId: supply.id,
        supplyName: supply.name,
        supplyType: supply.supplyType,
        unit: supply.defaultUnit,
        sampleCount: 0,
        confirmedCycleCount: 0,
        confidenceLevel: PredictionConfidenceLevel.insufficientData,
        confidenceScore: 0,
        isMonetaryEstimateOnly: true,
        explanation:
            'Not enough historical data to predict accurately. Continue recording purchases.',
        updatedAt: DateTime.now(),
      );
    }

    final totalSpent =
        sorted.fold<double>(0.0, (sum, r) => sum + r.amountPaid);
    final avgPurchaseAmount = totalSpent / sampleCount;
    final lastRecord = sorted.last;

    // Check if we only have 1 purchase and no confirmed actual depletion date
    if (sampleCount == 1 && lastRecord.actualDepletionDate == null) {
      // If the user provided an initial expected duration (e.g. for a 1st-time purchase),
      // compute a preliminary Low-Confidence estimate from that duration.
      if (lastRecord.userEstimatedDurationDays != null &&
          lastRecord.userEstimatedDurationDays! > 0) {
        final estDays = lastRecord.userEstimatedDurationDays!.toDouble();
        final nextDate = lastRecord.purchaseDate
            .add(Duration(days: lastRecord.userEstimatedDurationDays!));
        final dailyUnits =
            (lastRecord.quantity != null && lastRecord.quantity! > 0)
                ? lastRecord.quantity! / estDays
                : null;
        return SupplyPrediction(
          id: 'pred-${supply.id}',
          householdId: supply.householdId,
          supplyId: supply.id,
          supplyName: supply.name,
          supplyType: supply.supplyType,
          unit: supply.defaultUnit,
          sampleCount: 1,
          confirmedCycleCount: 0,
          averageIntervalDays: estDays,
          medianIntervalDays: estDays,
          weightedIntervalDays: estDays,
          intervalStdDevDays: 0.0,
          averagePurchaseAmount: avgPurchaseAmount,
          averageDailyConsumptionUnits: dailyUnits != null
              ? double.parse(dailyUnits.toStringAsFixed(3))
              : null,
          averageDailyCost:
              double.parse((avgPurchaseAmount / estDays).toStringAsFixed(2)),
          lastPurchaseDate: lastRecord.purchaseDate,
          estimatedNextReplenishmentDate: nextDate,
          confidenceLevel: PredictionConfidenceLevel.low,
          confidenceScore: 30.0,
          isMonetaryEstimateOnly: dailyUnits == null,
          explanation:
              'First-time purchase preliminary estimate ($estDays days). Accuracy will improve automatically once you record your next purchase.',
          historicalIntervalsDays: [estDays],
          updatedAt: DateTime.now(),
        );
      }

      return SupplyPrediction(
        id: 'pred-${supply.id}',
        householdId: supply.householdId,
        supplyId: supply.id,
        supplyName: supply.name,
        supplyType: supply.supplyType,
        unit: supply.defaultUnit,
        sampleCount: 1,
        confirmedCycleCount: 0,
        averagePurchaseAmount: avgPurchaseAmount,
        lastPurchaseDate: lastRecord.purchaseDate,
        confidenceLevel: PredictionConfidenceLevel.insufficientData,
        confidenceScore: 15.0,
        isMonetaryEstimateOnly: lastRecord.quantity == null,
        explanation:
            'Not enough historical data to predict accurately. Continue recording purchases.',
        updatedAt: DateTime.now(),
      );
    }

    // 1. Extract observed replenishment intervals in days
    final List<double> effectiveIntervals = [];
    final List<double> dailyUnitRates = [];
    final List<double> dailyCostRates = [];
    int confirmedCycles = 0;

    for (int i = 0; i < sorted.length; i++) {
      final current = sorted[i];

      // Case A: The administrator explicitly recorded the actual depletion date for this purchase
      if (current.actualDepletionDate != null) {
        final actualDays = current.actualDepletionDate!
            .difference(current.purchaseDate)
            .inDays
            .toDouble();
        if (actualDays > 0) {
          effectiveIntervals.add(actualDays);
          confirmedCycles++;
          dailyCostRates.add(current.amountPaid / actualDays);
          if (current.quantity != null && current.quantity! > 0) {
            dailyUnitRates.add(current.quantity! / actualDays);
          }
          continue;
        }
      }

      // Case B: Interval between purchase[i] and purchase[i + 1]
      if (i < sorted.length - 1) {
        final next = sorted[i + 1];
        final rawDays =
            next.purchaseDate.difference(current.purchaseDate).inDays.toDouble();
        if (rawDays <= 0) continue;

        double adjustedFullCycleDays = rawDays;
        double consumedFraction = 1.0;

        if (next.previousExhaustedState ==
            PreviousExhaustedState.yesCompletelyFinished) {
          confirmedCycles++;
        } else if (next.previousExhaustedState ==
            PreviousExhaustedState.noSomeRemained) {
          // Do not naively assume 100% of the previous purchase was exhausted!
          if (next.remainingPercentage != null &&
              next.remainingPercentage! > 0 &&
              next.remainingPercentage! < 90) {
            consumedFraction = (100.0 - next.remainingPercentage!) / 100.0;
            adjustedFullCycleDays = rawDays / consumedFraction;
          } else if (next.remainingUnits != null &&
              current.quantity != null &&
              current.quantity! > next.remainingUnits!) {
            consumedFraction =
                (current.quantity! - next.remainingUnits!) / current.quantity!;
            if (consumedFraction >= 0.1) {
              adjustedFullCycleDays = rawDays / consumedFraction;
            }
          }
        }

        effectiveIntervals.add(adjustedFullCycleDays);
        dailyCostRates.add((current.amountPaid * consumedFraction) / rawDays);

        if (current.quantity != null && current.quantity! > 0) {
          final consumedUnits = current.quantity! * consumedFraction;
          dailyUnitRates.add(consumedUnits / rawDays);
        }
      }
    }

    if (effectiveIntervals.isEmpty) {
      return SupplyPrediction(
        id: 'pred-${supply.id}',
        householdId: supply.householdId,
        supplyId: supply.id,
        supplyName: supply.name,
        supplyType: supply.supplyType,
        unit: supply.defaultUnit,
        sampleCount: sampleCount,
        confirmedCycleCount: confirmedCycles,
        averagePurchaseAmount: avgPurchaseAmount,
        lastPurchaseDate: lastRecord.purchaseDate,
        confidenceLevel: PredictionConfidenceLevel.insufficientData,
        confidenceScore: 15.0,
        isMonetaryEstimateOnly: true,
        explanation:
            'Not enough historical data to predict accurately. Continue recording purchases.',
        updatedAt: DateTime.now(),
      );
    }

    // 2. Calculate Mean, Median, Recency-Weighted Average, and Standard Deviation
    final meanInterval = _mean(effectiveIntervals);
    final medianInterval = _median(effectiveIntervals);
    final weightedInterval = _recencyWeightedAverage(effectiveIntervals);
    final stdDev = _standardDeviation(effectiveIntervals, meanInterval);
    final cv = meanInterval > 0 ? (stdDev / meanInterval) : 0.0;

    // Blend recency-weighted interval (60%) and median interval (40%) to resist single-purchase outliers
    double blendedIntervalDays = effectiveIntervals.length >= 3
        ? (0.6 * weightedInterval + 0.4 * medianInterval)
        : weightedInterval;

    // If the latest purchase has a known quantity (e.g., kWh or kg) and we know the average daily unit rate,
    // refine the expected duration for the latest purchase!
    final avgDailyUnits =
        dailyUnitRates.isNotEmpty ? _mean(dailyUnitRates) : null;
    final avgDailyCost =
        dailyCostRates.isNotEmpty ? _mean(dailyCostRates) : null;
    final isMonetaryOnly = dailyUnitRates.isEmpty;

    if (!isMonetaryOnly &&
        lastRecord.quantity != null &&
        lastRecord.quantity! > 0 &&
        avgDailyUnits != null &&
        avgDailyUnits > 0) {
      // Include any carry-over remaining units reported at the time of lastRecord
      final totalAvailableUnits =
          lastRecord.quantity! + (lastRecord.remainingUnits ?? 0.0);
      final unitBasedDays = totalAvailableUnits / avgDailyUnits;
      // Blend interval-based and unit-based estimate if lastRecord doesn't have an actual depletion override
      if (lastRecord.actualDepletionDate == null) {
        blendedIntervalDays =
            0.5 * blendedIntervalDays + 0.5 * unitBasedDays;
      }
    }

    // If the administrator already recorded the actual depletion date on the latest purchase,
    // use that exact learned duration for the latest cycle
    final int predictedDaysRounded =
        math.max(1, blendedIntervalDays.round());
    final DateTime estimatedNextDate = lastRecord.actualDepletionDate ??
        lastRecord.purchaseDate.add(Duration(days: predictedDaysRounded));

    // 3. Determine Trend Direction ('increasing', 'stable', 'decreasing' consumption speed)
    String trend = 'stable';
    if (effectiveIntervals.length >= 2) {
      final firstHalf = effectiveIntervals.first;
      final latest = effectiveIntervals.last;
      if (latest < firstHalf * 0.85) {
        trend = 'increasing'; // Shorter interval means faster consumption
      } else if (latest > firstHalf * 1.15) {
        trend = 'decreasing'; // Longer interval means slower consumption
      }
    }

    // 4. Compute Confidence Score & Confidence Level
    final confidence = _evaluateConfidence(
      intervalCount: effectiveIntervals.length,
      confirmedCycles: confirmedCycles,
      coefficientOfVariation: cv,
      hasPhysicalUnits: !isMonetaryOnly,
    );

    // 5. Build clear, transparent explanation
    final basisText = isMonetaryOnly
        ? 'Estimated from historical purchase intervals (monetary records only; record ${supply.defaultUnit} for higher precision).'
        : 'Calculated from historical replenishment intervals and physical consumption (${avgDailyUnits!.toStringAsFixed(2)} ${supply.defaultUnit}/day).';

    final explanation =
        'Historical average interval: ${meanInterval.toStringAsFixed(1)} days '
        '(median: ${medianInterval.toStringAsFixed(1)} days). $basisText';

    return SupplyPrediction(
      id: 'pred-${supply.id}',
      householdId: supply.householdId,
      supplyId: supply.id,
      supplyName: supply.name,
      supplyType: supply.supplyType,
      unit: supply.defaultUnit,
      sampleCount: sampleCount,
      confirmedCycleCount: confirmedCycles,
      averageIntervalDays: double.parse(meanInterval.toStringAsFixed(2)),
      medianIntervalDays: double.parse(medianInterval.toStringAsFixed(2)),
      weightedIntervalDays: double.parse(weightedInterval.toStringAsFixed(2)),
      intervalStdDevDays: double.parse(stdDev.toStringAsFixed(2)),
      averagePurchaseAmount:
          double.parse(avgPurchaseAmount.toStringAsFixed(2)),
      averageDailyConsumptionUnits: avgDailyUnits != null
          ? double.parse(avgDailyUnits.toStringAsFixed(3))
          : null,
      averageDailyCost: avgDailyCost != null
          ? double.parse(avgDailyCost.toStringAsFixed(2))
          : null,
      lastPurchaseDate: lastRecord.purchaseDate,
      estimatedNextReplenishmentDate: estimatedNextDate,
      manualOverrideDate: manualOverrideDate,
      actualConfirmedDepletionDate: lastRecord.actualDepletionDate,
      confidenceLevel: confidence.level,
      confidenceScore: confidence.score,
      isMonetaryEstimateOnly: isMonetaryOnly,
      explanation: explanation,
      trendDirection: trend,
      historicalIntervalsDays: effectiveIntervals,
      updatedAt: DateTime.now(),
    );
  }

  double _mean(List<double> values) {
    if (values.isEmpty) return 0.0;
    final sum = values.fold<double>(0.0, (a, b) => a + b);
    return sum / values.length;
  }

  double _median(List<double> values) {
    if (values.isEmpty) return 0.0;
    final sorted = List<double>.from(values)..sort();
    final mid = sorted.length ~/ 2;
    if (sorted.length.isOdd) {
      return sorted[mid];
    }
    return (sorted[mid - 1] + sorted[mid]) / 2.0;
  }

  /// Linearly weights more recent intervals higher than older intervals:
  /// weight(i) = i + 1 for i in 0..n-1.
  double _recencyWeightedAverage(List<double> intervals) {
    if (intervals.isEmpty) return 0.0;
    double weightedSum = 0.0;
    double weightTotal = 0.0;
    for (int i = 0; i < intervals.length; i++) {
      final weight = (i + 1).toDouble();
      weightedSum += intervals[i] * weight;
      weightTotal += weight;
    }
    return weightedSum / weightTotal;
  }

  double _standardDeviation(List<double> values, double mean) {
    if (values.length <= 1) return 0.0;
    double sumSquaredDiff = 0.0;
    for (final v in values) {
      final diff = v - mean;
      sumSquaredDiff += diff * diff;
    }
    return math.sqrt(sumSquaredDiff / (values.length - 1));
  }

  ({PredictionConfidenceLevel level, double score}) _evaluateConfidence({
    required int intervalCount,
    required int confirmedCycles,
    required double coefficientOfVariation,
    required bool hasPhysicalUnits,
  }) {
    if (intervalCount <= 0) {
      return (level: PredictionConfidenceLevel.insufficientData, score: 10.0);
    }

    // Base score from number of intervals
    double score = math.min(55.0, intervalCount * 16.0);

    // Consistency bonus/penalty from Coefficient of Variation (CV)
    if (intervalCount >= 2) {
      if (coefficientOfVariation <= 0.12) {
        score += 25.0;
      } else if (coefficientOfVariation <= 0.25) {
        score += 15.0;
      } else if (coefficientOfVariation <= 0.40) {
        score += 5.0;
      } else {
        score -= 15.0;
      }
    }

    // Confirmed exhaustion bonus
    if (confirmedCycles > 0) {
      final confirmationRatio = confirmedCycles / intervalCount;
      score += 12.0 * math.min(1.0, confirmationRatio);
    }

    // Physical units bonus (kWh, kg, liters)
    if (hasPhysicalUnits) {
      score += 8.0;
    }

    score = score.clamp(15.0, 98.0);

    if (intervalCount == 1) {
      return (
        level: PredictionConfidenceLevel.low,
        score: math.min(score, 45.0)
      );
    }

    if (intervalCount >= 3 &&
        coefficientOfVariation <= 0.22 &&
        score >= 72.0) {
      return (level: PredictionConfidenceLevel.high, score: score);
    }

    if (intervalCount >= 2 &&
        coefficientOfVariation <= 0.38 &&
        score >= 48.0) {
      return (level: PredictionConfidenceLevel.medium, score: score);
    }

    return (level: PredictionConfidenceLevel.low, score: score);
  }
}

