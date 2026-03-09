import 'package:flutter/material.dart';
import '../../core/theme/vyro_colors.dart';
import '../../core/theme/vyro_text_styles.dart';

/// Dünner horizontaler Fortschrittsbalken (3px) mit optionalen Labels
class VyroProgressBar extends StatelessWidget {
  final double progress; // 0.0 – 1.0
  final String? leftLabel;
  final String? rightLabel;
  final Color color;
  final double height;

  const VyroProgressBar({
    super.key,
    required this.progress,
    this.leftLabel,
    this.rightLabel,
    this.color = VyroColors.accent,
    this.height = 3,
  });

  @override
  Widget build(BuildContext context) {
    final p = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leftLabel != null || rightLabel != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (leftLabel != null)
                Text(leftLabel!, style: VyroTextStyles.caption),
              if (rightLabel != null)
                Text(rightLabel!, style: VyroTextStyles.caption),
            ],
          ),
          const SizedBox(height: 6),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: Stack(
            children: [
              // Track
              Container(
                height: height,
                color: VyroColors.accentDim,
              ),
              // Fill mit Glow
              FractionallySizedBox(
                widthFactor: p,
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(height / 2),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
