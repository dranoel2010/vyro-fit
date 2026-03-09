import '../../core/constants/app_constants.dart';
import '../../models/daily_summary.dart';
import '../../models/goal.dart';
import '../isar/isar_service.dart';

/// Repository für Ziele und Streak-Daten.
class GoalsRepository {
  final IsarService _isarService;

  const GoalsRepository(this._isarService);

  // ── Ziele ────────────────────────────────────────────────────

  Future<List<Goal>> getGoals() async {
    final goals = await _isarService.getGoals();
    if (goals.isEmpty) return _defaultGoals();
    return goals;
  }

  Future<void> saveGoals(List<Goal> goals) async {
    await _isarService.saveGoals(goals);
  }

  Future<void> updateProgress(GoalType type, double value) async {
    final goals = await getGoals();
    final updated = goals.map((g) {
      if (g.type == type) return g.copyWith(current: value);
      return g;
    }).toList();
    await saveGoals(updated);
  }

  // ── Streak ───────────────────────────────────────────────────

  Future<StreakData> getStreak() async {
    return await _isarService.getStreak() ?? const StreakData();
  }

  /// Berechnet und speichert Streak basierend auf DailySummaries
  Future<void> updateStreak(
    List<DailySummary> summaries,
    List<Goal> goals,
  ) async {
    final stepGoal = goals
        .firstWhere(
          (g) => g.type == GoalType.steps,
          orElse: () => const Goal(
            type: GoalType.steps,
            target: AppConstants.defaultStepGoal,
          ),
        )
        .target
        .toInt();

    // Letzten 30 Tage auswerten
    final sortedSummaries = [...summaries]
      ..sort((a, b) => b.date.compareTo(a.date));
    final last30 = sortedSummaries.take(30).toList();

    final goalReachedPerDay = last30
        .map((s) => s.steps >= stepGoal)
        .toList();

    // Aktuellen Streak berechnen (von heute rückwärts)
    int currentStreak = 0;
    for (final reached in goalReachedPerDay) {
      if (reached) {
        currentStreak++;
      } else {
        break;
      }
    }

    // Längsten Streak berechnen
    final existing = await getStreak();
    int longestStreak = existing.longestStreak;
    int tempStreak = 0;
    for (final reached in goalReachedPerDay) {
      if (reached) {
        tempStreak++;
        if (tempStreak > longestStreak) longestStreak = tempStreak;
      } else {
        tempStreak = 0;
      }
    }

    // Wochen-Ziele (diese Woche)
    final thisWeek = last30.take(7).toList();
    final weeklyCompleted = thisWeek.where((s) => s.steps >= stepGoal).length;

    // Monats-Score (letzte 30 Tage)
    final monthScore = last30.isEmpty
        ? 0.0
        : goalReachedPerDay.where((b) => b).length / last30.length;

    final streak = StreakData(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      weeklyGoalsCompleted: weeklyCompleted,
      monthlyScore: monthScore,
      last30Days: goalReachedPerDay,
    );

    await _isarService.saveStreak(streak);
  }

  // ── Standard-Ziele ───────────────────────────────────────────

  List<Goal> _defaultGoals() => [
        const Goal(
          type: GoalType.steps,
          target: AppConstants.defaultStepGoal,
        ),
        const Goal(
          type: GoalType.calories,
          target: AppConstants.defaultCalorieGoal,
        ),
        const Goal(
          type: GoalType.sleep,
          target: AppConstants.defaultSleepGoal,
        ),
        const Goal(
          type: GoalType.workoutsPerWeek,
          target: AppConstants.defaultWorkoutGoal,
        ),
        const Goal(
          type: GoalType.activeMinutes,
          target: AppConstants.defaultActiveMinGoal,
        ),
      ];
}
