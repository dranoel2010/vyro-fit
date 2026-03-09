import 'package:flutter/material.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/utils/date_helper.dart';
import '../../../models/workout_data.dart';

class WorkoutListTile extends StatelessWidget {
  final WorkoutData workout;
  final VoidCallback? onTap;

  const WorkoutListTile({
    super.key,
    required this.workout,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: VyroColors.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // Emoji-Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: VyroColors.accentDim,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(
                child: Text(
                  workout.type.icon,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.type.label,
                    style: VyroTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    DateHelper.formatRelativeDay(workout.startTime),
                    style: VyroTextStyles.caption,
                  ),
                ],
              ),
            ),
            // Stats
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  NumberFormatter.calories(workout.caloriesBurned),
                  style: VyroTextStyles.body.copyWith(
                    color: VyroColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  DateHelper.formatDuration(workout.duration),
                  style: VyroTextStyles.caption,
                ),
              ],
            ),
            if (onTap != null) ...[
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: VyroColors.textSecondary, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}
