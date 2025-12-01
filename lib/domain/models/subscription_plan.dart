/// Piano di sottoscrizione
class SubscriptionPlan {
  final String id;
  final String name;
  final double price;
  final int durationMonths;
  final List<String> benefits;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.durationMonths,
    required this.benefits,
  });
}

