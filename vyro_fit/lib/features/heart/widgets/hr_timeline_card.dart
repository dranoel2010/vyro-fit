import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../providers/health_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/glow_line_chart.dart';
import '../../../shared/widgets/loading_card.dart';

class HRTimelineCard extends ConsumerWidget {
  const HRTimelineCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeline = ref.watch(todayHRTimelineProvider);

    return timeline.when(
      loading: () => const LoadingCard(height: 200),
      error: (_, __) => const SizedBox.shrink(),
      data: (points) {
        if (points.isEmpty) {
          return VyroCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HERZFREQUENZ HEUTE', style: VyroTextStyles.label),
                const SizedBox(height: 20),
                Center(
                  child: Text('Keine Daten', style: VyroTextStyles.body.copyWith(color: VyroColors.textSecondary)),
                ),
              ],
            ),
          );
        }
        return VyroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('HERZFREQUENZ HEUTE', style: VyroTextStyles.label),
              const SizedBox(height: 14),
              GlowLineChart(
                values: points.map((p) => p.value.toDouble()).toList(),
                labels: points.map((p) {
                  final h = p.time.hour;
                  return h % 6 == 0 ? '${h}h' : '';
                }).toList(),
                height: 140,
              ),
            ],
          ),
        );
      },
    );
  }
}
