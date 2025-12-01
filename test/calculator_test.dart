import 'package:flutter_test/flutter_test.dart';
import 'package:wisebet_mobile/data/repositories/surebet_repository.dart';

void main() {
  group('SureBet Calculator', () {
    late SurebetRepository repository;

    setUp(() {
      repository = SurebetRepository();
    });

    test('calcola correttamente una surebet valida', () {
      final result = repository.calculateSurebet(
        backOdds: 2.10,
        layOdds: 2.15,
        stake: 100.0,
      );

      expect(result.isValid, true);
      expect(result.backStake, 100.0);
      expect(result.profit, greaterThan(0));
      expect(result.profitPercentage, greaterThan(0));
    });

    test('identifica correttamente una surebet non valida', () {
      final result = repository.calculateSurebet(
        backOdds: 1.50,
        layOdds: 1.50,
        stake: 100.0,
      );

      expect(result.isValid, false);
      expect(result.profit, lessThanOrEqualTo(0));
    });

    test('calcola correttamente le puntate back e lay', () {
      final result = repository.calculateSurebet(
        backOdds: 2.0,
        layOdds: 2.0,
        stake: 100.0,
      );

      expect(result.backStake, 100.0);
      expect(result.layStake, greaterThan(0));
      expect(result.totalStake, equals(result.backStake + result.layStake));
    });

    test('gestisce correttamente quote diverse', () {
      final result1 = repository.calculateSurebet(
        backOdds: 3.0,
        layOdds: 2.5,
        stake: 50.0,
      );

      final result2 = repository.calculateSurebet(
        backOdds: 1.8,
        layOdds: 1.9,
        stake: 50.0,
      );

      expect(result1.backStake, 50.0);
      expect(result2.backStake, 50.0);
      expect(result1.totalStake, isNot(equals(result2.totalStake)));
    });
  });
}

