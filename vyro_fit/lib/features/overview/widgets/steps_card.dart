import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../providers/health_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/mini_bar_chart.dart';
import '../../../shared/widgets/progress_bar.dart';
import '../../../shared/widgets/loading_card.dart';

class StepsCard extends ConsumerWidget {
  final int animationIndex;

  const StepsCard({super.key, this.animationIndex = 1});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(todaySummaryProvider);
    final charts = ref.watch(weeklyChartsProvider);

    return summary.when(
      loading: () => const LoadingCard(),
      error: (_, __) => const SizedBox.shrink(),
      data: (s) {
        final progress = s.stepsProgress(AppConstants.defaultStepGoal);
        return VyroCard(
          animationDelay: Duration(milliseconds: animationIndex * 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SCHRITTE', style: VyroTextStyles.label),
                  Text(
                    'Ziel ${NumberFormatter.steps(AppConstants.defaultStepGoal.toDouble())}',
                    style: VyroTextStyles.caption,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                NumberFormatter.steps(s.steps),
                style: VyroTextStyles.dataValue,
              ),
              const SizedBox(height: 4),
              Text(
                '${NumberFormatter.distance(s.distanceMeters)} · ${NumberFormatter.calories(s.activeCalories)} kcal',
                style: VyroTextStyles.caption,
              ),
              const SizedBox(height: 14),
              VyroProgressBar(
                progress: progress,
                leftLabel: '${(progress * 100).round()} %',
                rightLabel: 'Heute',
              ),
              const SizedBox(height: 14),
              charts.when(
                data: (c) => MiniBarChart(
                  values: c.steps.map((e) => e.value).toList(),
                  labels: c.steps.map((e) => e.label).toList(),
                ),
                loading: () => const SizedBox(height: 56),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}
