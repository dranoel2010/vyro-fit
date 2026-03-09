import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/isar/isar_service.dart';
import '../data/repositories/goals_repository.dart';
import '../models/goal.dart';
import 'health_providers.dart';

// ── Repository ────────────────────────────────────────────────

final goalsRepositoryProvider = Provider<GoalsRepository>((ref) {
  return GoalsRepository(ref.read(isarServiceProvider));
});

// ── Daten ─────────────────────────────────────────────────────

/// Streak-Daten (aktuell, längster, Wochen-Ziele, Monats-Score)
final streakProvider = FutureProvider<StreakData>((ref) async {
  return ref.read(goalsRepositoryProvider).getStreak();
});

/// Gespeicherte Ziele aus Isar (mit Fallback auf Standard-Werte)
final persistedGoalsProvider = FutureProvider<List<Goal>>((ref) async {
  return ref.read(goalsRepositoryProvider).getGoals();
});
