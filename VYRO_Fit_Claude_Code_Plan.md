# VYRO Fit – Vollständiger Implementierungsplan für Claude Code

> Dieses Dokument ist der komplette Bauplan für die VYRO Fit App.
> Gib dieses Dokument an Claude Code und sage: "Implementiere VYRO Fit anhand dieses Plans, Phase für Phase."

---

## Projekt-Überblick

**Was:** Android Fitness-Dashboard App die über Health Connect alle Gesundheitsdaten ausliest und in einem eigenen Dark-Tech-UI visualisiert. Ersetzt Google Fit.

**Warum:** Google Fit ist für unter 16-Jährige in Deutschland nicht nutzbar (DSGVO). VYRO Fit liest dieselben Daten lokal über Health Connect aus – kein Account, keine Cloud, keine Altersbeschränkung.

**Datenquellen:** Amazfit Active 2 → Zepp App → Health Connect → VYRO Fit

**Tech Stack:**
- Flutter (Dart), min SDK 28, target SDK 34
- Riverpod (State Management)
- Isar (lokale Datenbank)
- health Package (Health Connect Zugriff)
- fl_chart (Charts)
- flutter_local_notifications (Benachrichtigungen)
- home_widget (Homescreen Widgets)

---

## Design-System

### Farben (STRIKT einhalten)

```dart
// Hintergrund
background: #0F1115
card: #171A21

// Akzent (einzige Farbe für Daten)
accent: #3B82F6
accentGlow: rgba(59, 130, 246, 0.4)
accentDim: rgba(59, 130, 246, 0.08)

// Text
textPrimary: #E8E9ED
textSecondary: #5A5E6A

// Spezial (nur wo nötig)
neonCyan: #22D3EE    // optional für sekundäre Daten
```

### Typografie

```
Font: Outfit (Google Fonts)
Nur 2 Gewichte: 300 (Light) und 700 (Bold)

Titel:        26px, Bold
Datenwerte:   36-44px, Bold, tabular-nums, letter-spacing: -2
Labels:       12-14px, Light, uppercase, letter-spacing: 1.2
Body:         14px, Light
Subtitles:    13px, Bold (für Akzent-Werte)
```

### Cards

```
Radius: 18px
Padding: 22px
Background: #171A21
Shadow: 0px 10px 30px rgba(0,0,0,0.35)
```

### Design-Regeln (NICHT brechen)

1. Maximal 2 Schriftstärken (300 + 700)
2. Maximal 2 Farben (Blau-Akzent + Weiß-Text)
3. Viel Whitespace
4. Gleiche Abstände überall (14px gap zwischen Cards)
5. Daten immer linksbündig
6. Graph-Linien mit Glow: box-shadow 0 0 10px rgba(59,130,246,0.5)
7. Glass-Effekt für Navigation: backdrop-filter blur(16px)
8. Card-Animationen: scale 0.96→1, opacity 0→1
9. Graph-Animationen: line draw animation

---

## Architektur

```
Health Connect → HealthService → Repository → Isar Cache → Provider → UI
```

### Verzeichnisstruktur

