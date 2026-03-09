import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../providers/goal_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/score_ring.dart';
import '../../../shared/widgets/loading_card.dart';

class WeeklyScoreCard extends ConsumerWidget {
  const WeeklyScoreCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);

    return streak.when(
      loading: () => const LoadingCard(height: 140),
      error: (_, __) => const SizedBox.shrink(),
      data: (s) {
        final weekScore = s.weeklyGoalsCompleted == 0
            ? 0
            : ((s.weeklyGoalsCompleted / 7) * 100).round();

        return VyroCard(
          child: Row(
            children: [
              ScoreRing(score: weekScore, size: 90),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WOCHEN-SCORE', style: VyroTextStyles.label),
                    const SizedBox(height: 6),
                    Text(
                      '${s.weeklyGoalsCompleted} von 7 Tagen',
                      style: VyroTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Monats-Score: ${NumberFormatter.percent(s.monthlyScore)}',
                      style: VyroTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
