import 'package:health/health.dart';
import '../../core/constants/health_types.dart';
import '../../core/utils/date_helper.dart';
import '../../models/sleep_data.dart';
import '../aggregation/sleep_score_calculator.dart';
import '../isar/isar_service.dart';
import '../services/health_service.dart';

/// Repository für Schlafdaten.
class SleepRepository {
  final HealthService _healthService;
  final IsarService _isarService;

  const SleepRepository(this._healthService, this._isarService);

  // ── Letzte Nacht ─────────────────────────────────────────────

  Future<SleepData?> getLastNight() async {
    // Cache zuerst
    final cached = await _isarService.getLastSleepSession();
    if (cached != null) {
      final now = DateTime.now();
      final age = now.difference(cached.date).inHours;
      if (age < 12) return cached; // Letzte 12h: Cache frisch genug
    }

    await sync();
    return _isarService.getLastSleepSession();
  }

  Future<List<SleepData>> getWeeklySleep() async {
    final start = DateHelper.weekStart;
    final end = DateTime.now();
    final cached = await _isarService.getSleepSessions(start, end);
    if (cached.isNotEmpty) return cached;

    await sync();
    return _isarService.getSleepSessions(start, end);
  }

  // ── Score für letzte Nacht ───────────────────────────────────

  Future<int> getLastNightScore() async {
    final last = await getLastNight();
    if (last == null) return 0;

    final weekData = await getWeeklySleep();
    return SleepScoreCalculator.calculate(last, weekHistory: weekData);
  }

  // ── Sync ─────────────────────────────────────────────────────

  Future<void> sync() async {
    final now = DateTime.now();
    // Letzte 48h für Schlafphasen
    final start = now.subtract(const Duration(days: 2));

    final rawData = await _healthService.fetchRawData(
      start: start,
      end: now,
      types: HealthTypes.sleep,
    );

    if (rawData.isEmpty) return;

    final sessions = _aggregateSleepSessions(rawData);
    for (final session in sessions) {
      await _isarService.saveSleepSession(session);
    }
  }

  // ── Aggregation ──────────────────────────────────────────────

  /// Gruppiert Sleep-DataPoints zu Sessions
  List<SleepData> _aggregateSleepSessions(List<HealthDataPoint> rawData) {
    // Sleep-Session als Ankerpunkt
    final sessions = rawData
        .where((p) => p.type == HealthDataType.SLEEP_SESSION)
        .toList();

    return sessions.map((session) {
      // Phasen für diese Session
      final phases = rawData.where((p) =>
          p.type != HealthDataType.SLEEP_SESSION &&
          p.dateFrom.isAfter(session.dateFrom.subtract(const Duration(hours: 1))) &&
          p.dateTo.isBefore(session.dateTo.add(const Duration(hours: 1)))).toList();

      Duration? awake, light, deep, rem;

      for (final phase in phases) {
        final duration = phase.dateTo.difference(phase.dateFrom);
        switch (phase.type) {
          case HealthDataType.SLEEP_AWAKE:
            awake = (awake ?? Duration.zero) + duration;
          case HealthDataType.SLEEP_LIGHT:
            light = (light ?? Duration.zero) + duration;
          case HealthDataType.SLEEP_DEEP:
            deep = (deep ?? Duration.zero) + duration;
          case HealthDataType.SLEEP_REM:
            rem = (rem ?? Duration.zero) + duration;
          default:
            break;
        }
      }

      return SleepData(
        date: session.dateFrom,
        bedtime: session.dateFrom,
        wakeTime: session.dateTo,
        totalDuration: session.dateTo.difference(session.dateFrom),
        awake: awake,
        light: light,
        deep: deep,
        rem: rem,
      );
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}
