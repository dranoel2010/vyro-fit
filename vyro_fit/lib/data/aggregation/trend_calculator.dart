import '../../models/daily_summary.dart';

enum TrendDirection { up, down, stable }

/// Berechnet Trends für Wochenvergleiche und Durchschnitte
class TrendCalculator {
  const TrendCalculator._();

  // ── Woche-über-Woche ────────────────────────────────────────

  /// Prozentualer Unterschied dieser Woche vs. vorherige Woche
  static double weekOverWeekChange(
    List<DailySummary> thisWeek,
    List<DailySummary> lastWeek,
    double Function(DailySummary) selector,
  ) {
    if (thisWeek.isEmpty || lastWeek.isEmpty) return 0;

    final thisAvg = _average(thisWeek.map(selector).toList());
    final lastAvg = _average(lastWeek.map(selector).toList());

    if (lastAvg == 0) return 0;
    return (thisAvg - lastAvg) / lastAvg;
  }

  /// Formatiert Trend als "+12%" oder "-5%"
  static String formatTrend(double change) {
    final pct = (change * 100).round();
    if (pct > 0) return '+$pct%';
    return '$pct%';
  }

  /// Formatiert Trend mit Pfeil für UI-Anzeige
  static String formatTrendWithArrow(double change) {
    final pct = (change * 100).round();
    if (pct > 5) return '↑ +$pct% diese Woche';
    if (pct < -5) return '↓ $pct% diese Woche';
    return '~ stabil';
  }

  // ── Durchschnitte ───────────────────────────────────────────

  /// 7-Tage Durchschnitt
  static double weeklyAverage(List<double> values) {
    if (values.isEmpty) return 0;
    return _average(values);
  }

  /// Trend-Richtung
  static TrendDirection direction(double change) {
    if (change > 0.03) return TrendDirection.up;
    if (change < -0.03) return TrendDirection.down;
    return TrendDirection.stable;
  }

  // ── Spezifische Metriken ────────────────────────────────────

  static double stepsChange(
          List<DailySummary> thisWeek, List<DailySummary> lastWeek) =>
      weekOverWeekChange(
          thisWeek, lastWeek, (s) => s.steps.toDouble());

  static double caloriesChange(
          List<DailySummary> thisWeek, List<DailySummary> lastWeek) =>
      weekOverWeekChange(thisWeek, lastWeek, (s) => s.activeCalories);

  // ── Intern ──────────────────────────────────────────────────

  static double _average(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }
}
