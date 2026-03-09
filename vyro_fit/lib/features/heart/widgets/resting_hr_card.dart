import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../providers/health_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/stat_row.dart';
import '../../../shared/widgets/loading_card.dart';

class RestingHRCard extends ConsumerWidget {
  const RestingHRCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(todaySummaryProvider);
    final trend = ref.watch(todayTrendProvider);

    return summary.when(
      loading: () => const LoadingCard(),
      error: (_, __) => const SizedBox.shrink(),
      data: (s) {
        return VyroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('RUHE-HERZFREQUENZ', style: VyroTextStyles.label),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    (s.restingHeartRate ?? 0) > 0
                        ? NumberFormatter.bpm(s.restingHeartRate!)
                        : '--',
                    style: VyroTextStyles.dataValue,
                  ),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('BPM', style: VyroTextStyles.caption),
                  ),
                  const Spacer(),
                  trend.when(
                    data: (t) => Text(t, style: VyroTextStyles.sub),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const StatRow(label: 'Normalbereich (Alter 15)', value: '60–100 BPM', showDivider: true),
              const StatRow(label: 'Max Herzfrequenz', value: '205 BPM'),
            ],
          ),
        );
      },
    );
  }
}
