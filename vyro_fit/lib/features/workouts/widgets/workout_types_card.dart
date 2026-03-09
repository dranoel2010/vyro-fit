import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../models/workout_data.dart';
import '../../../providers/workout_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/loading_card.dart';

class WorkoutTypesCard extends ConsumerWidget {
  const WorkoutTypesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(extendedWorkoutsProvider);

    return workouts.when(
      loading: () => const LoadingCard(),
      error: (_, __) => const SizedBox.shrink(),
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();

        // Zähle nach Typ
        final counts = <WorkoutType, int>{};
        for (final w in list) {
          counts[w.type] = (counts[w.type] ?? 0) + 1;
        }
        final sorted = counts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final total = list.length;

        return VyroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TRAININGSARTEN (14 TAGE)', style: VyroTextStyles.label),
              const SizedBox(height: 14),
              ...sorted.take(5).map((entry) {
                final pct = entry.value / total;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(entry.key.icon, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(entry.key.label, style: VyroTextStyles.caption),
                          ),
                          Text(
                            '${entry.value}× · ${(pct * 100).round()} %',
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
                              widthFactor: pct,
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: VyroColors.accent,
                                  boxShadow: [
                                    BoxShadow(
                                      color: VyroColors.accent.withOpacity(0.4),
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
