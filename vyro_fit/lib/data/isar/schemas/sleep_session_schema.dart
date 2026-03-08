import 'package:isar/isar.dart';
import '../../../models/sleep_data.dart';

part 'sleep_session_schema.g.dart';

/// Isar-Entity für Schlaf-Sessions
@Collection()
class SleepSessionEntity {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime date;

  late DateTime bedtime;
  late DateTime wakeTime;
  int totalMinutes = 0;
  int? awakeMinutes;
  int? lightMinutes;
  int? deepMinutes;
  int? remMinutes;

  SleepData toModel() => SleepData(
        date: date,
        bedtime: bedtime,
        wakeTime: wakeTime,
        totalDuration: Duration(minutes: totalMinutes),
        awake: awakeMinutes != null ? Duration(minutes: awakeMinutes!) : null,
        light: lightMinutes != null ? Duration(minutes: lightMinutes!) : null,
        deep: deepMinutes != null ? Duration(minutes: deepMinutes!) : null,
        rem: remMinutes != null ? Duration(minutes: remMinutes!) : null,
      );

  static SleepSessionEntity fromModel(SleepData model) {
    return SleepSessionEntity()
      ..date = model.date
      ..bedtime = model.bedtime
      ..wakeTime = model.wakeTime
      ..totalMinutes = model.totalDuration.inMinutes
      ..awakeMinutes = model.awake?.inMinutes
      ..lightMinutes = model.light?.inMinutes
      ..deepMinutes = model.deep?.inMinutes
      ..remMinutes = model.rem?.inMinutes;
  }
}
