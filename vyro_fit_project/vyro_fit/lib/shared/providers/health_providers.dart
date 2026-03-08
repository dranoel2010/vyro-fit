import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/health_service.dart';
import '../../data/models/daily_summary.dart';
import '../../data/models/goal.dart';
import '../../data/models/sleep_data.dart';
import '../../data/models/workout_data.dart';

/// Singleton Health Service
final healthServiceProvider = Provider<HealthService>((ref) {
  return HealthService();
});

/// Autorisierungs-Status
final healthAuthorizedProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(healthServiceProvider);
  return service.requestPermissions();
});

/// Tages-Zusammenfassung für heute
final todaySummaryProvider = FutureProvider<DailySummary>((ref) async {
  final service = ref.read(healthServiceProvider);
  return service.getDailySummary(DateTime.now());
});

/// Wochen-Übersicht (7 Tage)
final weeklySummariesProvider = FutureProvider<List<DailySummary>>((ref) async {
  final service = ref.read(healthServiceProvider);
  return service.getWeeklySummaries();
});

/// Heutige Schritte
final todayStepsProvider = FutureProvider<int>((ref) async {
  final service = ref.read(healthServiceProvider);
  return service.getTodaySteps();
});

/// Letzte Schlaf-Session
final lastSleepProvider = FutureProvider<SleepData?>((ref) async {
  final service = ref.read(healthServiceProvider);
  return service.getLastSleepSession();
});

/// Letzte Workouts
final recentWorkoutsProvider = FutureProvider<List<WorkoutData>>((ref) async {
  final service = ref.read(healthServiceProvider);
  return service.getRecentWorkouts();
});

/// Aktive Ziele (mit Standardwerten)
final goalsProvider = StateNotifierProvider<GoalsNotifier, List<Goal>>((ref) {
  return GoalsNotifier();
});

class GoalsNotifier extends StateNotifier<List<Goal>> {
  GoalsNotifier()
      : super([
          const Goal(type: GoalType.steps, target: 10000),
          const Goal(type: GoalType.calories, target: 560),
          const Goal(type: GoalType.sleep, target: 8),
          const Goal(type: GoalType.workoutsPerWeek, target: 5),
        ]);

  /// Aktualisiert den Fortschritt eines Ziels
  void updateProgress(GoalType type, double current) {
    state = [
      for (final goal in state)
        if (goal.type == type) goal.copyWith(current: current) else goal,
    ];
  }

  /// Ändert das Ziel
  void updateTarget(GoalType type, double newTarget) {
    state = [
      for (final goal in state)
        if (goal.type == type)
          Goal(type: type, target: newTarget, current: goal.current)
        else
          goal,
    ];
  }
}

/// Streak-Daten
final streakProvider = StateProvider<StreakData>((ref) {
  // TODO: Aus lokalem Speicher laden / berechnen
  return const StreakData(
    currentStreak: 12,
    longestStreak: 23,
    weeklyGoalsCompleted: 4,
    monthlyScore: 0.87,
  );
});
