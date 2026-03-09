import '../../core/utils/date_helper.dart';
import '../../models/daily_summary.dart';
import '../../models/heart_rate_data.dart';
import '../../models/sleep_data.dart';

/// Baut ChartData-Objekte aus Rohdaten-Listen für die UI-Charts
class ChartDataBuilder {
  const ChartDataBuilder._();

  // ── Wochen-Charts ────────────────────────────────────────────

  static ChartData buildStepsChart(List<DailySummary> summaries) {
    return ChartData(
      values: summaries.map((s) => s.steps.toDouble()).toList(),
      labels: summaries.map((s) => DateHelper.shortWeekday(s.date)).toList(),
      maxValue: summaries.isEmpty
          ? 10000
          : summaries.map((s) => s.steps.toDouble()).reduce((a, b) => a > b ? a : b),
      average: summaries.isEmpty
          ? 0
          : summaries.map((s) => s.steps.toDouble()).reduce((a, b) => a + b) /
              summaries.length,
    );
  }

  static ChartData buildCaloriesChart(List<DailySummary> summaries) {
    return ChartData(
      values: summaries.map((s) => s.activeCalories).toList(),
      labels: summaries.map((s) => DateHelper.shortWeekday(s.date)).toList(),
      maxValue: summaries.isEmpty
          ? 600
          : summaries.map((s) => s.activeCalories).reduce((a, b) => a > b ? a : b),
      average: summaries.isEmpty
          ? 0
          : summaries.map((s) => s.activeCalories).reduce((a, b) => a + b) /
              summaries.length,
    );
  }

  static ChartData buildSleepChart(List<SleepData> sessions) {
    return ChartData(
      values: sessions.map((s) => s.totalHours).toList(),
      labels: sessions.map((s) => DateHelper.shortWeekday(s.date)).toList(),
      maxValue: 10,
      minValue: 0,
      average: sessions.isEmpty
          ? 0
          : sessions.map((s) => s.totalHours).reduce((a, b) => a + b) /
              sessions.length,
    );
  }

  static ChartData buildHeartRateChart(List<DailySummary> summaries) {
    final values = summaries
        .map((s) => s.restingHeartRate ?? 0.0)
        .toList();
    final nonZero = values.where((v) => v > 0).toList();
    return ChartData(
      values: values,
      labels: summaries.map((s) => DateHelper.shortWeekday(s.date)).toList(),
      maxValue: nonZero.isEmpty ? 100 : nonZero.reduce((a, b) => a > b ? a : b) + 10,
      minValue: nonZero.isEmpty ? 40 : nonZero.reduce((a, b) => a < b ? a : b) - 10,
      average: nonZero.isEmpty
          ? 0
          : nonZero.reduce((a, b) => a + b) / nonZero.length,
    );
  }

  /// Alle 4 Charts auf einmal (effizienter)
  static WeeklyChartData buildWeeklyCharts(
    List<DailySummary> summaries,
    List<SleepData> sleepSessions,
  ) {
    return WeeklyChartData(
      steps: buildStepsChart(summaries),
      calories: buildCaloriesChart(summaries),
      heartRate: buildHeartRateChart(summaries),
      sleep: buildSleepChart(sleepSessions),
    );
  }

  // ── HR Timeline ──────────────────────────────────────────────

  /// 24h HR-Timeline für den Heart-Screen
  static ChartData buildHRTimeline(List<HeartRateData> data) {
    if (data.isEmpty) {
      return const ChartData(values: [], labels: []);
    }

    // Auf stündliche Punkte reduzieren (für Performance)
    final hourly = <int, List<double>>{};
    for (final point in data) {
      final hour = point.timestamp.hour;
      hourly.putIfAbsent(hour, () => []).add(point.bpm);
    }

    final values = <double>[];
    final labels = <String>[];

    for (int h = 0; h < 24; h++) {
      final bpms = hourly[h];
      if (bpms != null && bpms.isNotEmpty) {
        values.add(bpms.reduce((a, b) => a + b) / bpms.length);
      } else {
        values.add(0);
      }
      labels.add(h % 6 == 0 ? '${h.toString().padLeft(2, '0')}:00' : '');
    }

    final nonZero = values.where((v) => v > 0).toList();
    return ChartData(
      values: values,
      labels: labels,
      maxValue: nonZero.isEmpty ? 120 : nonZero.reduce((a, b) => a > b ? a : b) + 10,
      minValue: nonZero.isEmpty ? 40 : nonZero.reduce((a, b) => a < b ? a : b) - 5,
      average: nonZero.isEmpty
          ? 0
          : nonZero.reduce((a, b) => a + b) / nonZero.length,
    );
  }
}
