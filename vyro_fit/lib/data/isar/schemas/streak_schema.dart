import 'package:isar/isar.dart';
import '../../../models/goal.dart';

part 'streak_schema.g.dart';

/// Isar-Entity für Streak-Daten (einzelne Zeile, id = 1)
@Collection()
class StreakEntity {
  Id id = 1; // Immer nur ein Datensatz

  int currentStreak = 0;
  int longestStreak = 0;
  int weeklyGoalsCompleted = 0;
  double monthlyScore = 0;

  /// last30Days als komma-separierter String: "1,0,1,1,0,..."
  String last30DaysEncoded = '';

  StreakData toModel() {
    final days = last30DaysEncoded.isEmpty
        ? <bool>[]
        : last30DaysEncoded.split(',').map((s) => s == '1').toList();
    return StreakData(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      weeklyGoalsCompleted: weeklyGoalsCompleted,
      monthlyScore: monthlyScore,
      last30Days: days,
    );
  }

  static StreakEntity fromModel(StreakData model) {
    return StreakEntity()
      ..currentStreak = model.currentStreak
      ..longestStreak = model.longestStreak
      ..weeklyGoalsCompleted = model.weeklyGoalsCompleted
      ..monthlyScore = model.monthlyScore
      ..last30DaysEncoded =
          model.last30Days.map((b) => b ? '1' : '0').join(',');
  }
}