```
vyro_fit/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── theme/
│   │   │   ├── vyro_colors.dart
│   │   │   ├── vyro_theme.dart
│   │   │   └── vyro_text_styles.dart
│   │   ├── constants/
│   │   │   ├── health_types.dart
│   │   │   └── app_constants.dart
│   │   └── utils/
│   │       ├── date_helper.dart
│   │       └── number_formatter.dart
│   │
│   ├── data/
│   │   ├── services/
│   │   │   └── health_service.dart
│   │   ├── repositories/
│   │   │   ├── health_repository.dart
│   │   │   ├── sleep_repository.dart
│   │   │   ├── workout_repository.dart
│   │   │   └── goals_repository.dart
│   │   ├── isar/
│   │   │   ├── isar_service.dart
│   │   │   └── schemas/
│   │   │       ├── daily_summary_schema.dart
│   │   │       ├── sleep_session_schema.dart
│   │   │       ├── workout_session_schema.dart
│   │   │       ├── goal_schema.dart
│   │   │       └── streak_schema.dart
│   │   └── aggregation/
│   │       ├── daily_summary_generator.dart
│   │       ├── sleep_score_calculator.dart
│   │       ├── hr_zone_calculator.dart
│   │       ├── trend_calculator.dart
│   │       └── chart_data_builder.dart
│   │
│   ├── models/
│   │   ├── daily_summary.dart
│   │   ├── sleep_data.dart
│   │   ├── workout_data.dart
│   │   ├── heart_rate_data.dart
│   │   ├── goal.dart
│   │   ├── streak.dart
│   │   └── chart_data.dart
│   │
│   ├── providers/
│   │   ├── health_providers.dart
│   │   ├── sleep_providers.dart
│   │   ├── workout_providers.dart
│   │   ├── goal_providers.dart
│   │   └── app_state_provider.dart
│   │
│   ├── features/
│   │   ├── overview/
│   │   │   ├── overview_screen.dart
│   │   │   └── widgets/
│   │   │       ├── activity_score_card.dart
│   │   │       ├── steps_card.dart
│   │   │       ├── calories_card.dart
│   │   │       ├── heart_rate_card.dart
│   │   │       ├── sleep_summary_card.dart
│   │   │       ├── recent_workouts_card.dart
│   │   │       └── streak_badges.dart
│   │   ├── heart/
│   │   │   ├── heart_screen.dart
│   │   │   └── widgets/
│   │   │       ├── resting_hr_card.dart
│   │   │       ├── hr_timeline_card.dart
│   │   │       ├── hr_zones_card.dart
│   │   │       └── hrv_trend_card.dart
│   │   ├── sleep/
│   │   │   ├── sleep_screen.dart
│   │   │   └── widgets/
│   │   │       ├── last_night_card.dart
│   │   │       ├── sleep_score_card.dart
│   │   │       ├── sleep_week_card.dart
│   │   │       └── sleep_times_card.dart
│   │   ├── workouts/
│   │   │   ├── workouts_screen.dart
│   │   │   ├── workout_detail_screen.dart
│   │   │   └── widgets/
│   │   │       ├── workout_list_tile.dart
│   │   │       ├── weekly_volume_card.dart
│   │   │       └── workout_types_card.dart
│   │   ├── goals/
│   │   │   ├── goals_screen.dart
│   │   │   └── widgets/
│   │   │       ├── goal_progress_card.dart
│   │   │       ├── streak_card.dart
│   │   │       └── weekly_score_card.dart
│   │   └── settings/
│   │       └── settings_screen.dart
│   │
│   └── shared/
│       └── widgets/
│           ├── vyro_card.dart
│           ├── vyro_big_stat.dart
│           ├── mini_bar_chart.dart
│           ├── mini_line_chart.dart
│           ├── glow_line_chart.dart
│           ├── progress_bar.dart
│           ├── sleep_phase_bar.dart
│           ├── score_ring.dart
│           ├── stat_row.dart
│           └── loading_card.dart
│
├── android/
│   └── app/src/main/AndroidManifest.xml
│
├── pubspec.yaml
└── README.md
```

---

## Implementierung Phase für Phase

---

### PHASE 1: Projekt-Setup

#### 1.1 Flutter-Projekt erstellen

```bash
flutter create vyro_fit --org com.vyrofit
cd vyro_fit
```

#### 1.2 pubspec.yaml

```yaml
name: vyro_fit
description: VYRO Fit – Dein Health-Data-Hub
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  health: ^10.2.0
  flutter_riverpod: ^2.5.1
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  path_provider: ^2.1.2
  fl_chart: ^0.68.0
  home_widget: ^0.6.0
  flutter_local_notifications: ^17.2.1
  google_fonts: ^6.1.0
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  isar_generator: ^3.1.0+1
  build_runner: ^2.4.8
```

#### 1.3 android/app/build.gradle

```gradle
android {
    compileSdk = 34

    defaultConfig {
        applicationId = "com.vyrofit.app"
        minSdk = 28
        targetSdk = 34
    }
}
```

#### 1.4 AndroidManifest.xml – Health Connect Permissions

```xml
<uses-permission android:name="android.permission.health.READ_STEPS"/>
<uses-permission android:name="android.permission.health.READ_DISTANCE"/>
<uses-permission android:name="android.permission.health.READ_ACTIVE_CALORIES_BURNED"/>
<uses-permission android:name="android.permission.health.READ_TOTAL_CALORIES_BURNED"/>
<uses-permission android:name="android.permission.health.READ_HEART_RATE"/>
<uses-permission android:name="android.permission.health.READ_RESTING_HEART_RATE"/>
<uses-permission android:name="android.permission.health.READ_SLEEP"/>
<uses-permission android:name="android.permission.health.READ_EXERCISE"/>
<uses-permission android:name="android.permission.health.READ_WEIGHT"/>
<uses-permission android:name="android.permission.health.READ_HEART_RATE_VARIABILITY_RMSSD"/>

<!-- Intent Filter für Health Connect -->
<activity ...>
  <intent-filter>
    <action android:name="androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE"/>
  </intent-filter>
</activity>
```

