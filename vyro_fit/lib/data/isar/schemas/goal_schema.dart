import 'package:isar/isar.dart';
import '../../../models/goal.dart';

part 'goal_schema.g.dart';

/// Isar-Entity für Ziele
@Collection()
class GoalEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int typeIndex = 0; // GoalType.index

  double target = 0;
  double current = 0;

  Goal toModel() => Goal(
        type: GoalType.values[typeIndex],
        target: target,
        current: current,
      );

  static GoalEntity fromModel(Goal model) {
    return GoalEntity()
      ..typeIndex = model.type.index
      ..target = model.target
      ..current = model.current;
  }
}
