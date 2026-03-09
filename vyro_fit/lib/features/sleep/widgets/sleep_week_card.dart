import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../providers/sleep_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/mini_bar_chart.dart';
import '../../../shared/widgets/loading_card.dart';

class SleepWeekCard extends ConsumerWidget {
  const SleepWeekCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekly = ref.watch(weeklySleepProvider);

    return weekly.when(
      loading: () => const LoadingCard(),
      error: (_, __) => const SizedBox.shrink(),
      data: (sessions) {
        if (sessions.isEmpty) return const SizedBox.shrink();

        final days = DateHelper.lastNDays(7);
        final values = <double>[];
        final labels = <String>[];

        for (final day in days) {
          final match = sessions.where((s) =>
              s.date.year == day.year &&
              s.date.month == day.month &&
              s.date.day == day.day).firstOrNull;
          values.add(match?.totalHours ?? 0);
          labels.add(DateHelper.shortWeekday(day));
        }

        final avg = values.where((v) => v > 0).isNotEmpty
            ? values.where((v) => v > 0).reduce((a, b) => a + b) /
                values.where((v) => v > 0).length
            : 0.0;

        return VyroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SCHLAF DIESE WOCHE', style: VyroTextStyles.label),
                  Text(
                    'Ø ${NumberFormatter.hoursToHM(avg)}',
                    style: VyroTextStyles.caption,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              MiniBarChart(
                values: values,
                labels: labels,
                color: VyroColors.sleepDeep,
              ),
            ],
          ),
        );
      },
    );
  }
}