#### 1.5 main.dart

```dart
// Entry Point
// - WidgetsFlutterBinding.ensureInitialized()
// - Isar initialisieren (await IsarService.init())
// - ProviderScope wrappen
// - VyroFitApp starten
```

#### 1.6 app.dart

```dart
// MaterialApp mit:
// - VyroTheme.dark als theme
// - PermissionGate als home (prüft Health Connect)
// - AppShell mit Bottom Navigation (4 Tabs: Home, Stats, Workouts, Profil)
// - IndexedStack für Tab-Persistenz
```

---

### PHASE 2: Core (Theme + Utils + Models)

#### 2.1 vyro_colors.dart

```dart
class VyroColors {
  static const background = Color(0xFF0F1115);
  static const card = Color(0xFF171A21);
  static const accent = Color(0xFF3B82F6);
  static const accentGlow = Color(0x663B82F6);  // 40% opacity
  static const accentDim = Color(0x143B82F6);   // 8% opacity
  static const textPrimary = Color(0xFFE8E9ED);
  static const textSecondary = Color(0xFF5A5E6A);

  static Color dimmed(Color c, [double opacity = 0.08]) => c.withOpacity(opacity);
}
```

#### 2.2 vyro_theme.dart

```dart
// ThemeData mit:
// - scaffoldBackgroundColor: VyroColors.background
// - Google Fonts: Outfit
// - CardTheme: radius 18, color card, elevation 0
// - AppBarTheme: transparent, kein shadow
// - BottomNavBar: transparent mit blur
// - Alle Text Styles nur weight 300 und 700
```

#### 2.3 vyro_text_styles.dart

```dart
class VyroTextStyles {
  static TextStyle title;       // 26px, w700
  static TextStyle dataValue;   // 42px, w700, tabular-nums, letterSpacing -2
  static TextStyle dataValueSm; // 36px, w700, tabular-nums
  static TextStyle label;       // 12px, w300, uppercase, letterSpacing 1.2
  static TextStyle body;        // 14px, w300
  static TextStyle sub;         // 13px, w700, accent color
  static TextStyle caption;     // 11px, w300, textSecondary
}
```

#### 2.4 app_constants.dart

```dart
class AppConstants {
  static const defaultStepGoal = 10000;
  static const defaultCalorieGoal = 560.0;
  static const defaultSleepGoal = 8.0;     // Stunden
  static const defaultWorkoutGoal = 5;      // pro Woche
  static const defaultActiveMinGoal = 30;   // Minuten pro Tag
  static const defaultStandGoal = 12;       // Stunden
  static const cardRadius = 18.0;
  static const cardPadding = 22.0;
  static const cardGap = 14.0;
}
```

#### 2.5 health_types.dart

```dart
// Liste aller HealthDataType die gelesen werden
// Gruppiert: activity, heart, sleep, workouts, body
```

#### 2.6 date_helper.dart

```dart
// Funktionen:
// - todayStart → DateTime
// - weekStart → DateTime (Montag)
// - monthStart → DateTime
// - formatHeaderDate(DateTime) → "Sonntag, 8. März"
// - formatTime(DateTime) → "10:30"
// - formatRelativeDay(DateTime) → "Heute" / "Gestern" / "Mo"
// - formatDuration(Duration) → "6h 54m"
// - lastNDays(int n) → List<DateTime>
// - shortWeekday(DateTime) → "Mo"
```

#### 2.7 number_formatter.dart

```dart
// Funktionen:
// - steps(num) → "8.421" (deutsche Formatierung)
// - calories(num) → "490"
// - bpm(num) → "61"
// - percent(double) → "87%"
// - hoursToHM(double) → "6h 54m"
// - distance(double meters) → "3,2 km"
```

#### 2.8 Models (lib/models/)

