import '../../models/sleep_data.dart';

/// Berechnet einen Schlaf-Score (0-100) basierend auf:
/// - Dauer (40%): 8h = 100%, <6h = 0%
/// - Tiefschlaf-Anteil (25%): >20% = 100%
/// - REM-Anteil (20%): >20% = 100%
/// - Regelmäßigkeit (15%): Einschlafzeit-Varianz über Woche (optional)
class SleepScoreCalculator {
  const SleepScoreCalculator._();

  static int calculate(SleepData sleep, {List<SleepData>? weekHistory}) {
    double score = 0;

    // ── Dauer (40%) ──────────────────────────────────────────
    final hours = sleep.totalHours;
    double durationScore;
    if (hours >= 8.0) {
      durationScore = 1.0;
    } else if (hours >= 7.0) {
      durationScore = 0.85 + (hours - 7.0) * 0.15;
    } else if (hours >= 6.0) {
      durationScore = 0.60 + (hours - 6.0) * 0.25;
    } else if (hours >= 5.0) {
      durationScore = 0.30 + (hours - 5.0) * 0.30;
    } else {
      durationScore = (hours / 5.0) * 0.30;
    }
    score += durationScore * 40;

    // ── Tiefschlaf (25%) ─────────────────────────────────────
    final deepPct = sleep.phasePercentages['deep'] ?? 0.0;
    final deepScore = (deepPct / 0.20).clamp(0.0, 1.0); // Ziel: 20%+
    score += deepScore * 25;

    // ── REM (20%) ────────────────────────────────────────────
    final remPct = sleep.phasePercentages['rem'] ?? 0.0;
    final remScore = (remPct / 0.20).clamp(0.0, 1.0); // Ziel: 20%+
    score += remScore * 20;

    // ── Regelmäßigkeit (15%) ─────────────────────────────────
    double regularityScore = 0.7; // Standard wenn keine Historie
    if (weekHistory != null && weekHistory.length >= 3) {
      regularityScore = _calculateRegularity(sleep, weekHistory);
    }
    score += regularityScore * 15;

    return score.round().clamp(0, 100);
  }

  /// Berechnet Regelmäßigkeit basierend auf Einschlafzeit-Varianz
  static double _calculateRegularity(
      SleepData night, List<SleepData> history) {
    if (history.isEmpty) return 0.7;

    // Durchschnittliche Einschlafzeit (in Minuten ab Mitternacht)
    final bedtimes = history
        .map((s) => s.bedtime.hour * 60 + s.bedtime.minute)
        .toList();

    final avg = bedtimes.reduce((a, b) => a + b) / bedtimes.length;
    final variance = bedtimes
        .map((b) => (b - avg) * (b - avg))
        .reduce((a, b) => a + b) / bedtimes.length;
    final stdDev = variance > 0 ? variance / 60 : 0; // in Stunden

    // Weniger als 30min Varianz = perfekt, mehr als 2h = schlecht
    if (stdDev < 0.5) return 1.0;
    if (stdDev < 1.0) return 0.8;
    if (stdDev < 2.0) return 0.5;
    return 0.2;
  }

  /// Gibt ein lesbares Label für den Score zurück
  static String scoreLabel(int score) {
    if (score >= 85) return 'Ausgezeichnet';
    if (score >= 70) return 'Gut';
    if (score >= 55) return 'Okay';
    if (score >= 40) return 'Mäßig';
    return 'Schlecht';
  }
}
