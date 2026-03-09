import 'package:flutter/material.dart';
import '../../core/theme/vyro_colors.dart';
import '../../core/theme/vyro_text_styles.dart';
import '../../models/sleep_data.dart';

/// Horizontaler Schlafphasen-Balken mit Legende
class SleepPhaseBar extends StatelessWidget {
  final SleepData sleep;
  final double height;

  const SleepPhaseBar({
    super.key,
    required this.sleep,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    final phases = sleep.phasePercentages; // Map<String, double>
    final awake = phases['awake'] ?? 0.0;
    final light = phases['light'] ?? 0.0;
    final deep = phases['deep'] ?? 0.0;
    final rem = phases['rem'] ?? 0.0;
    final hasData = awake + light + deep + rem > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Balken
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: SizedBox(
            height: height,
            child: hasData
                ? Row(children: [
                    if (awake > 0) _PhaseSegment(flex: (awake * 100).round(), color: VyroColors.sleepAwake),
                    if (light > 0) _PhaseSegment(flex: (light * 100).round(), color: VyroColors.sleepLight),
                    if (deep > 0) _PhaseSegment(flex: (deep * 100).round(), color: VyroColors.sleepDeep),
                    if (rem > 0) _PhaseSegment(flex: (rem * 100).round(), color: VyroColors.sleepRem),
                  ])
                : Container(color: VyroColors.accentDim),
          ),
        ),
        const SizedBox(height: 10),
        // Legende
        Row(
          children: [
            _LegendItem(color: VyroColors.sleepRem, label: 'REM'),
            const SizedBox(width: 16),
            _LegendItem(color: VyroColors.sleepDeep, label: 'Tief'),
            const SizedBox(width: 16),
            _LegendItem(color: VyroColors.sleepLight, label: 'Leicht'),
            const SizedBox(width: 16),
            _LegendItem(color: VyroColors.sleepAwake, label: 'Wach'),
          ],
        ),
      ],
    );
  }
}

class _PhaseSegment extends StatelessWidget {
  final int flex;
  final Color color;

  const _PhaseSegment({required this.flex, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 12,
        color: color,
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: VyroTextStyles.caption),
      ],
    );
  }
}
