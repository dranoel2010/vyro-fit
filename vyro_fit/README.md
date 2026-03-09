# VYRO Fit

**Fitness-Dashboard für Android · Health Connect · Dark-Tech UI**

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Android](https://img.shields.io/badge/Android-minSdk%2028-3DDC84?logo=android)
![Health Connect](https://img.shields.io/badge/Health%20Connect-API-4285F4?logo=google)

---

## Über die App

VYRO Fit ist ein datenschutzfreundliches Fitness-Dashboard für Android, das **Google Fit ersetzt** – insbesondere für Nutzer unter 16 Jahren, die aufgrund der GDPR-Einschränkungen keinen Zugang zu Google Fit haben.

Die App liest Gesundheitsdaten **direkt von Health Connect** – ohne Account, ohne Cloud-Synchronisation, ohne Altersbeschränkung. Alle Daten bleiben ausschließlich auf dem Gerät.

### Features

- **Aktivitäts-Dashboard** — Schritte, Kalorien, aktive Minuten, Distanz
- **Herzfrequenz** — Resting HR, 24h-Verlauf, HR-Zonen (5 Stufen), HRV-Trend
- **Schlafanalyse** — Phasenerkennung (REM, Tief, Leicht, Wach), Score, Wochentrend
- **Workouts** — 9 Trainingstypen, Wochenvolumen, Detailansicht
- **Ziele & Streaks** — Tages-Fortschritt, 30-Tage-Dot-Grid, Wochen-Score
- **Einstellungen** — Ziel-Slider, Benachrichtigungen (Schlaf, Bewegung, Streak, Wochenbericht)
- **Homescreen-Widgets** — Schritte (2×1), Aktivitäts-Score (2×2)

---

## Architektur

```
Health Connect (Android API)
        ↓
HealthService                  lib/data/services/health_service.dart
        ↓
Repositories                   lib/data/repositories/
  ├── HealthRepository          – Tages-/Wochendaten mit Cache-First
  ├── SleepRepository           – Schlafphasen-Aggregation
  ├── WorkoutRepository         – Deduplication via workoutId
  └── GoalsRepository           – Streak-Berechnung (30 Tage)
        ↓
Isar Cache                     lib/data/isar/
  └── Schemas: DailySummary, SleepSession, WorkoutSession, Goal, Streak
        ↓
Aggregation Layer              lib/data/aggregation/
  ├── DailySummaryGenerator
  ├── SleepScoreCalculator
  ├── HRZoneCalculator
  ├── TrendCalculator
  └── ChartDataBuilder
        ↓
Riverpod Provider              lib/providers/
        ↓
UI – Feature Screens           lib/features/
```

> **Architektur-Regel:** Die UI greift **niemals** direkt auf `HealthService` zu.
> Datenpfad: UI → Provider → Repository → HealthService / Isar

---

## Screens

| Tab | Screen | Inhalt |
|-----|--------|--------|
| Home | `OverviewScreen` | Aktivitäts-Score, Schritte, Kalorien, Herzfrequenz, Schlaf, letzte Workouts, Streak-Badges |
| Stats → Herz | `HeartScreen` | Resting HR + Trend, 24h-Verlauf (GlowLineChart), HR-Zonen, HRV-Proxy |
| Stats → Schlaf | `SleepScreen` | Schlaf-Score (ScoreRing), letzte Nacht (SleepPhaseBar), Wochenübersicht, Einschlafzeiten |
| Workouts | `WorkoutsScreen` | Wochenvolumen, Trainingsarten-Verteilung, 14-Tage-Liste, Detailansicht |
| Profil → Ziele | `GoalsScreen` | Streak-Card (30-Tage-Grid), Tages-Fortschritt pro Zieltyp, Wochen-Score |
| Profil → Einstellungen | `SettingsScreen` | Health Connect Status, Ziel-Slider, Notification-Toggles, App-Info |

---

## Tech Stack

| Paket | Version | Zweck |
|-------|---------|-------|
| `health` | ^10.2.0 | Health Connect Datenquelle (Schritte, HR, Schlaf, Workouts ...) |
| `flutter_riverpod` | ^2.5.1 | State Management (FutureProvider, StateNotifierProvider) |
| `isar` / `isar_flutter_libs` | ^3.1.0+1 | Lokale Datenbank (Cache, 90 Tage Retention) |
| `fl_chart` | ^0.68.0 | Charts (GlowLineChart, MiniBarChart als CustomPainter) |
| `google_fonts` | ^6.1.0 | Outfit-Schrift (Light 300 + Bold 700) |
| `flutter_local_notifications` | ^17.2.1 | Schlaf-/Aktivitäts-/Streak-Erinnerungen |
| `home_widget` | ^0.6.0 | Android Homescreen-Widgets |
| `intl` | ^0.19.0 | Deutsche Datums- und Zahlenformatierung |

---

## Setup

### Voraussetzungen

- Flutter ≥ 3.x
- Android SDK, Android-Gerät oder Emulator mit **minSdk 28** (Android 9+)
- [Health Connect](https://play.google.com/store/apps/details?id=com.google.android.apps.healthdata) auf dem Gerät installiert

### Installation

```bash
# 1. Abhängigkeiten installieren
flutter pub get

# 2. Isar-Schemas generieren (PFLICHT nach Schema-Änderungen)
dart run build_runner build --delete-conflicting-outputs

# 3. App starten
flutter run
```

> **Wichtig:** Schritt 2 (`build_runner`) ist zwingend erforderlich.
> Die `.g.dart`-Dateien für Isar werden nicht eingecheckt und müssen lokal generiert werden.

---

## Health Connect Berechtigungen

Die App fordert folgende Leserechte von Health Connect an:

| Permission | Daten |
|------------|-------|
| `READ_STEPS` | Schrittzähler |
| `READ_DISTANCE` | Zurückgelegte Distanz |
| `READ_ACTIVE_CALORIES_BURNED` | Aktiv verbrannte Kalorien |
| `READ_TOTAL_CALORIES_BURNED` | Gesamtkalorien (inkl. Grundumsatz) |
| `READ_HEART_RATE` | Herzfrequenz-Verlauf |
| `READ_RESTING_HEART_RATE` | Ruhe-Herzfrequenz |
| `READ_SLEEP` | Schlaf + Phasen (REM, Tief, Leicht, Wach) |
| `READ_EXERCISE` | Workout-Sessions |
| `READ_WEIGHT` | Körpergewicht |
| `READ_HEART_RATE_VARIABILITY_RMSSD` | Herzfrequenzvariabilität |

---

## Projektstruktur

```
lib/
├── main.dart                   App-Einstiegspunkt
├── app.dart                    MaterialApp, Navigation, Permission Gate
├── core/
│   ├── constants/              AppConstants, HealthTypes
│   ├── theme/                  VyroColors, VyroTextStyles, VyroTheme
│   └── utils/                  DateHelper, NumberFormatter
├── models/                     DailySummary, SleepData, WorkoutData, Goal, HeartRateData
├── data/
│   ├── services/               HealthService, NotificationService
│   ├── isar/                   IsarService, Schemas (*.dart + *.g.dart)
│   ├── repositories/           HealthRepository, SleepRepository, WorkoutRepository, GoalsRepository
│   └── aggregation/            DailySummaryGenerator, SleepScoreCalculator, HRZoneCalculator ...
├── providers/                  health_providers, sleep_providers, workout_providers, goal_providers
├── features/
│   ├── overview/               OverviewScreen + widgets/
│   ├── heart/                  HeartScreen + widgets/
│   ├── sleep/                  SleepScreen + widgets/
│   ├── workouts/               WorkoutsScreen, WorkoutDetailScreen + widgets/
│   ├── goals/                  GoalsScreen + widgets/
│   ├── settings/               SettingsScreen
│   └── widgets/                Homescreen-Widget Provider (StepsWidget, ScoreWidget)
└── shared/
    └── widgets/                VyroCard, MiniBarChart, MiniLineChart, GlowLineChart,
                                ProgressBar, SleepPhaseBar, ScoreRing, StatRow, LoadingCard
```

---

## Design-System

| Token | Wert | Verwendung |
|-------|------|------------|
| `background` | `#0F1115` | App-Hintergrund |
| `card` | `#171A21` | Karten-Hintergrund |
| `accent` | `#3B82F6` | Primäre Akzentfarbe, Glow-Effekte |
| `textPrimary` | `#E8E9ED` | Haupttext |
| `textSecondary` | `#5A5E6A` | Labels, Captions |
| Font | Outfit | Nur Gewichte 300 (Light) und 700 (Bold) |
| Karten-Radius | 18 px | Alle VyroCard-Instanzen |

> Alle Farben aus `VyroColors`, alle Schriftstile aus `VyroTextStyles` — keine hardcodierten Werte in Widgets.

---

## Hinweise

- **Nur Android** – kein iOS-Support (Health Connect ist Android-exklusiv)
- **minSdk 28** (Android 9 Pie) – Health Connect Mindestanforderung
- **Keine Konten, keine Telemetrie** – alle Daten bleiben auf dem Gerät
- **HR-Zonen** berechnet für Alter 15 (Max HR = 205 bpm)
- **Schlafphasen** werden nur angezeigt, wenn das gekoppelte Wearable diese Daten liefert
