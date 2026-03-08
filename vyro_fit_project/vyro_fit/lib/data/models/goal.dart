/// Ziel-Datenmodell für VYRO Fit
class Goal {
  final GoalType type;
  final double target;
  final double current;

  const Goal({
    required this.type,
    required this.target,
    this.current = 0,
  });

  /// Fortschritt 0.0 - 1.0 (kann > 1.0 sein wenn übertroffen)
  double get progress => target > 0 ? current / target : 0;

  /// Fortschritt geclamped auf 0-1
  double get progressClamped => progress.clamp(0.0, 1.0);

  /// Ist das Ziel erreicht?
  bool get isCompleted => current >= target;

  Goal copyWith({double? current}) {
    return Goal(type: type, target: target, current: current ?? this.current);
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

  const StreakData({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.weeklyGoalsCompleted = 0,
    this.monthlyScore = 0,
  });
}

/// Standard-Zielwerte
class DefaultGoals {
  DefaultGoals._();

  static const int steps = 10000;
  static const double calories = 560;
  static const double sleepHours = 8;
  static const int workoutsPerWeek = 5;
  static const int activeMinutes = 30;
  static const int standHours = 12;
}
