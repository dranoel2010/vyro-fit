import 'package:flutter/material.dart';
import '../../core/theme/vyro_colors.dart';

/// Einheitliche Karte im VYRO Fit Design
class VyroCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const VyroCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: VyroColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

/// Header für Karten (Icon + Label)
class VyroCardHeader extends StatelessWidget {
  final String icon;
  final String label;
  final Color? color;

  const VyroCardHeader({
    super.key,
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color ?? VyroColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Große Statistik-Anzeige
class VyroBigStat extends StatelessWidget {
  final String value;
  final String? unit;
  final String? subtitle;
  final Color? subtitleColor;

  const VyroBigStat({
    super.key,
    required this.value,
    this.unit,
    this.subtitle,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: VyroColors.textPrimary,
                  letterSpacing: -1.5,
                  fontFeatureSettings: "'tnum'",
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 3),
                Text(
                  unit!,
                  style: const TextStyle(
                    fontSize: 15,
                    color: VyroColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor ?? VyroColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
