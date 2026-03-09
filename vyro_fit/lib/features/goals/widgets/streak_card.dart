import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../providers/goal_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/loading_card.dart';

class StreakCard extends ConsumerWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);

    return streak.when(
      loading: () => const LoadingCard(height: 200),
      error: (_, __) => const SizedBox.shrink(),
      data: (s) {
        return VyroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('STREAK', style: VyroTextStyles.label),
                  const Spacer(),
                  Text('${s.currentStreak} Tage', style: VyroTextStyles.sub),
                ],
              ),
              const SizedBox(height: 16),
              // Aktuelle Streak-Zahlen
              Row(
                children: [
                  _StreakStat(label: 'Aktuell', value: '${s.currentStreak}', emoji: '🔥'),
                  const SizedBox(width: 24),
                  _StreakStat(label: 'Längster', value: '${s.longestStreak}', emoji: '🏆'),
                  const SizedBox(width: 24),
                  _StreakStat(label: 'Woche', value: '${s.weeklyGoalsCompleted}/7', emoji: '✅'),
                ],
              ),
              const SizedBox(height: 20),
              // 30-Tage-Grid
              Text('LETZTE 30 TAGE', style: VyroTextStyles.label),
              const SizedBox(height: 10),
              _DotGrid(days: s.last30Days),
            ],
          ),
        );
      },
    );
  }
}

class _StreakStat extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;

  const _StreakStat({
    required this.label,
    required this.value,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              value,
              style: VyroTextStyles.dataValueSm.copyWith(
                fontSize: 22,
                color: VyroColors.accent,
              ),
            ),
          ],
        ),
        Text(label, style: VyroTextStyles.caption),
      ],
    );
  }
}

class _DotGrid extends StatelessWidget {
  final List<bool> days;

  const _DotGrid({required this.days});

  @override
  Widget build(BuildContext context) {
    const dotsPerRow = 10;
    final rows = (30 / dotsPerRow).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: List.generate(dotsPerRow, (col) {
              final idx = row * dotsPerRow + col;
              final achieved = idx < days.length ? days[idx] : false;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: achieved ? VyroColors.accent : VyroColors.accentDim,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: achieved
                          ? [BoxShadow(color: VyroColors.accent.withOpacity(0.4), blurRadius: 4)]
                          : null,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
