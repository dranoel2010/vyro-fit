import '../../core/constants/app_constants.dart';
import '../../models/heart_rate_data.dart';

/// Berechnet HR-Zonen basierend auf Max-HR (Alter 15 → Max HR 205)
///
/// Zone 1 Rest:        < 50% Max (< 103 bpm)
/// Zone 2 Fettverbr.: 50-60% (103-123 bpm)
/// Zone 3 Kardio:     60-70% (123-144 bpm)
/// Zone 4 Peak:       70-80% (144-164 bpm)
/// Zone 5 Maximum:    80-100% (164+ bpm)
class HRZoneCalculator {
  const HRZoneCalculator._();

  static int get maxHR => AppConstants.maxHR; // 220 - 15 = 205

  /// Gibt die Zone für einen BPM-Wert zurück
  static HRZone getZone(double bpm) {
    final pct = bpm / maxHR;
    if (pct < 0.50) return HRZone.rest;
    if (pct < 0.60) return HRZone.fatBurn;
    if (pct < 0.70) return HRZone.cardio;
    if (pct < 0.80) return HRZone.peak;
    return HRZone.max;
  }

  /// Berechnet die Zeitverteilung auf die Zonen
  static Map<HRZone, Duration> calculateZoneDistribution(
    List<HeartRateData> hrData, {
    Duration sampleInterval = const Duration(minutes: 1),
  }) {
    final distribution = {for (final zone in HRZone.values) zone: Duration.zero};

    if (hrData.length < 2) return distribution;

    final sorted = [...hrData]..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    for (int i = 0; i < sorted.length - 1; i++) {
      final current = sorted[i];
      final next = sorted[i + 1];
      final gap = next.timestamp.difference(current.timestamp);

      // Nur realistische Lücken berücksichtigen (max 5 Minuten)
      if (gap.inMinutes <= 5) {
        final zone = getZone(current.bpm);
        distribution[zone] = distribution[zone]! + gap;
      }
    }

    return distribution;
  }

  /// BPM-Grenzen für eine Zone
  static (double min, double max) zoneLimits(HRZone zone) {
    return (zone.minPct * maxHR, zone.maxPct * maxHR);
  }

  /// Zone-Farbe (für UI – bleibt im Blau-Spektrum)
  static int zoneColorValue(HRZone zone) {
    return switch (zone) {
      HRZone.rest => 0xFF3B82F6,    // accent (blau)
      HRZone.fatBurn => 0xFF22D3EE, // cyan
      HRZone.cardio => 0xFF0EA5E9,  // helles blau
      HRZone.peak => 0xFF7C3AED,    // lila
      HRZone.max => 0xFFDB2777,     // pink
    };
  }
}
