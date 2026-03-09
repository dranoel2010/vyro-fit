import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../data/aggregation/hr_zone_calculator.dart';
import '../../../providers/health_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/loading_card.dart';

class HRZonesCard extends ConsumerWidget {
  const HRZonesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeline = ref.watch(todayHRTimelineProvider);

    return timeline.when(
      loading: () => const LoadingCard(height: 200),
      error: (_, __) => const SizedBox.shrink(),
      data: (points) {
        final hrValues = points.map((p) => p.value).toList();
        final zones = HRZoneCalculator.calculateZoneDistribution(hrValues);
        final zoneLabels = ['Erholung', 'Fettverbrennung', 'Aerob', 'Anaerob', 'Maximal'];
        final zoneColors = [
          const Color(0xFF64B5F6),
          const Color(0xFF4CAF50),
          const Color(0xFFFF9800),
          const Color(0xFFFF5722),
          const Color(0xFFF44336),
        ];

        return VyroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('HERZFREQUENZ-ZONEN', style: VyroTextStyles.label),
              const SizedBox(height: 14),
              ...List.generate(5, (i) {
                final zone = HRZone.values[i];
                final percent = zones[zone] ?? 0.0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Zone ${i + 1}: ${zoneLabels[i]}', style: VyroTextStyles.caption),
                          Text('${(percent * 100).round()} %', style: VyroTextStyles.caption),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Stack(
                          children: [
                            Container(height: 6, color: VyroColors.accentDim),
                            FractionallySizedBox(
                              widthFactor: percent,
                              child: Container(height: 6, color: zoneColors[i]),
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
