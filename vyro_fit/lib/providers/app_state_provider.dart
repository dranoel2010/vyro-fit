import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'health_providers.dart';
import 'sleep_providers.dart';
import 'workout_providers.dart';
import 'goal_providers.dart';

/// App-Start Initialisierung: lädt alle Daten parallel.
/// Wird in der UI mit ref.watch(appInitProvider) beobachtet.
final appInitProvider = FutureProvider<void>((ref) async {
  // Alles parallel laden (kein await-Chaining!)
  await Future.wait([
    // Health-Daten prefetchen
    ref.read(healthRepositoryProvider).prefetchAll(),

    // Schlaf sync
    ref.read(sleepRepositoryProvider).sync(),

    // Workouts sync
    ref.read(workoutRepositoryProvider).sync(),
  ]);

  // Streak nach dem Laden der Daten berechnen
  final summaries = await ref.read(weeklySummariesProvider.future);
  final goals = ref.read(goalsProvider);
  await ref.read(goalsRepositoryProvider).updateStreak(summaries, goals);
});
