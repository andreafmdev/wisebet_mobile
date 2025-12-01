/// Articolo guida
class Guide {
  final String id;
  final String title;
  final String description;
  final String content;
  final GuideCategory category;
  final bool isPremiumOnly;
  final int estimatedReadTime; // minuti
  final List<String> tags;
  final DateTime publishedAt;

  Guide({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    this.isPremiumOnly = false,
    this.estimatedReadTime = 5,
    this.tags = const [],
    required this.publishedAt,
  });
}

enum GuideCategory {
  introduction,
  surebet,
  valuebet,
  bankroll,
  tools,
  advanced,
}

