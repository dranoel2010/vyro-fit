/// Workout / Trainings-Session Datenmodell
class WorkoutData {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final WorkoutType type;
  final double caloriesBurned;
  final double? avgHeartRate;
  final double? maxHeartRate;
  final double? distanceMeters;
  final String? sourceName;

  const WorkoutData({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.caloriesBurned = 0,
    this.avgHeartRate,
    this.maxHeartRate,
    this.distanceMeters,
    this.sourceName,
  });

  Duration get duration => endTime.difference(startTime);

  String get durationFormatted {
    final min = duration.inMinutes;
    if (min < 60) return '$min min';
    final h = min ~/ 60;
    final m = min % 60;
    return '${h}h ${m}m';
  }
}

/// Workout-Typen mit deutschen Labels und Emojis
enum WorkoutType {
  strength('Krafttraining', '🏋️'),
  running('Laufen', '🏃'),
  cycling('Radfahren', '🚴'),
  swimming('Schwimmen', '🏊'),
  walking('Gehen', '🚶'),
  hiking('Wandern', '🥾'),
  yoga('Yoga', '🧘'),
  hiit('HIIT', '⚡'),
  other('Sonstiges', '🏃');

  final String label;
  final String icon;
  const WorkoutType(this.label, this.icon);

  /// Mappt Health Connect ExerciseType auf WorkoutType
  static WorkoutType fromHealthConnect(int? exerciseType) {
    return switch (exerciseType) {
      79 => WorkoutType.strength, // STRENGTH_TRAINING
      56 => WorkoutType.running,  // RUNNING
      8  => WorkoutType.cycling,  // BIKING
      74 => WorkoutType.swimming, // SWIMMING_POOL
      75 => WorkoutType.swimming, // SWIMMING_OPEN_WATER
      82 => WorkoutType.walking,  // WALKING
      35 => WorkoutType.hiking,   // HIKING
      83 => WorkoutType.yoga,     // YOGA
      36 => WorkoutType.hiit,     // HIGH_INTENSITY_INTERVAL_TRAINING
      _  => WorkoutType.other,
    };
  }
}
