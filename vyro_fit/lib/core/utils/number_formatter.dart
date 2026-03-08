import 'package:intl/intl.dart';

/// Zahlen-Formatierung für VYRO Fit (Deutsche Lokalisierung)
class NumberFormatter {
  NumberFormatter._();

  static final _steps = NumberFormat('#,###', 'de_DE');

  /// 8700 → "8.700"
  static String steps(num value) =>
      value <= 0 ? '0' : _steps.format(value);

  /// 490.5 → "490"
  static String calories(num value) => value.round().toString();

  /// 61.3 → "61"
  static String bpm(num value) => value.round().toString();

  /// 0.87 → "87%"
  static String percent(double value) => '${(value * 100).round()}%';

  /// 6.9 → "6h 54m"
  static String hoursToHM(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  /// 3200.0 → "3,2 km" / 450.0 → "450 m"
  static String distance(double meters) {
    if (meters >= 1000) {
      final km = meters / 1000;
      return '${km.toStringAsFixed(1).replaceAll('.', ',')} km';
    }
    return '${meters.round()} m';
  }

  /// Kompakt für große Zahlen: 12500 → "12,5k"
  static String compact(num value) {
    if (value >= 1000) {
      final k = value / 1000;
      return '${k.toStringAsFixed(1).replaceAll('.', ',')}k';
    }
    return value.round().toString();
  }
}
