import '../../domain/models/guide.dart';

/// Repository per le guide (mock)
class GuidesRepository {
  final List<Guide> _guides = [
    Guide(
      id: '1',
      title: 'Introduzione al Matched Betting',
      description: 'Scopri come trasformare i bonus dei bookmaker in profitto garantito',
      content: '''
# Introduzione al Matched Betting

Il matched betting è una tecnica che permette di sfruttare i bonus offerti dai bookmaker per ottenere profitti garantiti, senza rischi.

## Come funziona?

1. **Registrazione**: Ti registri su un bookmaker che offre un bonus di benvenuto
2. **Deposito**: Effettui un deposito minimo
3. **Scommessa**: Piazzi una scommessa "back" (a favore) e una "lay" (contro) su un exchange
4. **Profitto**: Indipendentemente dall'esito, ottieni un profitto garantito

## Vantaggi

- Profitti garantiti
- Nessun rischio
- Puoi iniziare con capitali limitati
- Tecnica legale e sicura

## Requisiti

- Account su bookmaker
- Account su exchange (es. Betfair)
- Capitale iniziale (consigliato: 200-500€)
      ''',
      category: GuideCategory.introduction,
      isPremiumOnly: false,
      estimatedReadTime: 10,
      tags: ['base', 'introduzione', 'guida'],
      publishedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Guide(
      id: '2',
      title: 'Come trovare e sfruttare le SureBet',
      description: 'Guida completa per identificare e calcolare le surebet',
      content: '''
# Come trovare e sfruttare le SureBet

Le surebet sono combinazioni di quote che garantiscono un profitto indipendentemente dall'esito.

## Cosa sono le SureBet?

Una surebet si verifica quando la somma degli inversi delle quote è inferiore a 1.

Formula: (1/quota1) + (1/quota2) < 1

## Esempio pratico

- Bookmaker A: Quota 2.10 per la vittoria della squadra A
- Bookmaker B: Quota 2.20 per la vittoria della squadra B

Calcolo:
- (1/2.10) + (1/2.20) = 0.476 + 0.455 = 0.931 < 1 ✓

## Come calcolare le puntate

Usa il calcolatore integrato nell'app per determinare automaticamente le puntate ottimali.
      ''',
      category: GuideCategory.surebet,
      isPremiumOnly: false,
      estimatedReadTime: 15,
      tags: ['surebet', 'calcolo', 'avanzato'],
      publishedAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Guide(
      id: '3',
      title: 'Gestione del Bankroll',
      description: 'Strategie per gestire efficacemente il tuo capitale',
      content: '''
# Gestione del Bankroll

Una corretta gestione del bankroll è essenziale per il successo nel matched betting.

## Regole fondamentali

1. **Non scommettere più del 5% del bankroll su una singola operazione**
2. **Mantieni sempre un fondo di emergenza**
3. **Traccia tutte le operazioni**
4. **Rivaluta regolarmente la tua strategia**

## Calcolo del bankroll minimo

Per iniziare con sicurezza, ti consigliamo un bankroll minimo di 200-500€.
      ''',
      category: GuideCategory.bankroll,
      isPremiumOnly: true,
      estimatedReadTime: 12,
      tags: ['bankroll', 'strategia', 'premium'],
      publishedAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Guide(
      id: '4',
      title: 'ValueBet: Identificare le quote sottovalutate',
      description: 'Scopri come trovare scommesse con valore positivo',
      content: '''
# ValueBet: Identificare le quote sottovalutate

Le valuebet sono scommesse dove la probabilità reale è superiore a quella implicita nella quota.

## Come identificare una ValueBet

1. Analizza le statistiche
2. Confronta le quote di diversi bookmaker
3. Usa modelli di calcolo delle probabilità
4. Verifica la value con la formula: (Quota × Probabilità) - 1 > 0

## Vantaggi

- Profitti potenzialmente più alti
- Maggiore controllo sulle scommesse
- Possibilità di specializzarsi in sport specifici
      ''',
      category: GuideCategory.valuebet,
      isPremiumOnly: true,
      estimatedReadTime: 20,
      tags: ['valuebet', 'analisi', 'premium'],
      publishedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  Future<List<Guide>> getGuides({
    GuideCategory? category,
    bool? premiumOnly,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    var filtered = List<Guide>.from(_guides);

    if (category != null) {
      filtered = filtered.where((g) => g.category == category).toList();
    }
    if (premiumOnly != null) {
      filtered = filtered.where((g) => g.isPremiumOnly == premiumOnly).toList();
    }

    return filtered;
  }

  Future<Guide?> getGuideById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _guides.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<GuideCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return GuideCategory.values;
  }
}

