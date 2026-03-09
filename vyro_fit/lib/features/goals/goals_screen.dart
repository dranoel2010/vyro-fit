import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/vyro_colors.dart';
import '../../core/theme/vyro_text_styles.dart';
import './widgets/streak_card.dart';
import './widgets/goal_progress_card.dart';
import './widgets/weekly_score_card.dart';

class GoalsScreen extends ConsumerWidget {
  final VoidCallback? onNavigateToSettings;

  const GoalsScreen({super.key, this.onNavigateToSettings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 52, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FORTSCHRITT', style: VyroTextStyles.label),
                const SizedBox(height: 6),
                Text('Ziele', style: VyroTextStyles.title),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const StreakCard(),
              const SizedBox(height: 14),
              const GoalProgressCard(),
              const SizedBox(height: 14),
              const WeeklyScoreCard(),
              const SizedBox(height: 20),
              // Button "Ziele anpassen"
              FilledButton.icon(
                onPressed: onNavigateToSettings,
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Ziele anpassen'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: VyroColors.accentDim,
                  foregroundColor: VyroColors.accent,
                ),
              ),
            ]),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
