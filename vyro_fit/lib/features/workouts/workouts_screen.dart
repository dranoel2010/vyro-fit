import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/vyro_colors.dart';
import '../../core/theme/vyro_text_styles.dart';
import '../../core/utils/date_helper.dart';
import '../../providers/workout_providers.dart';
import './widgets/weekly_volume_card.dart';
import './widgets/workout_types_card.dart';
import './widgets/workout_list_tile.dart';
import './workout_detail_screen.dart';
import '../../shared/widgets/loading_card.dart';

class WorkoutsScreen extends ConsumerWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(extendedWorkoutsProvider);

    return Scaffold(
      backgroundColor: VyroColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 52, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AKTIVITÄT', style: VyroTextStyles.label),
                    const SizedBox(height: 6),
                    Text('Workouts', style: VyroTextStyles.title),
                    const SizedBox(height: 4),
                    Text(DateHelper.formatHeaderDate(DateTime.now()), style: VyroTextStyles.caption),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const WeeklyVolumeCard(),
                  const SizedBox(height: 14),
                  const WorkoutTypesCard(),
                  const SizedBox(height: 20),
                  Text('LETZTE 14 TAGE', style: VyroTextStyles.label),
                  const SizedBox(height: 12),
                ]),
              ),
            ),
            workouts.when(
              loading: () => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const LoadingCard(),
                    const SizedBox(height: 10),
                    const LoadingCard(),
                  ]),
                ),
              ),
              error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
              data: (list) {
                if (list.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Icon(Icons.directions_run, color: VyroColors.textSecondary, size: 40),
                            const SizedBox(height: 12),
                            Text(
                              'Keine Workouts in den letzten 14 Tagen',
                              style: VyroTextStyles.body.copyWith(color: VyroColors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => WorkoutListTile(
                        workout: list[i],
                        onTap: () => Navigator.push(
                          ctx,
                          MaterialPageRoute(
                            builder: (_) => WorkoutDetailScreen(workout: list[i]),
                          ),
                        ),
                      ),
                      childCount: list.length,
                    ),
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
