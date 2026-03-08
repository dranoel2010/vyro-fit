# VYRO Fit

> Alle Gesundheitsdaten an einem Ort. Ohne Google Fit.

## Setup

### 1. Flutter-Projekt erstellen

```bash
flutter create vyro_fit
cd vyro_fit
```

### 2. Dateien reinkopieren

Kopiere den gesamten Inhalt des `lib/` Ordners in dein neues Projekt.
Ersetze `pubspec.yaml` mit der mitgelieferten Version.

### 3. Dependencies installieren

```bash
flutter pub get
```

### 4. Android konfigurieren

**`android/app/build.gradle`:**
```gradle
android {
    compileSdk = 34

    defaultConfig {
        minSdk = 28
        targetSdk = 34
    }
}
```

**`android/app/src/main/AndroidManifest.xml`:**
Füge die Health Connect Permissions aus `android/health_connect_permissions.xml` ein.

### 5. App starten

```bash
flutter run
```

Beim ersten Start fragt die App nach Health Connect Berechtigungen.
Health Connect muss auf dem Gerät installiert sein (ab Android 14 vorinstalliert).

## Projektstruktur

```
lib/
├── main.dart                          # Entry Point
├── app.dart                           # App Shell + Navigation + Permission Gate
├── core/
│   ├── theme/
│   │   ├── vyro_colors.dart           # Farbkonstanten
│   │   └── vyro_theme.dart            # Material 3 Theme
│   ├── constants/
│   │   └── health_types.dart          # Health Connect Typ-Mappings
│   └── utils/
│       ├── date_helper.dart           # Datums-Funktionen
│       └── number_formatter.dart      # Zahlen-Formatting
├── data/
│   ├── health_service.dart            # Health Connect Abstraction
│   └── models/
│       ├── daily_summary.dart         # Tages-Zusammenfassung
│       ├── sleep_data.dart            # Schlaf-Session
│       ├── workout_data.dart          # Workout + Typen
│       └── goal.dart                  # Ziele + Streaks
├── features/
│   ├── overview/
│   │   ├── overview_screen.dart       # Dashboard / Home
│   │   └── widgets/
│   │       └── activity_rings.dart    # Apple Watch Style Rings
│   ├── heart/                         # TODO
│   ├── sleep/                         # TODO
│   ├── training/                      # TODO
│   ├── goals/                         # TODO
│   └── settings/                      # TODO
└── shared/
    ├── widgets/
    │   └── vyro_card.dart             # Wiederverwendbare UI-Komponenten
    └── providers/
        └── health_providers.dart      # Riverpod State Management
```

## Nächste Schritte

- [ ] Mini-Charts (Bar + Line) als Flutter Widgets
- [ ] Schlaf-Screen implementieren
- [ ] Herz-Screen implementieren  
- [ ] Training-Screen implementieren
- [ ] Ziele-Screen implementieren
- [ ] Isar Caching für Offline-Zugriff
- [ ] Homescreen Widgets
- [ ] Dark Mode
