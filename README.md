# WiseBet - Matched Betting Companion App

WiseBet è un'app Flutter per mobile (iOS + Android) che funge da companion per il matched betting, simile a NinjaBet ma completamente originale.

## 🎯 Funzionalità

### MVP Implementato

- ✅ **Dashboard Profitti**: Visualizzazione dei profitti totali, mensili e grafici di andamento
- ✅ **Gestione Offerte/Bonus**: Lista di offerte dei bookmaker con dettagli e procedure step-by-step
- ✅ **Strumenti SureBet/ValueBet**: 
  - Scanner per trovare surebet disponibili
  - Calcolatore interattivo per calcolare puntate e profitti
- ✅ **Profit Tracker**: Tracciamento completo delle operazioni con filtri e grafici
- ✅ **Sezione Guide**: Guide complete su matched betting, surebet, valuebet e gestione bankroll
- ✅ **Sistema Premium Mock**: Sistema di sottoscrizione premium (senza pagamenti reali)

## 🏗️ Architettura

Il progetto segue una **Clean Architecture light**:

```
lib/
├── core/                    # Componenti condivisi
│   ├── theme/              # Tema, colori, tipografia
│   ├── widgets/            # Widget riutilizzabili
│   ├── providers/          # Provider Riverpod
│   ├── router/             # Configurazione navigazione
│   └── error/              # Gestione errori
├── domain/                 # Modelli di dominio
│   └── models/            # User, Offer, SureBet, ecc.
├── data/                   # Repository e dati mock
│   └── repositories/      # Repository con dati fake
└── features/               # Feature modules
    ├── auth/              # Autenticazione e onboarding
    ├── dashboard/         # Dashboard principale
    ├── offers/            # Gestione offerte
    ├── surebets/          # Scanner surebet
    ├── calculator/        # Calcolatore
    ├── profit_tracker/    # Tracciamento profitti
    ├── guides/            # Guide e tutorial
    └── profile/           # Profilo e premium
```

## 🛠️ Stack Tecnologico

- **Flutter 3.x** con Dart null-safety
- **Riverpod** per state management
- **go_router** per navigazione con animazioni
- **fl_chart** per grafici
- **intl** per formattazione date

## 🚀 Installazione e Avvio

### Prerequisiti

- Flutter SDK 3.10.1 o superiore
- Dart SDK
- Android Studio / Xcode per emulatori

### Setup

1. **Installa le dipendenze**:
```bash
flutter pub get
```

2. **Avvia l'app**:
```bash
flutter run
```

L'app si avvierà con:
- Onboarding iniziale (3 schermate)
- Login/Registrazione mock (accetta qualsiasi credenziale)
- Possibilità di entrare come Guest

## 📱 Schermate Principali

### 1. Onboarding
- 3 schermate introduttive con animazioni
- Skip disponibile

### 2. Login/Registrazione
- Validazione base dei campi
- Login come Guest disponibile
- Mock: accetta qualsiasi credenziale

### 3. Dashboard
- Statistiche profitti (totale e mensile)
- Grafico andamento profitti
- Quick actions (SureBet, Calcolatore, Guide, Offerte)
- Offerte consigliate

### 4. Offerte
- Lista completa offerte bookmaker
- Dettaglio con procedure step-by-step
- Filtro premium/free
- Link diretto al calcolatore

### 5. SureBet
- Lista surebet trovate automaticamente
- Dettaglio quote back/lay
- Profitto atteso
- Pulsante calcolatore

### 6. Calcolatore
- Input quote back/lay e stake
- Calcolo in tempo reale
- Visualizzazione puntate ottimali
- Profitto e rendimento %

### 7. Profit Tracker
- Lista operazioni con filtri
- Grafico andamento
- Aggiunta manuale operazioni
- Filtri per tipo e periodo

### 8. Guide
- Lista guide per categoria
- Dettaglio con contenuto markdown
- Filtro premium/free

### 9. Profilo
- Informazioni utente
- Gestione tema (dark/light)
- Gestione lingua (IT/EN)
- Upgrade a Premium

## 🎨 Design

L'app utilizza un design **premium** con:
- Gradienti profondi (blu notte / viola / teal)
- Card con angoli arrotondati e ombre morbide
- Effetti glassmorphism
- Animazioni fluide
- Palette colori premium (dark navy + accent gold/teal)

## 🧪 Test

Sono inclusi test unitari per:
- Calcolatore SureBet (`test/calculator_test.dart`)
- Profit Tracker (`test/profit_tracker_test.dart`)

Esegui i test con:
```bash
flutter test
```

## 📝 Note Importanti

- **Nessun backend reale**: Tutti i dati sono mockati in memoria
- **Nessun pagamento reale**: Il sistema premium è completamente mockato
- **Nessuna connessione a bookmaker**: Tutti i dati sono simulati
- **Dati di esempio**: I repository contengono dati mock per dimostrazione

## 🔐 Credenziali Mock

Per il login/registrazione:
- Email: qualsiasi email valida (es: `test@example.com`)
- Password: minimo 6 caratteri
- Il sistema accetta qualsiasi credenziale valida

## 📦 Dipendenze Principali

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  go_router: ^14.6.1
  fl_chart: ^0.69.0
  intl: ^0.19.0
```

## 🚧 Prossimi Sviluppi Possibili

- Integrazione con API reali
- Sistema di notifiche push
- Sincronizzazione cloud
- Export report PDF
- Integrazione pagamenti reali
- Supporto multi-lingua completo
- Dark/Light theme toggle funzionante

## 📄 Licenza

Questo progetto è un esempio/MVP e non include alcuna proprietà intellettuale copiata da altri brand.

---

**Sviluppato con ❤️ usando Flutter**
