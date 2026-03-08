import 'package:health/health.dart';
import '../../core/constants/health_types.dart';
import '../../models/workout_data.dart';
import '../isar/isar_service.dart';
import '../services/health_service.dart';

/// Repository für Workout-Daten.
class WorkoutRepository {
  final HealthService _healthService;
  final IsarService _isarService;

  const WorkoutRepository(this._healthService, this._isarService);

  // ── Letzte Workouts ──────────────────────────────────────────

  Future<List<WorkoutData>> getRecentWorkouts({int days = 7}) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));

    final cached = await _isarService.getWorkouts(start, now);
    if (cached.isNotEmpty) return cached;

    await sync(days: days);
    return _isarService.getWorkouts(start, now);
  }

  Future<WorkoutData?> getWorkoutById(String id) async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 30));
    final workouts = await _isarService.getWorkouts(start, now);
    try {
      return workouts.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Anzahl Workouts diese Woche
  Future<int> getWeeklyWorkoutCount() async {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final weekStart = DateTime(monday.year, monday.month, monday.day);
    final workouts = await _isarService.getWorkouts(weekStart, now);
    return workouts.length;
  }

  // ── Sync ─────────────────────────────────────────────────────

  Future<void> sync({int days = 14}) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));

    final rawData = await _healthService.fetchRawData(
      start: start,
      end: now,
      types: HealthTypes.workouts,
    );

    for (final point in rawData) {
      final workout = _parseWorkout(point);
      if (workout != null) await _isarService.saveWorkout(workout);
    }
  }

  // ── Parsing ──────────────────────────────────────────────────

  WorkoutData? _parseWorkout(HealthDataPoint point) {
    if (point.type != HealthDataType.WORKOUT) return null;

    double calories = 0;
    WorkoutType type = WorkoutType.other;

    if (point.value is WorkoutHealthValue) {
      final value = point.value as WorkoutHealthValue;
      calories = value.totalEnergyBurned?.toDouble() ?? 0;
      type = WorkoutType.fromHealthConnect(value.workoutActivityType.index);
    }

    return WorkoutData(
      id: point.uuid,
      startTime: point.dateFrom,
      endTime: point.dateTo,
      type: type,
      caloriesBurned: calories,
      sourceName: point.sourceName,
    );
  }
}