**daily_summary.dart:**
```dart
class DailySummary {
  final DateTime date;
  final int steps;
  final double activeCalories;
  final double totalCalories;
  final int activeMinutes;
  final int standHours;
  final double? restingHeartRate;
  final double? sleepHours;
  final double distanceMeters;

  // Progress-Berechnungen für Rings/Bars
  double stepsProgress(int goal);
  double moveProgress(double goal);
  double exerciseProgress(int goal);
  double standProgress(int goal);
}
```

**sleep_data.dart:**
```dart
class SleepData {
  final DateTime date;
  final DateTime bedtime;
  final DateTime wakeTime;
  final Duration totalDuration;
  final Duration? awake;
  final Duration? light;
  final Duration? deep;
  final Duration? rem;

  double get totalHours;
  Map<String, double> get phasePercentages;
  int get score;  // Berechnet durch SleepScoreCalculator
}
```

**workout_data.dart:**
```dart
class WorkoutData {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final WorkoutType type;
  final double caloriesBurned;
  final double? avgHeartRate;
  final double? maxHeartRate;
  final double? distanceMeters;
  final String? sourceName;

  Duration get duration;
  String get durationFormatted;
}

enum WorkoutType {
  strength, running, cycling, swimming, walking,
  hiking, yoga, hiit, other;

  String get label;  // Deutscher Name
  String get icon;   // Emoji
  static WorkoutType fromHealthConnect(int? type);
}
```

**heart_rate_data.dart:**
```dart
class HeartRateData {
  final DateTime timestamp;
  final double bpm;
}

class HeartRateSummary {
  final double restingHR;
  final double minHR;
  final double maxHR;
  final double avgHR;
  final List<HeartRateData> timeline;  // 24h Daten
}

enum HRZone { rest, fatBurn, cardio, peak, max }
```

**goal.dart:**
```dart
class Goal {
  final GoalType type;
  final double target;
  final double current;

  double get progress;
  bool get isCompleted;
}

enum GoalType {
  steps, calories, sleep, workoutsPerWeek, activeMinutes;
  String get label;
  String get icon;
  String get unit;
}
```

**streak.dart:**
```dart
class StreakData {
  final int currentStreak;
  final int longestStreak;
  final int weeklyGoalsCompleted;
  final double monthlyScore;
  final List<bool> last30Days;  // true = Ziel erreicht
}
```

**chart_data.dart:**
```dart
class ChartData {
  final List<double> values;
  final List<String> labels;
  final double? maxValue;
  final double? minValue;
  final double? average;
}

class WeeklyChartData {
  final ChartData steps;
  final ChartData calories;
  final ChartData heartRate;
  final ChartData sleep;
}
```

---

### PHASE 3: Isar + Repository Layer

#### 3.1 Isar Schemas (lib/data/isar/schemas/)

**daily_summary_schema.dart:**
```dart
// Isar Collection: DailySummaryEntity
// Felder: date (Index), steps, activeCalories, totalCalories,
//         activeMinutes, standHours, restingHeartRate, sleepHours, distanceMeters
// toModel() → DailySummary
// fromModel(DailySummary) → DailySummaryEntity
```

**sleep_session_schema.dart:**
```dart
// Isar Collection: SleepSessionEntity
// Felder: date (Index), bedtime, wakeTime, totalMinutes,
//         awakeMinutes, lightMinutes, deepMinutes, remMinutes
// toModel() → SleepData
```

**workout_session_schema.dart:**
```dart
// Isar Collection: WorkoutSessionEntity
// Felder: id (unique), startTime (Index), endTime, typeIndex,
//         calories, avgHR, maxHR, distanceMeters, sourceName
// toModel() → WorkoutData
```

**goal_schema.dart:**
```dart
// Isar Collection: GoalEntity
// Felder: typeIndex, target, current
```

**streak_schema.dart:**
```dart
// Isar Collection: StreakEntity
// Felder: currentStreak, longestStreak, weeklyGoalsCompleted,
//         monthlyScore, last30Days (als JSON string)
```

#### 3.2 isar_service.dart

