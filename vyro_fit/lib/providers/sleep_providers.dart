import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/isar/isar_service.dart';
import '../data/repositories/sleep_repository.dart';
import '../data/services/health_service.dart';
import '../models/sleep_data.dart';
import 'health_providers.dart';

// ── Repository ────────────────────────────────────────────────

final sleepRepositoryProvider = Provider<SleepRepository>((ref) {
  return SleepRepository(
    ref.read(healthServiceProvider),
    ref.read(isarServiceProvider),
  );
});

// ── Daten ─────────────────────────────────────────────────────

/// Letzte Schlaf-Session
final lastNightProvider = FutureProvider<SleepData?>((ref) async {
  return ref.read(sleepRepositoryProvider).getLastNight();
});

/// Wöchentliche Schlaf-Sessions (7 Tage)
final weeklySleepProvider = FutureProvider<List<SleepData>>((ref) async {
  return ref.read(sleepRepositoryProvider).getWeeklySleep();
});

/// Schlaf-Score der letzten Nacht (0-100)
final sleepScoreProvider = FutureProvider<int>((ref) async {
  return ref.read(sleepRepositoryProvider).getLastNightScore();
});
