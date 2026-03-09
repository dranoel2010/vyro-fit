import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../core/theme/vyro_colors.dart';

/// Mini-Balkendiagramm für 7-Tage-Übersicht (Schritte, Kalorien etc.)
/// Letzter Balken = volle Farbe + Glow, Rest = 25% Opacity
class MiniBarChart extends StatelessWidget {
  final List<double> values;   // Rohdaten (werden intern normalisiert)
  final List<String> labels;   // Mo, Di, Mi, Do, Fr, Sa, So
  final Color color;
  final double height;
  final int? highlightIndex;   // null = letzter Balken

  const MiniBarChart({
    super.key,
    required this.values,
    required this.labels,
    this.color = VyroColors.accent,
    this.height = 56,
    this.highlightIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return SizedBox(height: height);

    final hi = highlightIndex ?? (values.length - 1);
    final maxVal = values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: height + 18, // + label-Höhe
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (i) {
          final norm = maxVal > 0 ? values[i] / maxVal : 0.0;
          final isHighlighted = i == hi;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Bar
                  _Bar(
                    heightFraction: norm.clamp(0.0, 1.0),
                    maxHeight: height,
                    color: color,
                    isHighlighted: isHighlighted,
                  ),
                  const SizedBox(height: 6),
                  // Label
                  Text(
                    i < labels.length ? labels[i] : '',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 9,
                      fontWeight: FontWeight.w300,
                      color: VyroColors.textSecondary,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double heightFraction;
  final double maxHeight;
  final Color color;
  final bool isHighlighted;

  const _Bar({
    required this.heightFraction,
    required this.maxHeight,
    required this.color,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    final barHeight = (maxHeight * heightFraction).clamp(4.0, maxHeight);

    return Container(
      height: barHeight,
      decoration: BoxDecoration(
        color: isHighlighted ? color : color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(4),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
    );
  }
}