```dart
class IsarService {
  static late Isar _isar;

  // init() – Isar öffnen mit allen Schemas, aufrufen in main.dart
  static Future<void> init();

  // CRUD für jede Entity
  Future<void> saveDailySummary(DailySummary summary);
  Future<DailySummary?> getDailySummary(DateTime date);
  Future<List<DailySummary>> getDailySummaries(DateTime start, DateTime end);

  Future<void> saveSleepSession(SleepData sleep);
  Future<SleepData?> getLastSleepSession();
  Future<List<SleepData>> getSleepSessions(DateTime start, DateTime end);

  Future<void> saveWorkout(WorkoutData workout);
  Future<List<WorkoutData>> getWorkouts(DateTime start, DateTime end);

  Future<void> saveGoals(List<Goal> goals);
  Future<List<Goal>> getGoals();

  Future<void> saveStreak(StreakData streak);
  Future<StreakData?> getStreak();

  // Cleanup: alte Daten löschen (>90 Tage)
  Future<void> cleanupOldData();
}
```

#### 3.3 health_service.dart

```dart
class HealthService {
  final Health _health = Health();

  Future<bool> requestPermissions();
  Future<bool> isAvailable();

  // Rohdaten-Zugriff (wird nur vom Repository aufgerufen, NIE von UI)
  Future<List<HealthDataPoint>> fetchRawData({
    required DateTime start,
    required DateTime end,
    required List<HealthDataType> types,
  });

  Future<int?> getTotalSteps(DateTime start, DateTime end);
}
```

#### 3.4 Repositories (lib/data/repositories/)

**health_repository.dart:**
```dart
class HealthRepository {
  final HealthService _healthService;
  final IsarService _isarService;

  // Hauptmethode: Holt Daten, aggregiert, cached
  Future<DailySummary> getTodaySummary();
  Future<List<DailySummary>> getWeeklySummaries();
  Future<List<DailySummary>> getMonthlySummaries();

  // Sync: Health Connect → Aggregation → Isar
  Future<void> syncToday();
  Future<void> syncWeek();

  // Prefetch: Alles parallel laden beim App-Start
  Future<void> prefetchAll();

  // Liest zuerst aus Cache, dann aus HC falls nötig
  Future<DailySummary> _getOrFetch(DateTime date);
}
```

**sleep_repository.dart:**
```dart
class SleepRepository {
  final HealthService _healthService;
  final IsarService _isarService;

  Future<SleepData?> getLastNight();
  Future<List<SleepData>> getWeeklySleep();
  Future<void> sync();
}
```

**workout_repository.dart:**
```dart
class WorkoutRepository {
  final HealthService _healthService;
  final IsarService _isarService;

  Future<List<WorkoutData>> getRecentWorkouts({int days = 7});
  Future<WorkoutData?> getWorkoutById(String id);
  Future<int> getWeeklyWorkoutCount();
  Future<void> sync();
}
```

**goals_repository.dart:**
```dart
class GoalsRepository {
  final IsarService _isarService;

  Future<List<Goal>> getGoals();
  Future<void> saveGoals(List<Goal> goals);
  Future<void> updateProgress(GoalType type, double value);
  Future<StreakData> getStreak();
  Future<void> updateStreak(List<DailySummary> summaries, List<Goal> goals);
}
```

---

### PHASE 4: Data Aggregation Layer

#### 4.1 daily_summary_generator.dart

```dart
class DailySummaryGenerator {
  // Nimmt Rohdaten (List<HealthDataPoint>) und erzeugt DailySummary
  static DailySummary generate(List<HealthDataPoint> rawData, DateTime date);

  // Aggregiert Schritte (summiert alle Step-Einträge)
  static int _aggregateSteps(List<HealthDataPoint> data);

  // Aggregiert Kalorien
  static double _aggregateCalories(List<HealthDataPoint> data);

  // Berechnet aktive Minuten (Perioden mit erhöhter HR oder Bewegung)
  static int _calculateActiveMinutes(List<HealthDataPoint> data);

  // Durchschnitt der Resting HR Werte
  static double? _averageRestingHR(List<HealthDataPoint> data);
}
```

#### 4.2 sleep_score_calculator.dart

```dart
class SleepScoreCalculator {
  // Berechnet Score 0-100 basierend auf:
  // - Dauer (40%): 8h = 100%, <6h = schlecht
  // - Tiefschlaf-Anteil (25%): >20% = gut
  // - REM-Anteil (20%): >20% = gut
  // - Regelmäßigkeit (15%): Einschlafzeit-Varianz über Woche
  static int calculate(SleepData sleep, {List<SleepData>? weekHistory});

  static String scoreLabel(int score);  // "Gut", "Okay", "Schlecht"
}
```

#### 4.3 hr_zone_calculator.dart

