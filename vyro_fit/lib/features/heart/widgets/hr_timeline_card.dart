import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../core/utils/number_formatter.dart';
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
      loading: () => const LoadingCard(height: 220),
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

        final bpms = points.map((p) => p.bpm).toList();
        final minBpm = bpms.reduce((a, b) => a < b ? a : b).round();
        final maxBpm = bpms.reduce((a, b) => a > b ? a : b).round();

        return VyroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('HERZFREQUENZ HEUTE', style: VyroTextStyles.label),
                  Text(
                    'Min ${NumberFormatter.bpm(minBpm.toDouble())} · Max ${NumberFormatter.bpm(maxBpm.toDouble())}',
                    style: VyroTextStyles.caption,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              GlowLineChart(
                values: bpms,
                labels: points.map((p) {
                  final h = p.timestamp.hour;
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
