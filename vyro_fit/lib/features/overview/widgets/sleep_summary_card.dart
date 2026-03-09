import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../providers/sleep_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/sleep_phase_bar.dart';
import '../../../shared/widgets/loading_card.dart';

class SleepSummaryCard extends ConsumerWidget {
  final int animationIndex;

  const SleepSummaryCard({super.key, this.animationIndex = 4});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastNight = ref.watch(lastNightProvider);
    final score = ref.watch(sleepScoreProvider);

    return lastNight.when(
      loading: () => const LoadingCard(height: 160),
      error: (_, __) => const SizedBox.shrink(),
      data: (sleep) {
        if (sleep == null) {
          return VyroCard(
            animationDelay: Duration(milliseconds: animationIndex * 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SCHLAF', style: VyroTextStyles.label),
                const SizedBox(height: 16),
                Text('Keine Schlafdaten', style: VyroTextStyles.body.copyWith(color: VyroColors.textSecondary)),
              ],
            ),
          );
        }
        return VyroCard(
          animationDelay: Duration(milliseconds: animationIndex * 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SCHLAF', style: VyroTextStyles.label),
                  score.when(
                    data: (s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: VyroColors.accentDim,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Score $s', style: VyroTextStyles.sub),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                NumberFormatter.hoursToHM(sleep.totalHours),
                style: VyroTextStyles.dataValueSm,
              ),
              const SizedBox(height: 4),
              Text(
                '${_formatTime(sleep.bedtime)} – ${_formatTime(sleep.wakeTime)}',
                style: VyroTextStyles.caption,
              ),
              const SizedBox(height: 14),
              SleepPhaseBar(sleep: sleep),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