```dart
class HRZoneCalculator {
  // HR-Zonen basierend auf Alter (15 Jahre → max HR ~205)
  // Zone 1: 50-60% (Rest)
  // Zone 2: 60-70% (Fat Burn)
  // Zone 3: 70-80% (Cardio)
  // Zone 4: 80-90% (Peak)
  // Zone 5: 90-100% (Max)

  static const int userAge = 15;
  static int get maxHR => 220 - userAge;

  static HRZone getZone(double bpm);
  static Map<HRZone, Duration> calculateZoneDistribution(
    List<HeartRateData> hrData,
    Duration sampleInterval,
  );
}
```

#### 4.4 trend_calculator.dart

```dart
class TrendCalculator {
  // Woche-über-Woche Vergleich
  static double weekOverWeekChange(List<DailySummary> thisWeek, List<DailySummary> lastWeek, String metric);

  // Prozentualer Trend
  static String formatTrend(double change);  // "+12%" oder "-5%"

  // 7-Tage Durchschnitt
  static double weeklyAverage(List<double> values);

  // Trend-Richtung
  static TrendDirection direction(double change);  // up, down, stable
}

enum TrendDirection { up, down, stable }
```

#### 4.5 chart_data_builder.dart

```dart
class ChartDataBuilder {
  // Baut ChartData aus DailySummaries
  static ChartData buildStepsChart(List<DailySummary> summaries);
  static ChartData buildCaloriesChart(List<DailySummary> summaries);
  static ChartData buildSleepChart(List<SleepData> sessions);
  static ChartData buildHeartRateChart(List<DailySummary> summaries);

  // Komplett: Alle Charts auf einmal
  static WeeklyChartData buildWeeklyCharts(
    List<DailySummary> summaries,
    List<SleepData> sleepSessions,
  );

  // HR Timeline für 24h Ansicht
  static ChartData buildHRTimeline(List<HeartRateData> data);
}
```

---

### PHASE 5: Providers (Riverpod)

#### 5.1 app_state_provider.dart

```dart
// App-Start Zustand
final appInitProvider = FutureProvider<void>((ref) async {
  // 1. Isar init
  // 2. Health Connect Permissions
  // 3. Prefetch aller Daten (parallel)
  // 4. Streak aktualisieren
});
```

#### 5.2 health_providers.dart

```dart
final healthServiceProvider = Provider<HealthService>;
final isarServiceProvider = Provider<IsarService>;
final healthRepositoryProvider = Provider<HealthRepository>;

final todaySummaryProvider = FutureProvider<DailySummary>;
final weeklySummariesProvider = FutureProvider<List<DailySummary>>;
final weeklyChartsProvider = FutureProvider<WeeklyChartData>;
final todayTrendProvider = FutureProvider<String>;  // "+12%"
```

#### 5.3 sleep_providers.dart

```dart
final sleepRepositoryProvider = Provider<SleepRepository>;
final lastNightProvider = FutureProvider<SleepData?>;
final weeklySleepProvider = FutureProvider<List<SleepData>>;
final sleepScoreProvider = FutureProvider<int>;
```

#### 5.4 workout_providers.dart

```dart
final workoutRepositoryProvider = Provider<WorkoutRepository>;
final recentWorkoutsProvider = FutureProvider<List<WorkoutData>>;
final weeklyWorkoutCountProvider = FutureProvider<int>;
```

#### 5.5 goal_providers.dart

```dart
final goalsRepositoryProvider = Provider<GoalsRepository>;
final goalsProvider = StateNotifierProvider<GoalsNotifier, List<Goal>>;
final streakProvider = FutureProvider<StreakData>;
```

---

### PHASE 6: Shared Widgets

Alle Widgets in lib/shared/widgets/. ALLE müssen dem Design-System folgen.

#### 6.1 vyro_card.dart
```dart
// Container mit: card color, radius 18, padding 22, shadow
// Animiert: cardIn animation (scale 0.96→1, opacity)
// Optionaler stagger delay für Listen
```

#### 6.2 vyro_big_stat.dart
```dart
// Große Zahl (42px bold) + Unit (14px light) + optionaler Subtitle
// Font: tabular-nums, letter-spacing -2
```

#### 6.3 mini_bar_chart.dart
```dart
// Parameter: List<double> data, Color color, List<String> labels
// Vertikale Balken, letzter Balken = volle Farbe + Glow, Rest = 25% opacity
// Labels darunter (Mo Di Mi Do Fr Sa So)
// Height: 56px
```

