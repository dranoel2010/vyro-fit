/// Herzfrequenz-Datenpunkt
class HeartRateData {
  final DateTime timestamp;
  final double bpm;

  const HeartRateData({required this.timestamp, required this.bpm});
}

/// Tages-Zusammenfassung der Herzfrequenz
class HeartRateSummary {
  final double restingHR;
  final double minHR;
  final double maxHR;
  final double avgHR;
  final List<HeartRateData> timeline; // 24h Daten

  const HeartRateSummary({
    required this.restingHR,
    required this.minHR,
    required this.maxHR,
    required this.avgHR,
    this.timeline = const [],
  });
}

/// HR-Zonen basierend auf Max-HR
enum HRZone {
  rest('Ruhe', 0.0, 0.5),
  fatBurn('Fettverbrennung', 0.5, 0.6),
  cardio('Kardio', 0.6, 0.7),
  peak('Peak', 0.7, 0.8),
  max('Maximum', 0.8, 1.0);

  final String label;
  final double minPct;
  final double maxPct;
  const HRZone(this.label, this.minPct, this.maxPct);
}

/// Chart-Daten (für fl_chart / CustomPainter)
class ChartData {
  final List<double> values;
  final List<String> labels;
  final double? maxValue;
  final double? minValue;
  final double? average;

  const ChartData({
    required this.values,
    required this.labels,
    this.maxValue,
    this.minValue,
    this.average,
  });
}

class WeeklyChartData {
  final ChartData steps;
  final ChartData calories;
  final ChartData heartRate;
  final ChartData sleep;

  const WeeklyChartData({
    required this.steps,
    required this.calories,
    required this.heartRate,
    required this.sleep,
  });
}
