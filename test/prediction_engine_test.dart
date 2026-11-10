import 'package:flutter_test/flutter_test.dart';
import 'package:household_management/features/consumption/domain/entities/consumption_entities.dart';
import 'package:household_management/features/predictions/domain/entities/prediction_entity.dart';
import 'package:household_management/features/predictions/domain/services/prediction_engine.dart';

void main() {
  group('Consumption Prediction Engine Tests (Section 18.2)', () {
    const engine = PredictionEngine();
    const lukuSupply = TrackedSupply(
      id: 'supply-luku',
      householdId: 'h1',
      name: 'Electricity (LUKU)',
      supplyType: SupplyType.electricity,
      defaultUnit: 'kWh',
    );
    const gasSupply = TrackedSupply(
      id: 'supply-gas',
      householdId: 'h1',
      name: 'Cooking Gas',
      supplyType: SupplyType.gas,
      defaultUnit: 'kg',
    );

    test(
        'Insufficient historical data with 1 purchase returns clear message and insufficientData confidence',
        () {
      final pred = engine.computePrediction(
        supply: lukuSupply,
        records: [
          ConsumptionRecord(
            id: 'r1',
            householdId: 'h1',
            supplyId: lukuSupply.id,
            supplyName: lukuSupply.name,
            supplyType: SupplyType.electricity,
            purchaseDate: DateTime(2026, 11, 5),
            amountPaid: 30000,
            unit: 'kWh',
            recordedBy: 'admin',
            createdAt: DateTime(2026, 11, 5),
          ),
        ],
      );

      expect(pred.confidenceLevel, PredictionConfidenceLevel.insufficientData);
      expect(
        pred.explanation,
        contains(
          'Not enough historical data to predict accurately. Continue recording purchases.',
        ),
      );
      expect(pred.estimatedNextReplenishmentDate, isNull);
    });

    test(
        'Electricity LUKU purchases on 5 Oct, 15 Oct, 25 Oct, 4 Nov calculate 10-day interval and predict 14 Nov',
        () {
      final records = [
        ConsumptionRecord(
          id: 'r1',
          householdId: 'h1',
          supplyId: lukuSupply.id,
          supplyName: lukuSupply.name,
          supplyType: SupplyType.electricity,
          purchaseDate: DateTime(2026, 10, 5),
          amountPaid: 30000,
          unit: 'kWh',
          previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
          recordedBy: 'admin',
          createdAt: DateTime(2026, 10, 5),
        ),
        ConsumptionRecord(
          id: 'r2',
          householdId: 'h1',
          supplyId: lukuSupply.id,
          supplyName: lukuSupply.name,
          supplyType: SupplyType.electricity,
          purchaseDate: DateTime(2026, 10, 15),
          amountPaid: 30000,
          unit: 'kWh',
          previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
          recordedBy: 'admin',
          createdAt: DateTime(2026, 10, 15),
        ),
        ConsumptionRecord(
          id: 'r3',
          householdId: 'h1',
          supplyId: lukuSupply.id,
          supplyName: lukuSupply.name,
          supplyType: SupplyType.electricity,
          purchaseDate: DateTime(2026, 10, 25),
          amountPaid: 35000,
          unit: 'kWh',
          previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
          recordedBy: 'admin',
          createdAt: DateTime(2026, 10, 25),
        ),
        ConsumptionRecord(
          id: 'r4',
          householdId: 'h1',
          supplyId: lukuSupply.id,
          supplyName: lukuSupply.name,
          supplyType: SupplyType.electricity,
          purchaseDate: DateTime(2026, 11, 4),
          amountPaid: 30000,
          unit: 'kWh',
          previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
          recordedBy: 'admin',
          createdAt: DateTime(2026, 11, 4),
        ),
      ];

      final pred = engine.computePrediction(
        supply: lukuSupply,
        records: records,
      );

      expect(pred.averageIntervalDays, 10.0);
      expect(pred.medianIntervalDays, 10.0);
      expect(pred.estimatedNextReplenishmentDate, DateTime(2026, 11, 14));
      expect(pred.confidenceLevel, PredictionConfidenceLevel.high);
      expect(pred.isMonetaryEstimateOnly, isTrue);
    });

    test(
        'Gas replacement with 25-day average duration purchased on 1 Nov estimates next replacement on 26 Nov',
        () {
      final records = [
        ConsumptionRecord(
          id: 'g1',
          householdId: 'h1',
          supplyId: gasSupply.id,
          supplyName: gasSupply.name,
          supplyType: SupplyType.gas,
          purchaseDate: DateTime(2026, 9, 12),
          amountPaid: 55000,
          quantity: 15,
          cylinderWeightKg: 15,
          unit: 'kg',
          previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
          recordedBy: 'admin',
          createdAt: DateTime(2026, 9, 12),
        ),
        ConsumptionRecord(
          id: 'g2',
          householdId: 'h1',
          supplyId: gasSupply.id,
          supplyName: gasSupply.name,
          supplyType: SupplyType.gas,
          purchaseDate: DateTime(2026, 10, 7),
          amountPaid: 55000,
          quantity: 15,
          cylinderWeightKg: 15,
          unit: 'kg',
          previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
          recordedBy: 'admin',
          createdAt: DateTime(2026, 10, 7),
        ),
        ConsumptionRecord(
          id: 'g3',
          householdId: 'h1',
          supplyId: gasSupply.id,
          supplyName: gasSupply.name,
          supplyType: SupplyType.gas,
          purchaseDate: DateTime(2026, 11, 1),
          amountPaid: 55000,
          quantity: 15,
          cylinderWeightKg: 15,
          unit: 'kg',
          previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
          recordedBy: 'admin',
          createdAt: DateTime(2026, 11, 1),
        ),
      ];

      final pred = engine.computePrediction(
        supply: gasSupply,
        records: records,
      );

      expect(pred.averageIntervalDays, 25.0);
      expect(pred.estimatedNextReplenishmentDate, DateTime(2026, 11, 26));
    });

    test(
        'Manual correction when gas finishes on 23 Nov instead of 26 Nov updates observed intervals',
        () {
      final records = [
        ConsumptionRecord(
          id: 'g1',
          householdId: 'h1',
          supplyId: gasSupply.id,
          supplyName: gasSupply.name,
          supplyType: SupplyType.gas,
          purchaseDate: DateTime(2026, 10, 7),
          amountPaid: 55000,
          quantity: 15,
          unit: 'kg',
          previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
          recordedBy: 'admin',
          createdAt: DateTime(2026, 10, 7),
        ),
        ConsumptionRecord(
          id: 'g2',
          householdId: 'h1',
          supplyId: gasSupply.id,
          supplyName: gasSupply.name,
          supplyType: SupplyType.gas,
          purchaseDate: DateTime(2026, 11, 1),
          amountPaid: 55000,
          quantity: 15,
          unit: 'kg',
          previousExhaustedState: PreviousExhaustedState.yesCompletelyFinished,
          actualDepletionDate: DateTime(2026, 11, 23), // 22 days actual outcome
          recordedBy: 'admin',
          createdAt: DateTime(2026, 11, 1),
        ),
      ];

      final pred = engine.computePrediction(
        supply: gasSupply,
        records: records,
      );

      // Intervals: [25.0, 22.0] -> average = 23.5 days
      expect(pred.averageIntervalDays, 23.5);
      expect(pred.actualConfirmedDepletionDate, DateTime(2026, 11, 23));
    });
  });
}