#### 6.4 mini_line_chart.dart
```dart
// Parameter: List<double> data, Color color
// CustomPainter: Linie + Gradient-Fill darunter
// Glow-Effekt auf der Linie (shadow)
// Letzter Punkt = Dot mit Puls-Animation
```

#### 6.5 glow_line_chart.dart
```dart
// Größere Version von mini_line_chart für Detail-Screens
// Mit X-Achsen-Labels (Uhrzeiten oder Tage)
// Animated line draw
// Touch-Interaktion: Wert bei Berührung anzeigen
```

#### 6.6 progress_bar.dart
```dart
// Horizontaler Fortschrittsbalken
// Track: accentDim, Fill: accent mit Glow
// Label links, Wert rechts
// Height: 3-4px
```

#### 6.7 sleep_phase_bar.dart
```dart
// Horizontale Segmente für Schlafphasen
// Farben: REM=accent, Deep=#1E3A6E, Light=#1A2235, Awake=#2A2D38
// Mit Legende darunter
// Rounded corners
```

#### 6.8 score_ring.dart
```dart
// Kreisförmiger Score (wie im Mockup)
// CustomPainter: Track (accentDim) + Progress (accent mit Glow)
// Zahl in der Mitte (32px bold)
// Animiert: Progress fährt hoch
```

#### 6.9 stat_row.dart
```dart
// Eine Zeile: Label (links) + Wert (rechts)
// Optional: kleiner Progress-Bar darunter
```

#### 6.10 loading_card.dart
```dart
// Shimmer/Skeleton Loading State für Cards
// Gleiche Dimensionen wie echte Cards
```

---

### PHASE 7: Feature Screens

#### 7.1 Overview Screen (Home)

Layout von oben nach unten:
```
Header: "Guten Morgen" + "VYRO Fit"
StreakBadges: [12 Tage] [4 Wochen] [87%]
ActivityScoreCard: Score-Ring + Bewegen/Trainieren/Stehen Bars
Grid 2-spaltig: [Schritte + MiniBarChart] [Kalorien + MiniBarChart]
HeartRateCard: BPM + GlowLineChart (24h)
SleepSummaryCard: Dauer + PhasenBar
RecentWorkoutsCard: Letzte 3 Workouts
```

- Pull-to-Refresh: Triggert Repository sync
- Greeting dynamisch: Morgen/Tag/Abend basierend auf Uhrzeit
- Alle Daten aus Providers (nicht direkt aus Service!)

#### 7.2 Heart Screen (Stats Tab)

Layout:
```
Header: "Herzfrequenz"
RestingHRCard: Aktueller Wert + 7-Tage Trendlinie
HRTimelineCard: 24h Graph mit Glow (großer glow_line_chart)
HRZonesCard: Zonen-Verteilung als horizontale Bars
HRVTrendCard: HRV Wochenverlauf (falls verfügbar)
```

#### 7.3 Sleep Screen

Layout:
```
Header: "Schlaf"
LastNightCard: Dauer + Score + Phasen-Diagramm (großes sleep_phase_bar)
SleepScoreCard: Score-Ring + Aufschlüsselung
SleepWeekCard: 7-Tage Balkenchart (Schlafdauer)
SleepTimesCard: Einschlaf-/Aufwachzeiten Trend
```

#### 7.4 Workouts Screen

Layout:
```
Header: "Workouts"
WeeklyVolumeCard: Gesamtstunden + Bar Chart
WorkoutTypesCard: Verteilung als horizontale Bars oder Donut
WorkoutList: Scrollbare Liste aller Workouts (letzte 14 Tage)
  → Tap → WorkoutDetailScreen
```

**WorkoutDetailScreen:**
```
Workout-Typ + Icon
Dauer, Kalorien, Distanz als Stat-Rows
HR-Verlauf als glow_line_chart (falls verfügbar)
HR-Zonen Verteilung
```

#### 7.5 Goals Screen (im Profil Tab)

Layout:
```
Header: "Ziele"
StreakCard: Aktueller Streak + Longest + 30-Tage Grid
GoalProgressCards: Für jedes Ziel ein Progress-Bar mit Werten
WeeklyScoreCard: Score-Ring + Wochenübersicht
[Button: Ziele anpassen]
```

#### 7.6 Settings Screen (im Profil Tab)

