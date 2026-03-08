import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/health_service.dart';
import '../models/daily_summary.dart';
import '../models/goal.dart';
import '../models/sleep_data.dart';
import '../models/workout_data.dart';

// ── Service Provider ──────────────────────────────────────────
// HINWEIS: Repository-Layer kommt in Phase 3-6.
// Bis dahin direkter Service-Zugriff nur in diesen Providern (nicht in UI!)

final healthServiceProvider = Provider<HealthService>((ref) {
  return HealthService();
});

// ── Berechtigungen ────────────────────────────────────────────

final healthAuthorizedProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(healthServiceProvider);
  return service.requestPermissions();
});

// ── Tages-Daten ───────────────────────────────────────────────

final todaySummaryProvider = FutureProvider<DailySummary>((ref) async {
  // Platzhalter bis Phase 5-6 (HealthRepository)
  return DailySummary(date: DateTime.now());
});

final weeklySummariesProvider = FutureProvider<List<DailySummary>>((ref) async {
  // Platzhalter bis Phase 5-6
  final now = DateTime.now();
  return List.generate(
    7,
    (i) => DailySummary(date: now.subtract(Duration(days: 6 - i))),
  );
});

// ── Schlaf ────────────────────────────────────────────────────

final lastSleepProvider = FutureProvider<SleepData?>((ref) async {
  // Platzhalter bis Phase 5-6
  return null;
});

// ── Workouts ──────────────────────────────────────────────────

final recentWorkoutsProvider = FutureProvider<List<WorkoutData>>((ref) async {
  // Platzhalter bis Phase 5-6
  return [];
});

// ── Ziele ─────────────────────────────────────────────────────

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
          const Goal(type: GoalType.activeMinutes, target: 30),
        ]);

  void updateProgress(GoalType type, double current) {
    state = [
      for (final goal in state)
        if (goal.type == type) goal.copyWith(current: current) else goal,
    ];
  }

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

// ── Streak ────────────────────────────────────────────────────

final streakProvider = StateProvider<StreakData>((ref) {
  // Platzhalter bis Phase 6 (GoalsRepository + StreakCalculator)
  return const StreakData(
    currentStreak: 0,
    longestStreak: 0,
    weeklyGoalsCompleted: 0,
    monthlyScore: 0,
  );
});
