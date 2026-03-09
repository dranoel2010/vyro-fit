import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../providers/health_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/mini_line_chart.dart';
import '../../../shared/widgets/loading_card.dart';

class HeartRateCard extends ConsumerWidget {
  final int animationIndex;

  const HeartRateCard({super.key, this.animationIndex = 3});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(todaySummaryProvider);
    final timeline = ref.watch(todayHRTimelineProvider);

    return summary.when(
      loading: () => const LoadingCard(),
      error: (_, __) => const SizedBox.shrink(),
      data: (s) {
        return VyroCard(
          animationDelay: Duration(milliseconds: animationIndex * 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('HERZFREQUENZ', style: VyroTextStyles.label),
                  Icon(Icons.favorite, color: VyroColors.accent, size: 16),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    s.restingHeartRate > 0
                        ? NumberFormatter.bpm(s.restingHeartRate)
                        : '--',
                    style: VyroTextStyles.dataValueSm,
                  ),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('BPM Ruhe', style: VyroTextStyles.caption),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              timeline.when(
                data: (points) {
                  if (points.isEmpty) {
                    return Center(
                      child: Text('Keine Daten', style: VyroTextStyles.caption),
                    );
                  }
                  return MiniLineChart(
                    values: points.map((p) => p.value.toDouble()).toList(),
                    height: 56,
                  );
                },
                loading: () => const SizedBox(height: 56),
                error: (_, __) => const SizedBox(height: 56),
              ),
            ],
          ),
        );
      },
    );
  }
}
