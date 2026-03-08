import 'package:health/health.dart';
import '../../models/daily_summary.dart';

/// Aggregiert Health Connect Rohdaten zu einer DailySummary.
/// Wird vom HealthRepository aufgerufen.
class DailySummaryGenerator {
  const DailySummaryGenerator._();

  /// Generiert eine DailySummary aus einer Liste von HealthDataPoints.
  static DailySummary generate(
    List<HealthDataPoint> rawData,
    DateTime date, {
    int? totalStepsOverride, // Von getTotalStepsInInterval (genauer)
  }) {
    int steps = totalStepsOverride ?? 0;
    double activeCalories = 0;
    double totalCalories = 0;
    double distanceMeters = 0;
    final List<double> restingHRValues = [];
    final List<HealthDataPoint> hrPoints = [];

    for (final point in rawData) {
      if (point.value is! NumericHealthValue) continue;
      final value = (point.value as NumericHealthValue).numericValue.toDouble();

      switch (point.type) {
        case HealthDataType.STEPS:
          // Nur summieren wenn kein Override vorhanden
          if (totalStepsOverride == null) steps += value.toInt();
        case HealthDataType.ACTIVE_ENERGY_BURNED:
          activeCalories += value;
        case HealthDataType.TOTAL_CALORIES_BURNED:
          totalCalories += value;
        case HealthDataType.DISTANCE_DELTA:
          distanceMeters += value;
        case HealthDataType.RESTING_HEART_RATE:
          restingHRValues.add(value);
        case HealthDataType.HEART_RATE:
          hrPoints.add(point);
        default:
          break;
      }
    }

    // Ruhe-HR: Mittelwert aller Messungen
    double? restingHR;
    if (restingHRValues.isNotEmpty) {
      restingHR =
          restingHRValues.reduce((a, b) => a + b) / restingHRValues.length;
    }

    // Aktive Minuten: Perioden wo HR > 100 bpm (grobe Schätzung)
    final activeMinutes = _calculateActiveMinutes(hrPoints);

    return DailySummary(
      date: DateTime(date.year, date.month, date.day),
      steps: steps,
      activeCalories: activeCalories,
      totalCalories: totalCalories,
      activeMinutes: activeMinutes,
      standHours: 0, // Health Connect liefert keine Stand-Stunden direkt
      restingHeartRate: restingHR,
      distanceMeters: distanceMeters,
    );
  }

  /// Schätzt aktive Minuten aus HR-Daten (HR > 100 bpm = aktiv)
  static int _calculateActiveMinutes(List<HealthDataPoint> hrPoints) {
    if (hrPoints.length < 2) return 0;

    // Sortieren nach Zeit
    hrPoints.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

    int activeSeconds = 0;
    for (int i = 0; i < hrPoints.length - 1; i++) {
      final current = hrPoints[i];
      final next = hrPoints[i + 1];
      final bpm =
          (current.value as NumericHealthValue).numericValue.toDouble();
      final gap = next.dateFrom.difference(current.dateFrom).inSeconds;

      // Nur Lücken bis 5 Minuten berücksichtigen (danach kein Tracking)
      if (gap <= 300 && bpm > 100) {
        activeSeconds += gap;
      }
    }

    return activeSeconds ~/ 60;
  }
}
