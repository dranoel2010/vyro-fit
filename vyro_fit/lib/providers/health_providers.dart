import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/isar/isar_service.dart';
import '../data/repositories/health_repository.dart';
import '../data/services/health_service.dart';
import '../models/daily_summary.dart';
import '../models/goal.dart';
import '../models/heart_rate_data.dart';

// ── Services & Repositories ──────────────────────────────────
// Die UI greift NIEMALS direkt auf diese Provider zu!
// Nur über Feature-spezifische Provider (todaySummaryProvider etc.)

final healthServiceProvider = Provider<HealthService>((ref) {
  return HealthService();
});

// IsarService ist ein Singleton (static init in main.dart)
// Alle Repositories teilen dieselbe Datenbank-Instanz
final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService(); // nutzt die in main.dart initialisierte Instanz
});

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepository(
    ref.read(healthServiceProvider),
    ref.read(isarServiceProvider),
  );
});

// ── Berechtigungen ────────────────────────────────────────────

/// Health Connect Permission Status
final healthAuthorizedProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(healthServiceProvider);
  return service.requestPermissions();
});

// ── Tages-Daten ───────────────────────────────────────────────

/// Heutige DailySummary (über Repository → Cache → Health Connect)
final todaySummaryProvider = FutureProvider<DailySummary>((ref) async {
  return ref.read(healthRepositoryProvider).getTodaySummary();
});

/// Wöchentliche DailySummaries (7 Tage)
final weeklySummariesProvider = FutureProvider<List<DailySummary>>((ref) async {
  return ref.read(healthRepositoryProvider).getWeeklySummaries();
});

/// Monatliche DailySummaries (30 Tage)
final monthlySummariesProvider =
    FutureProvider<List<DailySummary>>((ref) async {
  return ref.read(healthRepositoryProvider).getMonthlySummaries();
});

/// Wöchentliche Chart-Daten
final weeklyChartsProvider = FutureProvider<WeeklyChartData>((ref) async {
  return ref.read(healthRepositoryProvider).getWeeklyCharts();
});

/// Trend heute vs. letzte Woche: "+12%"
final todayTrendProvider = FutureProvider<String>((ref) async {
  return ref.read(healthRepositoryProvider).getTodayTrend();
});

/// HR-Timeline für heute (24h)
final todayHRTimelineProvider =
    FutureProvider<List<HeartRateData>>((ref) async {
  return ref.read(healthRepositoryProvider).getTodayHRTimeline();
});

// ── Ziele (hier, da sie global gebraucht werden) ─────────────

final goalsProvider = StateNotifierProvider<GoalsNotifier, List<Goal>>((ref) {
  return GoalsNotifier();
});

class GoalsNotifier extends StateNotifier<List<Goal>> {
  GoalsNotifier()
      : super([
          const Goal(type: GoalType.steps, target: 10000),
          const Goal(type: GoalType.calories, target: 560),
          const Goal(type: GoalType.sleep, target: 8),
          const Goal(type: GoalType.workoutsPerWeek, target: 5),
          const Goal(type: GoalType.activeMinutes, target: 30),
        ]);

  void updateProgress(GoalType type, double current) {
    state = [
      for (final goal in state)
        if (goal.type == type) goal.copyWith(current: current) else goal,
    ];
  }

  void updateTarget(GoalType type, double newTarget) {
    state = [
      for (final goal in state)
        if (goal.type == type)
          Goal(type: type, target: newTarget, current: goal.current)
        else
          goal,
    ];
  }

  Goal? getGoal(GoalType type) {
    try {
      return state.firstWhere((g) => g.type == type);
    } catch (_) {
      return null;
    }
  }
}
