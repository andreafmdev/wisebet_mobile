/// Offerta/Bonus di un bookmaker
class Offer {
  final String id;
  final String bookmaker;
  final String title;
  final String description;
  final double bonusAmount;
  final OfferType type;
  final List<String> requirements;
  final List<String> steps;
  final bool isPremiumOnly;
  final DateTime? expiresAt;
  final String? imageUrl;

  Offer({
    required this.id,
    required this.bookmaker,
    required this.title,
    required this.description,
    required this.bonusAmount,
    required this.type,
    required this.requirements,
    required this.steps,
    this.isPremiumOnly = false,
    this.expiresAt,
    this.imageUrl,
  });
}

enum OfferType {
  welcome,
  recurring,
  cashback,
  freebet,
  reload,
}

