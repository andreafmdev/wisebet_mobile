import '../../domain/models/profit_entry.dart';
import 'dart:math';

/// Repository per i profitti (mock)
class ProfitRepository {
  final Random _random = Random();
  final List<ProfitEntry> _entries = [];

  ProfitRepository() {
    // Genera dati mock
    _generateMockData();
  }

  void _generateMockData() {
    final now = DateTime.now();
    final types = ProfitType.values;

    for (var i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final type = types[_random.nextInt(types.length)];
      final amount = _random.nextDouble() * 100 - 20; // -20 a +80

      _entries.add(
        ProfitEntry(
          id: 'profit_$i',
          date: date,
          type: type,
          amount: amount,
          description: _getDescriptionForType(type),
          offerId: type == ProfitType.welcomeOffer ? '1' : null,
        ),
      );
    }

    // Ordina per data decrescente
    _entries.sort((a, b) => b.date.compareTo(a.date));
  }

  String _getDescriptionForType(ProfitType type) {
    switch (type) {
      case ProfitType.welcomeOffer:
        return 'Bonus benvenuto Bet365';
      case ProfitType.recurringOffer:
        return 'Offerta ricorrente';
      case ProfitType.surebet:
        return 'Surebet trovata';
      case ProfitType.valuebet:
        return 'Valuebet identificata';
      case ProfitType.manual:
        return 'Voce manuale';
    }
  }

  Future<List<ProfitEntry>> getEntries({
    DateTime? startDate,
    DateTime? endDate,
    ProfitType? type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var filtered = List<ProfitEntry>.from(_entries);

    if (startDate != null) {
      filtered = filtered.where((e) => e.date.isAfter(startDate)).toList();
    }
    if (endDate != null) {
      filtered = filtered.where((e) => e.date.isBefore(endDate)).toList();
    }
    if (type != null) {
      filtered = filtered.where((e) => e.type == type).toList();
    }

    return filtered;
  }

  Future<double> getTotalProfit() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final sum = _entries.fold(0.0, (s, e) => s + e.amount);
    return sum;
  }

  Future<double> getMonthlyProfit() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final sum = _entries
        .where((e) => e.date.isAfter(startOfMonth))
        .fold(0.0, (s, e) => s + e.amount);
    return sum;
  }

  Future<void> addEntry(ProfitEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _entries.insert(0, entry);
    _entries.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<List<ProfitEntry>> getWeeklyData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return _entries.where((e) => e.date.isAfter(weekAgo)).toList();
  }

  Future<Map<DateTime, double>> getProfitByDay({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final map = <DateTime, double>{};

    for (var entry in _entries) {
      if (entry.date.isAfter(startDate) && entry.date.isBefore(endDate)) {
        final day = DateTime(entry.date.year, entry.date.month, entry.date.day);
        map[day] = (map[day] ?? 0.0) + entry.amount;
      }
    }

    return map;
  }
}

