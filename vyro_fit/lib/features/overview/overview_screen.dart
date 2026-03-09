import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/vyro_colors.dart';
import '../../core/theme/vyro_text_styles.dart';
import '../../core/utils/date_helper.dart';
import '../../core/utils/number_formatter.dart';
import '../../providers/goal_providers.dart';
import './widgets/activity_score_card.dart';
import './widgets/steps_card.dart';
import './widgets/calories_card.dart';
import './widgets/heart_rate_card.dart';
import './widgets/sleep_summary_card.dart';
import './widgets/recent_workouts_card.dart';

class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);

    return Scaffold(
      backgroundColor: VyroColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // ── Header ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 52, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateHelper.getGreeting(), style: VyroTextStyles.greeting),
                    const SizedBox(height: 6),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(text: 'VYRO ', style: VyroTextStyles.title),
                        TextSpan(
                          text: 'Fit',
                          style: VyroTextStyles.title.copyWith(
                            fontWeight: FontWeight.w300,
                            color: VyroColors.textSecondary,
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateHelper.formatHeaderDate(DateTime.now()),
                      style: VyroTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),

            // ── Streak Badges ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: streak.when(
                  data: (s) => Row(children: [
                    _StreakBadge(value: '${s.currentStreak}', label: 'Tage Streak'),
                    const SizedBox(width: 10),
                    _StreakBadge(value: '${s.weeklyGoalsCompleted}', label: 'Wochen-Ziel'),
                    const SizedBox(width: 10),
                    _StreakBadge(
                      value: s.monthlyScore > 0
                          ? NumberFormatter.percent(s.monthlyScore)
                          : '--',
                      label: 'Monats-Score',
                    ),
                  ]),
                  loading: () => const SizedBox(height: 56),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Karten ──────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const ActivityScoreCard(animationIndex: 0),
                  const SizedBox(height: 14),
                  const StepsCard(animationIndex: 1),
                  const SizedBox(height: 14),
                  const CaloriesCard(animationIndex: 2),
                  const SizedBox(height: 14),
                  const HeartRateCard(animationIndex: 3),
                  const SizedBox(height: 14),
                  const SleepSummaryCard(animationIndex: 4),
                  const SizedBox(height: 14),
                  const RecentWorkoutsCard(animationIndex: 5),
                ]),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final String value;
  final String label;

  const _StreakBadge({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: VyroColors.card,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x59000000),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: VyroTextStyles.dataValueSm.copyWith(
                fontSize: 20,
                color: VyroColors.accent,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: VyroTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
