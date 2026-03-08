import 'package:flutter/material.dart';

/// VYRO Fit Farbsystem – Apple Health inspiriert
class VyroColors {
  VyroColors._();

  // Backgrounds
  static const Color background = Color(0xFFF2F1F6);
  static const Color card = Color(0xFFFFFFFF);

  // Activity Rings
  static const Color moveRing = Color(0xFFFA2D55);
  static const Color exerciseRing = Color(0xFFA2FF00);
  static const Color standRing = Color(0xFF00D4FF);

  // Kategorie-Farben
  static const Color steps = Color(0xFF34C759);
  static const Color calories = Color(0xFFFF9500);
  static const Color heartRate = Color(0xFFFF3B30);
  static const Color sleep = Color(0xFF5856D6);
  static const Color workout = Color(0xFFFF9500);

  // Text
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFFAEAEB2);

  // UI
  static const Color separator = Color(0xFFE5E5EA);

  /// Gibt die gedimmte Version einer Farbe zurück (für Hintergründe)
  static Color dimmed(Color color, [double opacity = 0.12]) {
    return color.withOpacity(opacity);
  }
}
