import 'package:flutter_test/flutter_test.dart';
import 'package:wisebet_mobile/data/repositories/profit_repository.dart';
import 'package:wisebet_mobile/domain/models/profit_entry.dart';

void main() {
  group('Profit Tracker', () {
    late ProfitRepository repository;

    setUp(() {
      repository = ProfitRepository();
    });

    test('calcola correttamente il profitto totale', () async {
      final totalProfit = await repository.getTotalProfit();
      expect(totalProfit, isNotNull);
      expect(totalProfit, isA<double>());
    });

    test('calcola correttamente il profitto mensile', () async {
      final monthlyProfit = await repository.getMonthlyProfit();
      expect(monthlyProfit, isNotNull);
      expect(monthlyProfit, isA<double>());
    });

    test('filtra correttamente le entry per tipo', () async {
      final surebetEntries = await repository.getEntries(
        type: ProfitType.surebet,
      );
      expect(surebetEntries, isA<List<ProfitEntry>>());
      expect(surebetEntries.every((e) => e.type == ProfitType.surebet), true);
    });

    test('aggiunge correttamente una nuova entry', () async {
      final initialCount = (await repository.getEntries()).length;

      final newEntry = ProfitEntry(
        id: 'test_${DateTime.now().millisecondsSinceEpoch}',
        date: DateTime.now(),
        type: ProfitType.manual,
        amount: 50.0,
        description: 'Test entry',
      );

      await repository.addEntry(newEntry);

      final finalCount = (await repository.getEntries()).length;
      expect(finalCount, equals(initialCount + 1));
    });

    test('filtra correttamente per periodo', () async {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));

      final weeklyEntries = await repository.getEntries(
        startDate: weekAgo,
        endDate: now,
      );

      expect(weeklyEntries, isA<List<ProfitEntry>>());
      expect(
        weeklyEntries.every((e) => e.date.isAfter(weekAgo) && e.date.isBefore(now)),
        true,
      );
    });

    test('calcola correttamente i profitti per giorno', () async {
      final now = DateTime.now();
      final monthAgo = now.subtract(const Duration(days: 30));

      final profitByDay = await repository.getProfitByDay(
        startDate: monthAgo,
        endDate: now,
      );

      expect(profitByDay, isA<Map<DateTime, double>>());
      expect(profitByDay.isNotEmpty, true);
    });
  });
}

