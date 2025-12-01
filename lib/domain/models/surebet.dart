/// SureBet trovata
class SureBet {
  final String id;
  final BetEvent event;
  final double backOdds;
  final double layOdds;
  final String backBookmaker;
  final String layBookmaker;
  final double profitPercentage;
  final double stake;
  final double profit;
  final DateTime foundAt;

  SureBet({
    required this.id,
    required this.event,
    required this.backOdds,
    required this.layOdds,
    required this.backBookmaker,
    required this.layBookmaker,
    required this.profitPercentage,
    required this.stake,
    required this.profit,
    required this.foundAt,
  });
}

/// Evento sportivo
class BetEvent {
  final String id;
  final String sport;
  final String league;
  final String homeTeam;
  final String awayTeam;
  final DateTime startTime;
  final Map<String, double> odds; // bookmaker -> odds

  BetEvent({
    required this.id,
    required this.sport,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.startTime,
    required this.odds,
  });
}

