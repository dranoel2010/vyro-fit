import 'package:health/health.dart';

/// Alle Health Connect Datentypen die VYRO Fit ausliest
class HealthTypes {
  HealthTypes._();

  /// Alle Typen die wir lesen wollen
  static const List<HealthDataType> allTypes = [
    // Aktivität
    HealthDataType.STEPS,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.TOTAL_CALORIES_BURNED,

    // Herz
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,

    // Schlaf
    HealthDataType.SLEEP_SESSION,

    // Workouts
    HealthDataType.WORKOUT,

    // Körper
    HealthDataType.WEIGHT,
  ];

  /// Nur Aktivitätsdaten
  static const List<HealthDataType> activity = [
    HealthDataType.STEPS,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.TOTAL_CALORIES_BURNED,
  ];

  /// Nur Herzdaten
  static const List<HealthDataType> heart = [
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
  ];

  /// Nur Schlaf
  static const List<HealthDataType> sleep = [
    HealthDataType.SLEEP_SESSION,
  ];

  /// Nur Workouts
  static const List<HealthDataType> workouts = [
    HealthDataType.WORKOUT,
  ];
}
