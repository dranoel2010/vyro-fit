/// Schlaf-Session Datenmodell
class SleepData {
  final DateTime date;
  final DateTime bedtime;
  final DateTime wakeTime;
  final Duration totalDuration;
  final Duration? awake;
  final Duration? light;
  final Duration? deep;
  final Duration? rem;

  const SleepData({
    required this.date,
    required this.bedtime,
    required this.wakeTime,
    required this.totalDuration,
    this.awake,
    this.light,
    this.deep,
    this.rem,
  });

  /// Schlaf-Stunden als Dezimalzahl (z.B. 6.9)
  double get totalHours => totalDuration.inMinutes / 60;

  /// Prozentuale Verteilung der Schlafphasen
  Map<String, double> get phasePercentages {
    final total = totalDuration.inMinutes;
    if (total == 0) return {};
    return {
      'awake': (awake?.inMinutes ?? 0) / total,
      'light': (light?.inMinutes ?? 0) / total,
      'deep': (deep?.inMinutes ?? 0) / total,
      'rem': (rem?.inMinutes ?? 0) / total,
    };
  }

  /// Schlaf-Score (vereinfacht: basierend auf Dauer + Tiefschlaf-Anteil)
  int get score {
    final durationScore = (totalHours / 8.0).clamp(0.0, 1.0) * 60;
    final deepPct = phasePercentages['deep'] ?? 0;
    final deepScore = (deepPct / 0.25).clamp(0.0, 1.0) * 40;
    return (durationScore + deepScore).round();
  }
}
