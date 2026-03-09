import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../data/aggregation/hr_zone_calculator.dart';
import '../../../models/heart_rate_data.dart';
import '../../../providers/health_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/loading_card.dart';

class HRZonesCard extends ConsumerWidget {
  const HRZonesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeline = ref.watch(todayHRTimelineProvider);

    return timeline.when(
      loading: () => const LoadingCard(height: 220),
      error: (_, __) => const SizedBox.shrink(),
      data: (points) {
        final zoneDurations = HRZoneCalculator.calculateZoneDistribution(points);
        final totalMs = zoneDurations.values
            .fold<int>(0, (sum, d) => sum + d.inMilliseconds);

        return VyroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('HERZFREQUENZ-ZONEN', style: VyroTextStyles.label),
              const SizedBox(height: 14),
              ...HRZone.values.map((zone) {
                final dur = zoneDurations[zone] ?? Duration.zero;
                final pct = totalMs > 0 ? dur.inMilliseconds / totalMs : 0.0;
                final color = Color(HRZoneCalculator.zoneColorValue(zone));
                final (minBpm, maxBpm) = HRZoneCalculator.zoneLimits(zone);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(zone.label, style: VyroTextStyles.caption),
                          Text(
                            '${minBpm.round()}–${maxBpm.round()} BPM · ${dur.inMinutes} min',
                            style: VyroTextStyles.caption,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Stack(
                          children: [
                            Container(height: 6, color: VyroColors.accentDim),
                            FractionallySizedBox(
                              widthFactor: pct.clamp(0.0, 1.0),
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: color,
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withOpacity(0.4),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
