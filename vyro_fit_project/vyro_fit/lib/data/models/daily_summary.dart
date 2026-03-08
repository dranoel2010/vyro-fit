/// Zusammenfassung eines Tages für das Dashboard
class DailySummary {
  final DateTime date;
  final int steps;
  final double activeCalories;
  final double totalCalories;
  final int activeMinutes;
  final int standHours;
  final double? restingHeartRate;
  final double? sleepHours;
  final double distanceMeters;

  const DailySummary({
    required this.date,
    this.steps = 0,
    this.activeCalories = 0,
    this.totalCalories = 0,
    this.activeMinutes = 0,
    this.standHours = 0,
    this.restingHeartRate,
    this.sleepHours,
    this.distanceMeters = 0,
  });

  /// Fortschritt für Activity Rings (0.0 - 1.0+)
  double moveProgress(double goal) => activeCalories / goal;
  double exerciseProgress(int goalMinutes) => activeMinutes / goalMinutes;
  double standProgress(int goalHours) => standHours / goalHours;
  double stepsProgress(int goal) => steps / goal;
}
