/// App-weite Konstanten für VYRO Fit
class AppConstants {
  AppConstants._();

  // ── Standard-Ziele ────────────────────────────────────────
  static const int defaultStepGoal = 10000;
  static const double defaultCalorieGoal = 560.0;
  static const double defaultSleepGoal = 8.0;     // Stunden
  static const int defaultWorkoutGoal = 5;          // pro Woche
  static const int defaultActiveMinGoal = 30;       // Minuten pro Tag
  static const int defaultStandGoal = 12;           // Stunden

  // ── Design-Konstanten ─────────────────────────────────────
  static const double cardRadius = 18.0;
  static const double cardPadding = 22.0;
  static const double cardGap = 14.0;
  static const double screenPadding = 16.0;

  // ── Cache-Konfiguration ───────────────────────────────────
  static const int cacheRetentionDays = 90;
  static const int syncIntervalMinutes = 30;

  // ── HR-Zonen (Alter 15 → Max HR 205) ─────────────────────
  static const int userAge = 15;
  static int get maxHR => 220 - userAge; // = 205

  // ── App-Info ──────────────────────────────────────────────
  static const String appVersion = '1.0.0';
  static const String appName = 'VYRO Fit';
}
