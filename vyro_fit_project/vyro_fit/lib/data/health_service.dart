import 'package:health/health.dart';
import '../core/constants/health_types.dart';
import 'models/daily_summary.dart';
import 'models/sleep_data.dart';
import 'models/workout_data.dart';

/// Abstraction Layer über Health Connect via `health` Package.
/// Zentraler Zugriffspunkt für alle Gesundheitsdaten.
class HealthService {
  final Health _health = Health();
  bool _isAuthorized = false;

  bool get isAuthorized => _isAuthorized;

  // ── Berechtigungen ──────────────────────────────────────────

  /// Fragt alle benötigten Health Connect Berechtigungen an
  Future<bool> requestPermissions() async {
    try {
      final permissions = HealthTypes.allTypes
          .map((_) => HealthDataAccess.READ)
          .toList();

      _isAuthorized = await _health.requestAuthorization(
        HealthTypes.allTypes,
        permissions: permissions,
      );
      return _isAuthorized;
    } catch (e) {
      _isAuthorized = false;
      return false;
    }
  }

  /// Prüft ob Health Connect verfügbar ist
  Future<bool> isHealthConnectAvailable() async {
    try {
      return await _health.hasPermissions(HealthTypes.allTypes) ?? false;
    } catch (_) {
      return false;
    }
  }

  // ── Rohdaten lesen ──────────────────────────────────────────

  /// Liest Health-Daten eines bestimmten Zeitraums
  Future<List<HealthDataPoint>> _fetchData({
    required DateTime start,
    required DateTime end,
    required List<HealthDataType> types,
  }) async {
    try {
      final data = await _health.getHealthDataFromTypes(
        startTime: start,
        endTime: end,
        types: types,
      );
      // Duplikate entfernen (verschiedene Apps können gleiche Daten liefern)
      return _health.removeDuplicates(data);
    } catch (e) {
      return [];
    }
  }

  // ── Tages-Zusammenfassung ───────────────────────────────────

  /// Erstellt eine Zusammenfassung für einen bestimmten Tag
  Future<DailySummary> getDailySummary(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final data = await _fetchData(
      start: start,
      end: end,
      types: HealthTypes.activity + HealthTypes.heart,
    );

    int steps = 0;
    double activeCalories = 0;
    double totalCalories = 0;
    double? restingHR;
    List<double> restingHRValues = [];

    for (final point in data) {
      final value = (point.value as NumericHealthValue).numericValue;

      switch (point.type) {
        case HealthDataType.STEPS:
          steps += value.toInt();
          break;
        case HealthDataType.ACTIVE_ENERGY_BURNED:
          activeCalories += value.toDouble();
          break;
        case HealthDataType.TOTAL_CALORIES_BURNED:
          totalCalories += value.toDouble();
          break;
        case HealthDataType.RESTING_HEART_RATE:
          restingHRValues.add(value.toDouble());
          break;
        default:
          break;
      }
    }

    if (restingHRValues.isNotEmpty) {
      restingHR = restingHRValues.reduce((a, b) => a + b) / restingHRValues.length;
    }

    return DailySummary(
      date: date,
      steps: steps,
      activeCalories: activeCalories,
      totalCalories: totalCalories,
      restingHeartRate: restingHR,
    );
  }

  /// Holt Tages-Zusammenfassungen für die letzten N Tage
  Future<List<DailySummary>> getWeeklySummaries({int days = 7}) async {
    final summaries = <DailySummary>[];
    final now = DateTime.now();

    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      summaries.add(await getDailySummary(date));
    }

    return summaries;
  }

  // ── Herzfrequenz ────────────────────────────────────────────

  /// Liest Herzfrequenz-Daten eines Zeitraums
  Future<List<(DateTime, double)>> getHeartRateData({
    required DateTime start,
    required DateTime end,
  }) async {
    final data = await _fetchData(
      start: start,
      end: end,
      types: [HealthDataType.HEART_RATE],
    );

    return data.map((point) {
      final value = (point.value as NumericHealthValue).numericValue;
      return (point.dateFrom, value.toDouble());
    }).toList();
  }

  // ── Schlaf ──────────────────────────────────────────────────

  /// Liest die letzte Schlaf-Session
  Future<SleepData?> getLastSleepSession() async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 2));

    final data = await _fetchData(
      start: start,
      end: now,
      types: HealthTypes.sleep,
    );

    if (data.isEmpty) return null;

    // Letzte Session nehmen
    final session = data.last;

    return SleepData(
      date: session.dateFrom,
      bedtime: session.dateFrom,
      wakeTime: session.dateTo,
      totalDuration: session.dateTo.difference(session.dateFrom),
    );
  }

  // ── Workouts ────────────────────────────────────────────────

  /// Liest Workouts der letzten N Tage
  Future<List<WorkoutData>> getRecentWorkouts({int days = 7}) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));

    final data = await _fetchData(
      start: start,
      end: now,
      types: HealthTypes.workouts,
    );

    return data.map((point) {
      return WorkoutData(
        id: point.uuid,
        startTime: point.dateFrom,
        endTime: point.dateTo,
        type: WorkoutType.other, // Wird über ExerciseType gemappt
        sourceName: point.sourceName,
      );
    }).toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  // ── Schritte (aggregiert) ───────────────────────────────────

  /// Liest Gesamtschritte für heute
  Future<int> getTodaySteps() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);

    try {
      final steps = await _health.getTotalStepsInInterval(start, now);
      return steps ?? 0;
    } catch (_) {
      return 0;
    }
  }
}
