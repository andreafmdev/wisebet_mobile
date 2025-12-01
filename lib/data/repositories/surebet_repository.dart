import '../../domain/models/surebet.dart';

/// Repository per surebet (mock)
class SurebetRepository {

  Future<List<BetEvent>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      BetEvent(
        id: '1',
        sport: 'Calcio',
        league: 'Serie A',
        homeTeam: 'Juventus',
        awayTeam: 'Inter',
        startTime: DateTime.now().add(const Duration(hours: 2)),
        odds: {
          'Bet365': 2.10,
          'Betfair': 2.15,
          'William Hill': 2.05,
        },
      ),
      BetEvent(
        id: '2',
        sport: 'Calcio',
        league: 'Premier League',
        homeTeam: 'Arsenal',
        awayTeam: 'Chelsea',
        startTime: DateTime.now().add(const Duration(hours: 4)),
        odds: {
          'Bet365': 1.85,
          'Betfair': 1.90,
          'Unibet': 1.88,
        },
      ),
      BetEvent(
        id: '3',
        sport: 'Tennis',
        league: 'ATP Masters',
        homeTeam: 'Djokovic',
        awayTeam: 'Nadal',
        startTime: DateTime.now().add(const Duration(hours: 6)),
        odds: {
          'Bet365': 1.75,
          'Betfair': 1.80,
          'William Hill': 1.72,
        },
      ),
    ];
  }

  Future<List<SureBet>> findSurebets() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final events = await getEvents();
    final surebets = <SureBet>[];

    for (var i = 0; i < 3; i++) {
      final event = events[i % events.length];
      final bookmakers = event.odds.keys.toList();
      if (bookmakers.length >= 2) {
        final backOdds = event.odds[bookmakers[0]]!;
        final layOdds = event.odds[bookmakers[1]]!;
        final profitPercentage = ((1 / backOdds) + (1 / layOdds) < 1)
            ? (1 - (1 / backOdds) - (1 / layOdds)) * 100
            : 0.0;

        if (profitPercentage > 0) {
          final stake = 100.0;
          final profit = stake * profitPercentage / 100;
          surebets.add(
            SureBet(
              id: 'sb_${i + 1}',
              event: event,
              backOdds: backOdds,
              layOdds: layOdds,
              backBookmaker: bookmakers[0],
              layBookmaker: bookmakers[1],
              profitPercentage: profitPercentage,
              stake: stake,
              profit: profit,
              foundAt: DateTime.now().subtract(Duration(minutes: i * 5)),
            ),
          );
        }
      }
    }

    return surebets;
  }

  /// Calcola una surebet da quote
  SureBetCalculationResult calculateSurebet({
    required double backOdds,
    required double layOdds,
    required double stake,
  }) {
    final backStake = stake;
    final layStake = (backStake * backOdds) / layOdds;
    final totalStake = backStake + layStake;
    final backReturn = backStake * backOdds;
    final profit = backReturn - totalStake;
    final profitPercentage = (profit / totalStake) * 100;

    return SureBetCalculationResult(
      backStake: backStake,
      layStake: layStake,
      totalStake: totalStake,
      profit: profit,
      profitPercentage: profitPercentage,
      isValid: profitPercentage > 0,
    );
  }
}

/// Risultato del calcolo surebet
class SureBetCalculationResult {
  final double backStake;
  final double layStake;
  final double totalStake;
  final double profit;
  final double profitPercentage;
  final bool isValid;

  SureBetCalculationResult({
    required this.backStake,
    required this.layStake,
    required this.totalStake,
    required this.profit,
    required this.profitPercentage,
    required this.isValid,
  });
}

