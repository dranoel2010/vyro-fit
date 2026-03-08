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

  /// Fortschritt für Ringe/Balken (0.0 – 1.0+)
  double stepsProgress(int goal) => goal > 0 ? steps / goal : 0;
  double moveProgress(double goal) => goal > 0 ? activeCalories / goal : 0;
  double exerciseProgress(int goalMinutes) =>
      goalMinutes > 0 ? activeMinutes / goalMinutes : 0;
  double standProgress(int goalHours) =>
      goalHours > 0 ? standHours / goalHours : 0;
}
