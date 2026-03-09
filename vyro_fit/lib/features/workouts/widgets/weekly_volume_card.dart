import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../core/utils/date_helper.dart';
import '../../../providers/workout_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/mini_bar_chart.dart';
import '../../../shared/widgets/loading_card.dart';

class WeeklyVolumeCard extends ConsumerWidget {
  const WeeklyVolumeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(recentWorkoutsProvider);
    final count = ref.watch(weeklyWorkoutCountProvider);

    return workouts.when(
      loading: () => const LoadingCard(),
      error: (_, __) => const SizedBox.shrink(),
      data: (list) {
        final days = DateHelper.lastNDays(7);
        final minutesByDay = <double>[];
        final labels = <String>[];

        for (final day in days) {
          final dayWorkouts = list.where((w) =>
              w.startTime.year == day.year &&
              w.startTime.month == day.month &&
              w.startTime.day == day.day);
          final mins = dayWorkouts.fold<int>(
              0, (sum, w) => sum + w.duration.inMinutes);
          minutesByDay.add(mins.toDouble());
          labels.add(DateHelper.shortWeekday(day));
        }

        final totalMins = list.fold<int>(0, (s, w) => s + w.duration.inMinutes);
        final totalHours = totalMins ~/ 60;
        final totalRem = totalMins % 60;

        return VyroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('VOLUMEN DIESE WOCHE', style: VyroTextStyles.label),
                  count.when(
                    data: (c) => Text('$c Einheiten', style: VyroTextStyles.caption),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                totalHours > 0 ? '${totalHours}h ${totalRem}min' : '${totalMins}min',
                style: VyroTextStyles.dataValueSm,
              ),
              const SizedBox(height: 14),
              MiniBarChart(
                values: minutesByDay,
                labels: labels,
              ),
            ],
          ),
        );
      },
    );
  }
}
