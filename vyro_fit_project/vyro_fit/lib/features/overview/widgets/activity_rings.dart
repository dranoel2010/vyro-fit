import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/vyro_colors.dart';

/// Apple Watch-style Activity Rings
class ActivityRings extends StatelessWidget {
  final double moveProgress;
  final double exerciseProgress;
  final double standProgress;
  final double size;

  const ActivityRings({
    super.key,
    required this.moveProgress,
    required this.exerciseProgress,
    required this.standProgress,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingsPainter(
          moveProgress: moveProgress,
          exerciseProgress: exerciseProgress,
          standProgress: standProgress,
        ),
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  final double moveProgress;
  final double exerciseProgress;
  final double standProgress;

  _RingsPainter({
    required this.moveProgress,
    required this.exerciseProgress,
    required this.standProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 12.0;
    const gap = 14.0;

    final rings = [
      (size.width / 2 - strokeWidth / 2, moveProgress, VyroColors.moveRing),
      (size.width / 2 - strokeWidth / 2 - gap, exerciseProgress, VyroColors.exerciseRing),
      (size.width / 2 - strokeWidth / 2 - gap * 2, standProgress, VyroColors.standRing),
    ];

    for (final (radius, progress, color) in rings) {
      // Hintergrund-Ring
      final bgPaint = Paint()
        ..color = color.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(center, radius, bgPaint);

      // Fortschritts-Ring
      final fgPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * pi * progress.clamp(0.0, 1.0);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2, // Start oben
        sweepAngle,
        false,
        fgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) {
    return moveProgress != oldDelegate.moveProgress ||
        exerciseProgress != oldDelegate.exerciseProgress ||
        standProgress != oldDelegate.standProgress;
  }
}

/// Legende für die Activity Rings
class ActivityRingLegend extends StatelessWidget {
  final double moveValue;
  final double moveGoal;
  final int exerciseValue;
  final int exerciseGoal;
  final int standValue;
  final int standGoal;

  const ActivityRingLegend({
    super.key,
    required this.moveValue,
    required this.moveGoal,
    required this.exerciseValue,
    required this.exerciseGoal,
    required this.standValue,
    required this.standGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendRow(
          color: VyroColors.moveRing,
          label: 'Bewegen',
          value: '${moveValue.round()}',
          goal: '/${moveGoal.round()} kcal',
        ),
        const SizedBox(height: 8),
        _LegendRow(
          color: VyroColors.exerciseRing,
          label: 'Trainieren',
          value: '$exerciseValue',
          goal: '/$exerciseGoal min',
        ),
        const SizedBox(height: 8),
        _LegendRow(
          color: VyroColors.standRing,
          label: 'Stehen',
          value: '$standValue',
          goal: '/$standGoal h',
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final String goal;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: VyroColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: VyroColors.textPrimary,
          ),
        ),
        Text(
          goal,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: VyroColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
