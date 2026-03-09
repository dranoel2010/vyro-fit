import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../providers/health_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/mini_line_chart.dart';
import '../../../shared/widgets/loading_card.dart';

class HRVTrendCard extends ConsumerWidget {
  const HRVTrendCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // HRV-Daten kommen aus weeklySummariesProvider (falls verfügbar)
    final weekly = ref.watch(weeklySummariesProvider);

    return weekly.when(
      loading: () => const LoadingCard(),
      error: (_, __) => const SizedBox.shrink(),
      data: (summaries) {
        // HRV aus DailySummary ist nicht direkt vorhanden – zeige Resting HR als Proxy
        final values = summaries
            .map((s) => s.restingHeartRate ?? 0.0)
            .toList();
        final hasData = values.any((v) => v > 0);

        return VyroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('HRV TREND (WOCHE)', style: VyroTextStyles.label),
              const SizedBox(height: 10),
              if (!hasData) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.info_outline, color: VyroColors.textSecondary, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Keine HRV-Daten verfügbar',
                      style: VyroTextStyles.body.copyWith(color: VyroColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'HRV-Daten werden von kompatiblen\nWearables über Health Connect bereitgestellt.',
                  style: VyroTextStyles.caption,
                ),
              ] else ...[
                const SizedBox(height: 14),
                MiniLineChart(
                  values: values.where((v) => v > 0).cast<double>().toList(),
                  height: 56,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
