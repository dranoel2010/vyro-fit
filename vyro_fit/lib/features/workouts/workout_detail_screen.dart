import 'package:flutter/material.dart';
import '../../core/theme/vyro_colors.dart';
import '../../core/theme/vyro_text_styles.dart';
import '../../core/utils/number_formatter.dart';
import '../../core/utils/date_helper.dart';
import '../../models/workout_data.dart';
import '../../shared/widgets/stat_row.dart';
import '../../shared/widgets/vyro_card.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final WorkoutData workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyroColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Zurück-Button + Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: VyroColors.textPrimary, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(workout.type.label, style: VyroTextStyles.title.copyWith(fontSize: 20)),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Workout-Icon groß
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: VyroColors.accentDim,
                        shape: BoxShape.circle,
                        border: Border.all(color: VyroColors.accent.withOpacity(0.3), width: 1),
                      ),
                      child: Center(
                        child: Text(workout.type.icon, style: const TextStyle(fontSize: 36)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      DateHelper.formatRelativeDay(workout.startTime),
                      style: VyroTextStyles.caption,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Haupt-Stats
                  VyroCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ÜBERSICHT', style: VyroTextStyles.label),
                        const SizedBox(height: 12),
                        StatRow(
                          label: 'Dauer',
                          value: DateHelper.formatDuration(workout.duration),
                          showDivider: true,
                        ),
                        StatRow(
                          label: 'Verbrannte Kalorien',
                          value: '${NumberFormatter.calories(workout.caloriesBurned)} kcal',
                          valueColor: VyroColors.accent,
                          showDivider: workout.distanceMeters != null || workout.avgHeartRate != null,
                        ),
                        if (workout.distanceMeters != null)
                          StatRow(
                            label: 'Distanz',
                            value: NumberFormatter.distance(workout.distanceMeters!),
                            showDivider: workout.avgHeartRate != null,
                          ),
                        if (workout.avgHeartRate != null)
                          StatRow(
                            label: 'Ø Herzfrequenz',
                            value: NumberFormatter.bpm(workout.avgHeartRate!),
                            showDivider: workout.maxHeartRate != null,
                          ),
                        if (workout.maxHeartRate != null)
                          StatRow(
                            label: 'Max Herzfrequenz',
                            value: NumberFormatter.bpm(workout.maxHeartRate!),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Zeit-Details
                  VyroCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ZEITRAUM', style: VyroTextStyles.label),
                        const SizedBox(height: 12),
                        StatRow(
                          label: 'Beginn',
                          value: DateHelper.formatTime(workout.startTime),
                          showDivider: true,
                        ),
                        StatRow(
                          label: 'Ende',
                          value: DateHelper.formatTime(workout.endTime),
                          showDivider: workout.sourceName != null,
                        ),
                        if (workout.sourceName != null)
                          StatRow(
                            label: 'Quelle',
                            value: workout.sourceName!,
                          ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
