import 'package:health/health.dart';

/// Alle Health Connect Datentypen die VYRO Fit ausliest
class HealthTypes {
  HealthTypes._();

  /// Alle Typen kombiniert (für Permission-Request)
  static const List<HealthDataType> allTypes = [
    // Aktivität
    HealthDataType.STEPS,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.TOTAL_CALORIES_BURNED,

    // Herz
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_SDNN,

    // Schlaf
    HealthDataType.SLEEP_SESSION,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_REM,

    // Workouts
    HealthDataType.WORKOUT,

    // Körper
    HealthDataType.WEIGHT,
  ];

  /// Aktivitätsdaten
  static const List<HealthDataType> activity = [
    HealthDataType.STEPS,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.TOTAL_CALORIES_BURNED,
  ];

  /// Herzdaten
  static const List<HealthDataType> heart = [
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_SDNN,
  ];

  /// Schlafdaten
  static const List<HealthDataType> sleep = [
    HealthDataType.SLEEP_SESSION,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_REM,
  ];

  /// Workouts
  static const List<HealthDataType> workouts = [
    HealthDataType.WORKOUT,
  ];
}
