import '../../domain/models/subscription_plan.dart';

/// Repository per le sottoscrizioni (mock)
class SubscriptionRepository {
  final List<SubscriptionPlan> _plans = [
    SubscriptionPlan(
      id: 'monthly',
      name: 'Premium Mensile',
      price: 19.99,
      durationMonths: 1,
      benefits: [
        'Accesso completo a tutti gli strumenti',
        'Guide avanzate esclusive',
        'Notifiche in tempo reale per surebet',
        'Supporto prioritario',
        'Statistiche dettagliate',
      ],
    ),
    SubscriptionPlan(
      id: 'annual',
      name: 'Premium Annuale',
      price: 199.99,
      durationMonths: 12,
      benefits: [
        'Tutti i vantaggi del piano mensile',
        'Risparmio del 17% rispetto al mensile',
        'Accesso anticipato alle nuove funzionalità',
        'Report personalizzati mensili',
        'Consulenza strategica dedicata',
      ],
    ),
  ];

  Future<List<SubscriptionPlan>> getPlans() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_plans);
  }

  Future<SubscriptionPlan?> getPlanById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _plans.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Mock: simula l'acquisto di un piano (senza pagamento reale)
  Future<bool> subscribeToPlan(String planId) async {
    await Future.delayed(const Duration(seconds: 1));
    // In un'app reale, qui ci sarebbe la logica di pagamento
    return true;
  }
}

