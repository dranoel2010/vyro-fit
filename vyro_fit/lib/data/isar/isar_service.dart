import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/daily_summary.dart';
import '../../models/goal.dart';
import '../../models/sleep_data.dart';
import '../../models/workout_data.dart';
import 'schemas/daily_summary_schema.dart';
import 'schemas/goal_schema.dart';
import 'schemas/sleep_session_schema.dart';
import 'schemas/streak_schema.dart';
import 'schemas/workout_session_schema.dart';

/// Lokaler Daten-Cache via Isar.
/// Alle Daten werden hier gecacht, bevor Health Connect abgefragt wird.
/// WICHTIG: Nur von Repositories verwenden, NIE direkt aus der UI!
class IsarService {
  static late Isar _isar;
  static bool _initialized = false;

  /// Muss in main() vor runApp() aufgerufen werden.
  static Future<void> init() async {
    if (_initialized) return;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        DailySummaryEntitySchema,
        SleepSessionEntitySchema,
        WorkoutSessionEntitySchema,
        GoalEntitySchema,
        StreakEntitySchema,
      ],
      directory: dir.path,
      name: 'vyro_fit_cache',
    );
    _initialized = true;
  }

  // ── DailySummary ────────────────────────────────────────────

  Future<void> saveDailySummary(DailySummary summary) async {
    final entity = DailySummaryEntity.fromModel(summary);
    await _isar.writeTxn(() async {
      // Bestehenden Eintrag für diesen Tag ersetzen
      final existing = await _isar.dailySummaryEntitys
          .where()
          .dateEpochDayEqualTo(entity.dateEpochDay)
          .findFirst();
      if (existing != null) entity.id = existing.id;
      await _isar.dailySummaryEntitys.put(entity);
    });
  }

  Future<DailySummary?> getDailySummary(DateTime date) async {
    final epochDay =
        date.millisecondsSinceEpoch ~/ const Duration(days: 1).inMilliseconds;
    final entity = await _isar.dailySummaryEntitys
        .where()
        .dateEpochDayEqualTo(epochDay)
        .findFirst();
    return entity?.toModel();
  }

  Future<List<DailySummary>> getDailySummaries(
      DateTime start, DateTime end) async {
    final startEpoch =
        start.millisecondsSinceEpoch ~/ const Duration(days: 1).inMilliseconds;
    final endEpoch =
        end.millisecondsSinceEpoch ~/ const Duration(days: 1).inMilliseconds;
    final entities = await _isar.dailySummaryEntitys
        .where()
        .dateEpochDayBetween(startEpoch, endEpoch)
        .findAll();
    return entities.map((e) => e.toModel()).toList();
  }

  // ── SleepData ───────────────────────────────────────────────

  Future<void> saveSleepSession(SleepData sleep) async {
    await _isar.writeTxn(() async {
      await _isar.sleepSessionEntitys
          .put(SleepSessionEntity.fromModel(sleep));
    });
  }

  Future<SleepData?> getLastSleepSession() async {
    final entity = await _isar.sleepSessionEntitys
        .where()
        .sortByDateDesc()
        .findFirst();
    return entity?.toModel();
  }

  Future<List<SleepData>> getSleepSessions(
      DateTime start, DateTime end) async {
    final entities = await _isar.sleepSessionEntitys
        .filter()
        .dateBetween(start, end)
        .findAll();
    return entities.map((e) => e.toModel()).toList();
  }

  // ── WorkoutData ─────────────────────────────────────────────

  Future<void> saveWorkout(WorkoutData workout) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.workoutSessionEntitys
          .where()
          .workoutIdEqualTo(workout.id)
          .findFirst();
      final entity = WorkoutSessionEntity.fromModel(workout);
      if (existing != null) entity.id = existing.id;
      await _isar.workoutSessionEntitys.put(entity);
    });
  }

  Future<List<WorkoutData>> getWorkouts(DateTime start, DateTime end) async {
    final entities = await _isar.workoutSessionEntitys
        .filter()
        .startTimeBetween(start, end)
        .sortByStartTimeDesc()
        .findAll();
    return entities.map((e) => e.toModel()).toList();
  }

  // ── Goals ───────────────────────────────────────────────────

  Future<void> saveGoals(List<Goal> goals) async {
    await _isar.writeTxn(() async {
      for (final goal in goals) {
        await _isar.goalEntitys.put(GoalEntity.fromModel(goal));
      }
    });
  }

  Future<List<Goal>> getGoals() async {
    final entities = await _isar.goalEntitys.where().findAll();
    return entities.map((e) => e.toModel()).toList();
  }

  // ── StreakData ───────────────────────────────────────────────

  Future<void> saveStreak(StreakData streak) async {
    await _isar.writeTxn(() async {
      await _isar.streakEntitys.put(StreakEntity.fromModel(streak));
    });
  }

  Future<StreakData?> getStreak() async {
    final entity = await _isar.streakEntitys.get(1);
    return entity?.toModel();
  }

  // ── Cleanup ──────────────────────────────────────────────────

  /// Löscht Daten die älter als 90 Tage sind
  Future<void> cleanupOldData() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 90));
    final cutoffEpoch =
        cutoff.millisecondsSinceEpoch ~/ const Duration(days: 1).inMilliseconds;

    await _isar.writeTxn(() async {
      // DailySummaries
      await _isar.dailySummaryEntitys
          .where()
          .dateEpochDayLessThan(cutoffEpoch)
          .deleteAll();

      // SleepSessions
      await _isar.sleepSessionEntitys
          .filter()
          .dateLessThan(cutoff)
          .deleteAll();

      // WorkoutSessions
      await _isar.workoutSessionEntitys
          .filter()
          .startTimeLessThan(cutoff)
          .deleteAll();
    });
  }
}
