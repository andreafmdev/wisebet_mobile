/// Voce di profitto/perdita
class ProfitEntry {
  final String id;
  final DateTime date;
  final ProfitType type;
  final double amount;
  final String description;
  final String? offerId;
  final String? surebetId;

  ProfitEntry({
    required this.id,
    required this.date,
    required this.type,
    required this.amount,
    required this.description,
    this.offerId,
    this.surebetId,
  });
}

enum ProfitType {
  welcomeOffer,
  recurringOffer,
  surebet,
  valuebet,
  manual,
}

