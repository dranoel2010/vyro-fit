import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../providers/health_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/progress_bar.dart';
import '../../../shared/widgets/stat_row.dart';
import '../../../shared/widgets/loading_card.dart';

class CaloriesCard extends ConsumerWidget {
  final int animationIndex;

  const CaloriesCard({super.key, this.animationIndex = 2});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(todaySummaryProvider);

    return summary.when(
      loading: () => const LoadingCard(),
      error: (_, __) => const SizedBox.shrink(),
      data: (s) {
        final progress = (s.activeCalories / AppConstants.defaultCalorieGoal).clamp(0.0, 1.0);
        return VyroCard(
          animationDelay: Duration(milliseconds: animationIndex * 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('KALORIEN', style: VyroTextStyles.label),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    NumberFormatter.calories(s.activeCalories),
                    style: VyroTextStyles.dataValueSm,
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('aktiv', style: VyroTextStyles.caption),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              VyroProgressBar(
                progress: progress,
                leftLabel: '${NumberFormatter.calories(s.activeCalories)} / ${NumberFormatter.calories(AppConstants.defaultCalorieGoal)} kcal',
              ),
              const SizedBox(height: 14),
              StatRow(
                label: 'Gesamt (inkl. Grundumsatz)',
                value: '${NumberFormatter.calories(s.totalCalories)} kcal',
                showDivider: false,
              ),
              StatRow(
                label: 'Aktive Minuten',
                value: '${s.activeMinutes} min',
              ),
            ],
          ),
        );
      },
    );
  }
}
