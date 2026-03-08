import 'package:isar/isar.dart';
import '../../../models/workout_data.dart';

part 'workout_session_schema.g.dart';

/// Isar-Entity für Workout-Sessions
@Collection()
class WorkoutSessionEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String workoutId;

  @Index()
  late DateTime startTime;

  late DateTime endTime;
  int typeIndex = 0; // WorkoutType.index
  double caloriesBurned = 0;
  double? avgHeartRate;
  double? maxHeartRate;
  double? distanceMeters;
  String? sourceName;

  WorkoutData toModel() => WorkoutData(
        id: workoutId,
        startTime: startTime,
        endTime: endTime,
        type: WorkoutType.values[typeIndex],
        caloriesBurned: caloriesBurned,
        avgHeartRate: avgHeartRate,
        maxHeartRate: maxHeartRate,
        distanceMeters: distanceMeters,
        sourceName: sourceName,
      );

  static WorkoutSessionEntity fromModel(WorkoutData model) {
    return WorkoutSessionEntity()
      ..workoutId = model.id
      ..startTime = model.startTime
      ..endTime = model.endTime
      ..typeIndex = model.type.index
      ..caloriesBurned = model.caloriesBurned
      ..avgHeartRate = model.avgHeartRate
      ..maxHeartRate = model.maxHeartRate
      ..distanceMeters = model.distanceMeters
      ..sourceName = model.sourceName;
  }
}
