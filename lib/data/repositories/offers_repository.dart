import '../../domain/models/offer.dart';

/// Repository per le offerte (mock)
class OffersRepository {
  final List<Offer> _offers = [
    Offer(
      id: '1',
      bookmaker: 'Bet365',
      title: 'Bonus Benvenuto 100€',
      description: 'Deposita 100€ e ricevi 100€ di bonus',
      bonusAmount: 100,
      type: OfferType.welcome,
      requirements: [
        'Deposito minimo 10€',
        'Scommessa minima 1x il bonus',
        'Valido per nuovi clienti',
      ],
      steps: [
        'Registrati su Bet365',
        'Effettua il primo deposito',
        'Ricevi il bonus automaticamente',
        'Scommetti il bonus con quota minima 1.50',
      ],
      isPremiumOnly: false,
    ),
    Offer(
      id: '2',
      bookmaker: 'William Hill',
      title: 'Free Bet 25€',
      description: 'Free bet da 25€ per nuovi clienti',
      bonusAmount: 25,
      type: OfferType.freebet,
      requirements: [
        'Registrazione nuova',
        'Deposito minimo 10€',
      ],
      steps: [
        'Registrati su William Hill',
        'Deposita almeno 10€',
        'Ricevi la free bet',
        'Usa la free bet entro 7 giorni',
      ],
      isPremiumOnly: false,
    ),
    Offer(
      id: '3',
      bookmaker: 'Betfair',
      title: 'Cashback Settimanale',
      description: 'Ricevi il 5% di cashback su tutte le scommesse',
      bonusAmount: 0,
      type: OfferType.cashback,
      requirements: [
        'Account verificato',
        'Scommesse minime 50€/settimana',
      ],
      steps: [
        'Verifica il tuo account',
        'Scommetti almeno 50€ in una settimana',
        'Ricevi il cashback automaticamente',
      ],
      isPremiumOnly: true,
    ),
    Offer(
      id: '4',
      bookmaker: 'Unibet',
      title: 'Reload Bonus 50€',
      description: 'Bonus del 50% sul secondo deposito',
      bonusAmount: 50,
      type: OfferType.reload,
      requirements: [
        'Secondo deposito minimo 100€',
        'Codice promozionale: RELOAD50',
      ],
      steps: [
        'Effettua il secondo deposito',
        'Inserisci il codice RELOAD50',
        'Ricevi il bonus',
      ],
      isPremiumOnly: false,
    ),
  ];

  Future<List<Offer>> getOffers({bool? premiumOnly}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (premiumOnly != null) {
      return _offers.where((o) => o.isPremiumOnly == premiumOnly).toList();
    }
    return List.from(_offers);
  }

  Future<Offer?> getOfferById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _offers.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Offer>> getRecommendedOffers() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _offers.take(3).toList();
  }
}

