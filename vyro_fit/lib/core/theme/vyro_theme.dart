import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vyro_colors.dart';
import 'vyro_text_styles.dart';

/// VYRO Fit Theme – Dark-Tech-Design
class VyroTheme {
  VyroTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: VyroColors.background,

      colorScheme: const ColorScheme.dark(
        primary: VyroColors.accent,
        secondary: VyroColors.neonCyan,
        surface: VyroColors.card,
        onSurface: VyroColors.textPrimary,
        background: VyroColors.background,
        onBackground: VyroColors.textPrimary,
      ),

      // Outfit als Standard-Schriftart
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme).copyWith(
        headlineLarge: VyroTextStyles.title,
        bodyLarge: VyroTextStyles.body,
        bodySmall: VyroTextStyles.caption,
        labelSmall: VyroTextStyles.label,
      ),

      // AppBar: transparent, kein Shadow
      appBarTheme: AppBarTheme(
        backgroundColor: VyroColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: VyroTextStyles.title,
        iconTheme: const IconThemeData(color: VyroColors.textPrimary),
      ),

      // Cards: radius 18, card-Farbe, kein Shadow im Theme (wird manuell gesetzt)
      cardTheme: CardTheme(
        color: VyroColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),

      // Divider: fast unsichtbar
      dividerTheme: const DividerThemeData(
        color: VyroColors.separator,
        thickness: 0.5,
        space: 0,
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: VyroColors.textSecondary,
        size: 22,
      ),

      // FilledButton
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: VyroColors.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
