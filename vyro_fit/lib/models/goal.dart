/// Ziel-Datenmodell
class Goal {
  final GoalType type;
  final double target;
  final double current;

  const Goal({
    required this.type,
    required this.target,
    this.current = 0,
  });

  /// Fortschritt 0.0 – 1.0 (kann > 1.0 bei Übererfüllung sein)
  double get progress => target > 0 ? current / target : 0;

  /// Fortschritt geclamped auf 0–1
  double get progressClamped => progress.clamp(0.0, 1.0);

  bool get isCompleted => current >= target;

  Goal copyWith({double? current, double? target}) {
    return Goal(
      type: type,
      target: target ?? this.target,
      current: current ?? this.current,
    );
  }
}

enum GoalType {
  steps('Schritte', '👟', ''),
  calories('Kalorien', '🔥', 'kcal'),
  sleep('Schlaf', '🌙', 'h'),
  workoutsPerWeek('Workouts / Woche', '💪', ''),
  activeMinutes('Aktive Minuten', '⏱️', 'min');

  final String label;
  final String icon;
  final String unit;
  const GoalType(this.label, this.icon, this.unit);
}

/// Streak-Daten
class StreakData {
  final int currentStreak;
  final int longestStreak;
  final int weeklyGoalsCompleted;
  final double monthlyScore;
  final List<bool> last30Days;

  const StreakData({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.weeklyGoalsCompleted = 0,
    this.monthlyScore = 0,
    this.last30Days = const [],
  });
}
