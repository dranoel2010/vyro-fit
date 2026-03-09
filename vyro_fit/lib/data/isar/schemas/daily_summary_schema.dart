import 'package:isar/isar.dart';
import '../../../models/daily_summary.dart';

part 'daily_summary_schema.g.dart';

/// Isar-Entity für DailySummary (Tages-Cache)
@Collection()
class DailySummaryEntity {
  Id id = Isar.autoIncrement;

  /// Datum als Unix-Timestamp (ms) für Index-Abfragen
  @Index(unique: true)
  late int dateEpochDay; // date.millisecondsSinceEpoch ~/ 86400000

  late DateTime date;

  int steps = 0;
  double activeCalories = 0;
  double totalCalories = 0;
  int activeMinutes = 0;
  int standHours = 0;
  double? restingHeartRate;
  double? sleepHours;
  double distanceMeters = 0;

  DailySummary toModel() => DailySummary(
        date: date,
        steps: steps,
        activeCalories: activeCalories,
        totalCalories: totalCalories,
        activeMinutes: activeMinutes,
        standHours: standHours,
        restingHeartRate: restingHeartRate,
        sleepHours: sleepHours,
        distanceMeters: distanceMeters,
      );

  static DailySummaryEntity fromModel(DailySummary model) {
    final entity = DailySummaryEntity()
      ..date = model.date
      ..dateEpochDay =
          model.date.millisecondsSinceEpoch ~/ const Duration(days: 1).inMilliseconds
      ..steps = model.steps
      ..activeCalories = model.activeCalories
      ..totalCalories = model.totalCalories
      ..activeMinutes = model.activeMinutes
      ..standHours = model.standHours
      ..restingHeartRate = model.restingHeartRate
      ..sleepHours = model.sleepHours
      ..distanceMeters = model.distanceMeters;
    return entity;
  }
}
