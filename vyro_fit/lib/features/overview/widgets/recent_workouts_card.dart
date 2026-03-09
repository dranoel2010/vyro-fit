import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/utils/date_helper.dart';
import '../../../models/workout_data.dart';
import '../../../providers/workout_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/loading_card.dart';

class RecentWorkoutsCard extends ConsumerWidget {
  final int animationIndex;

  const RecentWorkoutsCard({super.key, this.animationIndex = 5});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(recentWorkoutsProvider);

    return workouts.when(
      loading: () => const LoadingCard(height: 140),
      error: (_, __) => const SizedBox.shrink(),
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();
        final recent = list.take(3).toList();
        return VyroCard(
          animationDelay: Duration(milliseconds: animationIndex * 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('LETZTE WORKOUTS', style: VyroTextStyles.label),
                  Text('${list.length} diese Woche', style: VyroTextStyles.caption),
                ],
              ),
              const SizedBox(height: 12),
              ...recent.map((w) => _WorkoutTileSmall(workout: w)),
            ],
          ),
        );
      },
    );
  }
}

class _WorkoutTileSmall extends StatelessWidget {
  final WorkoutData workout;

  const _WorkoutTileSmall({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: VyroColors.accentDim,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(workout.type.emoji, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(workout.type.label, style: VyroTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                Text(DateHelper.formatRelativeDay(workout.startTime), style: VyroTextStyles.caption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(NumberFormatter.calories(workout.activeCalories), style: VyroTextStyles.body.copyWith(color: VyroColors.accent)),
              Text(DateHelper.formatDuration(workout.duration), style: VyroTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
