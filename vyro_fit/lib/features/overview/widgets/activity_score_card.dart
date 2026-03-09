import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../models/daily_summary.dart';
import '../../../providers/health_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/score_ring.dart';
import '../../../shared/widgets/loading_card.dart';

class ActivityScoreCard extends ConsumerWidget {
  final int animationIndex;

  const ActivityScoreCard({super.key, this.animationIndex = 0});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(todaySummaryProvider);

    return summary.when(
      loading: () => const LoadingCard(height: 160),
      error: (_, __) => const SizedBox.shrink(),
      data: (s) {
        final score = _calcScore(s);
        return VyroCard(
          animationDelay: Duration(milliseconds: animationIndex * 60),
          child: Row(
            children: [
              ScoreRing(score: score, size: 100),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AKTIVITÄTS-SCORE', style: VyroTextStyles.label),
                    const SizedBox(height: 6),
                    Text(
                      _scoreLabel(score),
                      style: VyroTextStyles.title.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${NumberFormatter.steps(s.steps)} Schritte · ${NumberFormatter.calories(s.activeCalories)} kcal',
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

  int _calcScore(DailySummary s) {
    final stepScore = (s.steps / AppConstants.defaultStepGoal).clamp(0.0, 1.0);
    final calScore = (s.activeCalories / AppConstants.defaultCalorieGoal).clamp(0.0, 1.0);
    final minScore = (s.activeMinutes / AppConstants.defaultActiveMinGoal).clamp(0.0, 1.0);
    return ((stepScore * 0.4 + calScore * 0.3 + minScore * 0.3) * 100).round();
  }

  String _scoreLabel(int score) {
    if (score >= 90) return 'Ausgezeichnet';
    if (score >= 75) return 'Sehr gut';
    if (score >= 60) return 'Gut';
    if (score >= 40) return 'Okay';
    return 'Bewegung fehlt';
  }
}
