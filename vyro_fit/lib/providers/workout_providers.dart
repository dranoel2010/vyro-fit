import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/isar/isar_service.dart';
import '../data/repositories/workout_repository.dart';
import '../data/services/health_service.dart';
import '../models/workout_data.dart';
import 'health_providers.dart';

// ── Repository ────────────────────────────────────────────────

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepository(
    ref.read(healthServiceProvider),
    ref.read(isarServiceProvider),
  );
});

// ── Daten ─────────────────────────────────────────────────────

/// Letzte Workouts (Standard: 7 Tage)
final recentWorkoutsProvider = FutureProvider<List<WorkoutData>>((ref) async {
  return ref.read(workoutRepositoryProvider).getRecentWorkouts();
});

/// Letzte 14 Tage (für Workouts-Screen)
final extendedWorkoutsProvider =
    FutureProvider<List<WorkoutData>>((ref) async {
  return ref.read(workoutRepositoryProvider).getRecentWorkouts(days: 14);
});

/// Anzahl Workouts diese Woche
final weeklyWorkoutCountProvider = FutureProvider<int>((ref) async {
  return ref.read(workoutRepositoryProvider).getWeeklyWorkoutCount();
});

/// Einzelnes Workout nach ID (für Detail-Screen)
final workoutDetailProvider =
    FutureProvider.family<WorkoutData?, String>((ref, id) async {
  return ref.read(workoutRepositoryProvider).getWorkoutById(id);
});
