import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/vyro_colors.dart';
import '../../core/utils/date_helper.dart';
import '../../core/utils/number_formatter.dart';
import '../../shared/providers/health_providers.dart';
import '../../shared/widgets/vyro_card.dart';
import 'widgets/activity_rings.dart';

class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaySummary = ref.watch(todaySummaryProvider);
    final weeklySummaries = ref.watch(weeklySummariesProvider);
    final recentWorkouts = ref.watch(recentWorkoutsProvider);
    final streak = ref.watch(streakProvider);

    return Scaffold(
      backgroundColor: VyroColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateHelper.formatHeaderDate(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 13,
                            color: VyroColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text: 'VYRO ',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.8,
                              ),
                            ),
                            TextSpan(
                              text: 'Fit',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w400,
                                color: VyroColors.textSecondary,
                                letterSpacing: -0.8,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: VyroColors.card,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 20,
                        color: VyroColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Content ──
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Activity Rings
                todaySummary.when(
                  data: (summary) => VyroCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const VyroCardHeader(
                          icon: '⭕',
                          label: 'Aktivität',
                          color: VyroColors.moveRing,
                        ),
                        Row(
                          children: [
                            ActivityRings(
                              moveProgress: summary.moveProgress(560),
                              exerciseProgress: summary.exerciseProgress(30),
                              standProgress: summary.standProgress(12),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: ActivityRingLegend(
                                moveValue: summary.activeCalories,
                                moveGoal: 560,
                                exerciseValue: summary.activeMinutes,
                                exerciseGoal: 30,
                                standValue: summary.standHours,
                                standGoal: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  loading: () => const _LoadingCard(),
                  error: (_, __) => const _ErrorCard(message: 'Aktivitätsdaten nicht verfügbar'),
                ),

                // Streaks
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      _StreakBadge(
                        value: '${streak.currentStreak}',
                        label: 'Tage Streak 🔥',
                      ),
                      const SizedBox(width: 10),
                      _StreakBadge(
                        value: '${streak.weeklyGoalsCompleted}',
                        label: 'Wochen-Ziel ✓',
                      ),
                      const SizedBox(width: 10),
                      _StreakBadge(
                        value: NumberFormatter.percent(streak.monthlyScore),
                        label: 'Monats-Score',
                      ),
                    ],
                  ),
                ),

                // Schritte
                todaySummary.when(
                  data: (summary) => VyroCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const VyroCardHeader(
                          icon: '👟',
                          label: 'Schritte',
                          color: VyroColors.steps,
                        ),
                        VyroBigStat(
                          value: NumberFormatter.steps(summary.steps),
                          unit: 'Schritte',
                          subtitle: 'Ziel: 10.000',
                          subtitleColor: VyroColors.steps,
                        ),
                        // TODO: Mini Bar Chart hier
                      ],
                    ),
                  ),
                  loading: () => const _LoadingCard(),
                  error: (_, __) => const _ErrorCard(message: 'Schritte nicht verfügbar'),
                ),

                // Kalorien + HR (nebeneinander)
                todaySummary.when(
                  data: (summary) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: VyroColors.card,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const VyroCardHeader(
                                  icon: '🔥',
                                  label: 'Kalorien',
                                  color: VyroColors.calories,
                                ),
                                VyroBigStat(
                                  value: NumberFormatter.calories(summary.activeCalories),
                                  unit: 'kcal',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: VyroColors.card,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const VyroCardHeader(
                                  icon: '❤️',
                                  label: 'Ruhe-HR',
                                  color: VyroColors.heartRate,
                                ),
                                VyroBigStat(
                                  value: summary.restingHeartRate != null
                                      ? NumberFormatter.bpm(summary.restingHeartRate!)
                                      : '--',
                                  unit: 'bpm',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  loading: () => const _LoadingCard(),
                  error: (_, __) => const _ErrorCard(message: 'Daten nicht verfügbar'),
                ),

                // Letzte Workouts
                recentWorkouts.when(
                  data: (workouts) => VyroCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const VyroCardHeader(
                          icon: '💪',
                          label: 'Letzte Workouts',
                          color: VyroColors.workout,
                        ),
                        if (workouts.isEmpty)
                          const Text(
                            'Keine Workouts diese Woche',
                            style: TextStyle(color: VyroColors.textSecondary),
                          )
                        else
                          ...workouts.take(3).map((w) => _WorkoutRow(
                                type: w.type.label,
                                icon: w.type.icon,
                                duration: w.durationFormatted,
                                calories: '${w.caloriesBurned.round()}',
                                time:
                                    '${DateHelper.formatRelativeDay(w.startTime)}, ${DateHelper.formatTime(w.startTime)}',
                              )),
                      ],
                    ),
                  ),
                  loading: () => const _LoadingCard(),
                  error: (_, __) => const _ErrorCard(message: 'Workouts nicht verfügbar'),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hilfs-Widgets ───────────────────────────────────────────

class _StreakBadge extends StatelessWidget {
  final String value;
  final String label;

  const _StreakBadge({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: VyroColors.dimmed(VyroColors.steps),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: VyroColors.steps,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: VyroColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutRow extends StatelessWidget {
  final String type;
  final String icon;
  final String duration;
  final String calories;
  final String time;

  const _WorkoutRow({
    required this.type,
    required this.icon,
    required this.duration,
    required this.calories,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: VyroColors.separator, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: VyroColors.dimmed(VyroColors.workout),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Text(time, style: const TextStyle(fontSize: 11, color: VyroColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(duration, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Text(
                '$calories kcal',
                style: const TextStyle(fontSize: 11, color: VyroColors.workout),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const VyroCard(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return VyroCard(
      child: Center(
        child: Text(message, style: const TextStyle(color: VyroColors.textSecondary)),
      ),
    );
  }
}