Layout:
```
Profil-Header: "VYRO Fit" + Version
Sektion: Health Connect
  - Berechtigungen Status
  - Datenquellen Liste
Sektion: Ziele
  - Schritte-Ziel (Slider/Input)
  - Kalorien-Ziel
  - Schlaf-Ziel
  - Workout-Ziel
Sektion: Benachrichtigungen
  - Schlaf-Reminder Toggle + Zeit
  - Bewegungs-Reminder Toggle
  - Streak-Reminder Toggle
Sektion: App
  - Dark Mode (default an)
  - Daten zurücksetzen
  - Info
```

---

### PHASE 8: Notifications

#### 8.1 notification_service.dart

```dart
class NotificationService {
  // Init: flutter_local_notifications konfigurieren
  static Future<void> init();

  // Schlaf-Reminder: Täglich um konfigurierte Zeit
  Future<void> scheduleSleepReminder(TimeOfDay time);

  // Bewegungs-Reminder: Wenn um 15:00 weniger als 50% Schritt-Ziel
  Future<void> scheduleActivityCheck();

  // Streak-Reminder: Wenn 3 Tage kein Workout
  Future<void> checkWorkoutStreak(int daysSinceLastWorkout);

  // Wochenbericht: Sonntag 20:00
  Future<void> scheduleWeeklyReport();

  // Alle abbrechen
  Future<void> cancelAll();
}
```

---

### PHASE 9: Homescreen Widgets

#### 9.1 Schritte-Widget (2x1)

```
Zeigt: Aktuelle Schritte + Ziel + Mini Progress Bar
Update: Alle 30 Minuten
Design: Dark card background, accent für Fortschritt
```

#### 9.2 Score-Widget (2x2)

```
Zeigt: Aktivitäts-Score Ring + Schritte + Kalorien + Schlaf
Update: Alle 30 Minuten
Design: Score Ring mit Glow
```

---

### PHASE 10: Navigation & App Shell

#### Bottom Navigation (4 Tabs)

```
Home     → OverviewScreen
Stats    → HeartScreen (oder Tab-View mit Herz/Schlaf)
Workouts → WorkoutsScreen
Profil   → GoalsScreen + SettingsScreen (als scrollbare Seite oder Sub-Navigation)
```

Icons: Outline-Style, minimal. Aktiver Tab = accent color mit Glow.
Nav Background: rgba(15,17,21,0.85) mit backdrop-filter blur(16px).

---

## Reihenfolge für Claude Code

Implementiere in genau dieser Reihenfolge:

```
1. Projekt-Setup (pubspec, manifest, main.dart, app.dart)
2. Core: Theme, Colors, TextStyles, Constants, Utils
3. Models: Alle Datenmodelle
4. Isar: Schemas, IsarService (nach Schema-Erstellung: dart run build_runner build)
5. HealthService: Health Connect Zugriff
6. Repositories: Health, Sleep, Workout, Goals
7. Aggregation: Generator, Calculators, ChartDataBuilder
8. Providers: Alle Riverpod Providers
9. Shared Widgets: Alle UI-Komponenten
10. Overview Screen + Widgets
11. Heart Screen + Widgets
12. Sleep Screen + Widgets
13. Workouts Screen + Detail + Widgets
14. Goals Screen + Widgets
15. Settings Screen
16. Notifications
17. Homescreen Widgets
18. Polish: Animationen, Error States, Loading States
```

---

## Wichtige Hinweise für Claude Code

1. **NIEMALS UI direkt auf HealthService zugreifen lassen.** Immer über Repository.
2. **Isar build_runner** nach Schema-Erstellung ausführen: `dart run build_runner build`
3. **Google Fonts** für Outfit: `GoogleFonts.outfit()` in Theme
4. **Alle Farben** aus VyroColors, KEINE hardcoded Werte in Widgets
5. **Alle Text Styles** aus VyroTextStyles
6. **Card-Abstände** überall gleich: 14px gap
7. **Glow-Effekte** nur auf accent-farbige Elemente
8. **Animations**: Cards fade in mit stagger, Graphen draw-in, Score-Ring animiert hoch
9. **Error States**: Jeder Provider braucht loading + error Handling in UI
10. **Deutsche Sprache** für alle Labels und Texte in der App
11. **Prefetch beim App-Start**: Alle Daten parallel laden, nicht sequentiell
12. **Health Connect Daten deduplizieren**: `Health.removeDuplicates()` verwenden
