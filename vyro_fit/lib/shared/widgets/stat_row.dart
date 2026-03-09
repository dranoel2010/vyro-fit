import 'package:flutter/material.dart';
import '../../core/theme/vyro_text_styles.dart';
import '../../core/theme/vyro_colors.dart';

/// Einfache Label–Wert-Zeile (links Label, rechts Wert)
class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool showDivider;

  const StatRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: VyroTextStyles.body.copyWith(color: VyroColors.textSecondary)),
              Text(
                value,
                style: VyroTextStyles.body.copyWith(
                  color: valueColor ?? VyroColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(color: VyroColors.accentDim, height: 1, thickness: 0.5),
      ],
    );
  }
}
