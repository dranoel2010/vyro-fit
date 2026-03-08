import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'vyro_colors.dart';

/// VYRO Fit Theme – Apple Health inspiriertes Design
class VyroTheme {
  VyroTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: VyroColors.background,
      colorScheme: ColorScheme.light(
        primary: VyroColors.steps,
        secondary: VyroColors.moveRing,
        surface: VyroColors.card,
        onSurface: VyroColors.textPrimary,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: VyroColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: VyroColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
        ),
      ),

      // Cards
      cardTheme: CardTheme(
        color: VyroColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),

      // Text
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: VyroColors.textPrimary,
          letterSpacing: -0.8,
        ),
        headlineMedium: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: VyroColors.textPrimary,
          letterSpacing: -1.5,
        ),
        titleMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: VyroColors.textSecondary,
          letterSpacing: 0.3,
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: VyroColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          color: VyroColors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 11,
          color: VyroColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: VyroColors.textTertiary,
        ),
      ),

      // Bottom Nav
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: VyroColors.steps,
        unselectedItemColor: VyroColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 10),
      ),
    );
  }
}
