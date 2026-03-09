import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../providers/sleep_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/score_ring.dart';
import '../../../shared/widgets/stat_row.dart';
import '../../../shared/widgets/loading_card.dart';

class SleepScoreCard extends ConsumerWidget {
  const SleepScoreCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(sleepScoreProvider);
    final sleep = ref.watch(lastNightProvider);

    return score.when(
      loading: () => const LoadingCard(height: 160),
      error: (_, __) => const SizedBox.shrink(),
      data: (s) {
        return VyroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SCHLAF-SCORE', style: VyroTextStyles.label),
              const SizedBox(height: 16),
              Row(
                children: [
                  ScoreRing(score: s, size: 100),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _label(s),
                          style: VyroTextStyles.title.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Basierend auf Dauer,\nTiefschlaf und REM-Anteil',
                          style: VyroTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              sleep.when(
                data: (d) {
                  if (d == null) return const SizedBox.shrink();
                  final phases = d.phasePercentages;
                  return Column(
                    children: [
                      const SizedBox(height: 14),
                      StatRow(
                        label: 'Dauer',
                        value: '${(phases['deep'] != null ? '${(phases['deep']! * 100).round()}%' : '--')} Tiefschlaf',
                        showDivider: true,
                      ),
                      StatRow(
                        label: 'REM-Anteil',
                        value: phases['rem'] != null
                            ? '${(phases['rem']! * 100).round()} %'
                            : '--',
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  String _label(int score) {
    if (score >= 90) return 'Ausgezeichnet';
    if (score >= 75) return 'Gut';
    if (score >= 55) return 'Okay';
    if (score >= 40) return 'Mäßig';
    return 'Schlecht';
  }
}
