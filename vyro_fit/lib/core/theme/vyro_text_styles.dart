import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vyro_colors.dart';

/// VYRO Fit Typografie
/// Nur 2 Schriftstärken: 300 (Light) und 700 (Bold)
/// Font: Outfit (Google Fonts)
class VyroTextStyles {
  VyroTextStyles._();

  /// Seitentitel: 26px, Bold
  static TextStyle get title => GoogleFonts.outfit(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: VyroColors.textPrimary,
        letterSpacing: -0.5,
      );

  /// Datenwerte groß: 42px, Bold, tabular-nums
  static TextStyle get dataValue => GoogleFonts.outfit(
        fontSize: 42,
        fontWeight: FontWeight.w700,
        color: VyroColors.textPrimary,
        letterSpacing: -2,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Datenwerte mittel: 36px, Bold, tabular-nums
  static TextStyle get dataValueSm => GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: VyroColors.textPrimary,
        letterSpacing: -2,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Labels: 12px, Light, UPPERCASE, letter-spacing 1.2
  static TextStyle get label => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: VyroColors.textSecondary,
        letterSpacing: 1.2,
      );

  /// Body: 14px, Light
  static TextStyle get body => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: VyroColors.textPrimary,
      );

  /// Akzent-Untertitel: 13px, Bold, accent-Farbe
  static TextStyle get sub => GoogleFonts.outfit(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: VyroColors.accent,
        letterSpacing: 0.2,
      );

  /// Caption: 11px, Light, textSecondary
  static TextStyle get caption => GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w300,
        color: VyroColors.textSecondary,
      );

  /// Greeting: 14px, Light, textSecondary
  static TextStyle get greeting => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: VyroColors.textSecondary,
        letterSpacing: 0.3,
      );
}
