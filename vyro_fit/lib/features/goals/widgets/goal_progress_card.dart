import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../models/goal.dart';
import '../../../providers/goal_providers.dart';
import '../../../providers/health_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/progress_bar.dart';
import '../../../shared/widgets/loading_card.dart';

class GoalProgressCard extends ConsumerWidget {
  const GoalProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(persistedGoalsProvider);
    final summary = ref.watch(todaySummaryProvider);

    return goals.when(
      loading: () => const LoadingCard(height: 240),
      error: (_, __) => const SizedBox.shrink(),
      data: (goalList) {
        return VyroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TAGESZIELE', style: VyroTextStyles.label),
              const SizedBox(height: 14),
              ...goalList.map((goal) {
                final current = summary.when(
                  data: (s) => _getCurrent(s, goal.type),
                  loading: () => 0.0,
                  error: (_, __) => 0.0,
                );
                final progress = (current / goal.target).clamp(0.0, 1.0);
                final done = current >= goal.target;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(goal.type.icon, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(goal.type.label, style: VyroTextStyles.body),
                          const Spacer(),
                          if (done)
                            Icon(Icons.check_circle, color: VyroColors.accent, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${_format(current, goal.type)} / ${_format(goal.target, goal.type)}',
                            style: VyroTextStyles.caption,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      VyroProgressBar(progress: progress),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  double _getCurrent(dynamic s, GoalType type) {
    return switch (type) {
      GoalType.steps => s.steps.toDouble(),
      GoalType.calories => s.activeCalories,
      GoalType.sleep => 0.0, // sleep comes from SleepRepository
      GoalType.workoutsPerWeek => 0.0,
      GoalType.activeMinutes => s.activeMinutes.toDouble(),
    };
  }

  String _format(double value, GoalType type) {
    return switch (type) {
      GoalType.steps => NumberFormatter.steps(value),
      GoalType.calories => '${value.round()} kcal',
      GoalType.sleep => '${value.toStringAsFixed(1)} h',
      GoalType.workoutsPerWeek => '${value.round()}',
      GoalType.activeMinutes => '${value.round()} min',
    };
  }
}
