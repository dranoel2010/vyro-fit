import '../../core/constants/health_types.dart';
import '../../core/utils/date_helper.dart';
import '../../models/daily_summary.dart';
import '../../models/heart_rate_data.dart';
import '../aggregation/chart_data_builder.dart';
import '../aggregation/daily_summary_generator.dart';
import '../aggregation/trend_calculator.dart';
import '../isar/isar_service.dart';
import '../services/health_service.dart';

/// Repository für Aktivitäts- und allgemeine Gesundheitsdaten.
/// Orchestriert: Health Connect → Aggregation → Isar Cache → Provider
class HealthRepository {
  final HealthService _healthService;
  final IsarService _isarService;

  const HealthRepository(this._healthService, this._isarService);

  // ── Heute ────────────────────────────────────────────────────

  /// Holt die DailySummary für heute.
  /// Cache: aus Isar; bei Bedarf Sync von Health Connect.
  Future<DailySummary> getTodaySummary() async {
    return _getOrFetch(DateHelper.todayStart);
  }

  // ── Woche ────────────────────────────────────────────────────

  Future<List<DailySummary>> getWeeklySummaries() async {
    final days = DateHelper.lastNDays(7);
    final results = await Future.wait(days.map(_getOrFetch));
    return results;
  }

  Future<List<DailySummary>> getMonthlySummaries() async {
    final days = DateHelper.lastNDays(30);
    final results = await Future.wait(days.map(_getOrFetch));
    return results;
  }

  // ── Sync ─────────────────────────────────────────────────────

  /// Syncht heute aus Health Connect → Aggregation → Isar
  Future<void> syncToday() async {
    final summary = await _fetchFromHealthConnect(DateHelper.todayStart);
    await _isarService.saveDailySummary(summary);
  }

  /// Syncht die letzten 7 Tage
  Future<void> syncWeek() async {
    final days = DateHelper.lastNDays(7);
    await Future.wait(days.map((day) async {
      final summary = await _fetchFromHealthConnect(day);
      await _isarService.saveDailySummary(summary);
    }));
  }

  /// Prefetch beim App-Start: alles parallel laden
  Future<void> prefetchAll() async {
    await Future.wait([syncToday(), syncWeek()]);
  }

  // ── Charts ───────────────────────────────────────────────────

  Future<WeeklyChartData> getWeeklyCharts() async {
    final summaries = await getWeeklySummaries();
    return ChartDataBuilder.buildWeeklyCharts(summaries, []);
  }

  Future<String> getTodayTrend() async {
    final thisWeek = await getWeeklySummaries();
    // Letzte Woche für Vergleich
    final lastWeekDays = List.generate(7, (i) {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 13 - i));
    });
    final lastWeek =
        await Future.wait(lastWeekDays.map(_getOrFetch));
    final change = TrendCalculator.stepsChange(thisWeek, lastWeek);
    return TrendCalculator.formatTrend(change);
  }

  // ── HR Timeline ──────────────────────────────────────────────

  Future<List<HeartRateData>> getTodayHRTimeline() async {
    final now = DateTime.now();
    final start = DateHelper.todayStart;
    final rawData = await _healthService.fetchRawData(
      start: start,
      end: now,
      types: [HealthDataType.HEART_RATE],
    );
    return rawData.map((p) {
      final value = (p.value as dynamic).numericValue.toDouble();
      return HeartRateData(timestamp: p.dateFrom, bpm: value);
    }).toList();
  }

  // ── Intern ───────────────────────────────────────────────────

  /// Cache-First: erst Isar, dann Health Connect
  Future<DailySummary> _getOrFetch(DateTime date) async {
    // 1. Aus Cache laden (ausgenommen heute – immer frisch)
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    if (!isToday) {
      final cached = await _isarService.getDailySummary(date);
      if (cached != null) return cached;
    }

    // 2. Von Health Connect laden
    final fresh = await _fetchFromHealthConnect(date);

    // 3. In Isar cachen
    await _isarService.saveDailySummary(fresh);
    return fresh;
  }

  Future<DailySummary> _fetchFromHealthConnect(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final rawData = await _healthService.fetchRawData(
      start: start,
      end: end,
      types: HealthTypes.activity + HealthTypes.heart,
    );

    // Schritte aggregiert (genauer als Rohdaten summieren)
    final totalSteps = await _healthService.getTotalSteps(start, end);

    return DailySummaryGenerator.generate(
      rawData,
      date,
      totalStepsOverride: totalSteps,
    );
  }
}
