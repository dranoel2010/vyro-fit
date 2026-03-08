import 'package:flutter/material.dart';

/// VYRO Fit Farbsystem – Dark-Tech-Design
/// STRIKT einhalten: Nur diese Werte verwenden, keine hardcoded Farben in Widgets!
class VyroColors {
  VyroColors._();

  // ── Hintergründe ──────────────────────────────────────────
  static const Color background = Color(0xFF0F1115);
  static const Color card = Color(0xFF171A21);

  // ── Akzent (einzige Datenfarbe) ───────────────────────────
  static const Color accent = Color(0xFF3B82F6);
  static const Color accentGlow = Color(0x663B82F6); // 40% opacity
  static const Color accentDim = Color(0x143B82F6);  // 8% opacity

  // ── Text ──────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFE8E9ED);
  static const Color textSecondary = Color(0xFF5A5E6A);

  // ── Spezial (nur wo explizit nötig) ───────────────────────
  static const Color neonCyan = Color(0xFF22D3EE); // sekundäre Daten

  // ── Schlafphasen-Farben ───────────────────────────────────
  static const Color sleepRem = Color(0xFF3B82F6);   // = accent
  static const Color sleepDeep = Color(0xFF1E3A6E);
  static const Color sleepLight = Color(0xFF1A2235);
  static const Color sleepAwake = Color(0xFF2A2D38);

  // ── UI ────────────────────────────────────────────────────
  static const Color separator = Color(0x0AFFFFFF); // 4% weiß

  /// Gibt eine gedimmte Version einer Farbe zurück
  static Color dimmed(Color c, [double opacity = 0.08]) =>
      c.withOpacity(opacity);
}
