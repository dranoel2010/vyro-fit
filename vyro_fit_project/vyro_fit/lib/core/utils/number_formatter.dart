import 'package:intl/intl.dart';

/// Zahlen-Formatting für VYRO Fit
class NumberFormatter {
  NumberFormatter._();

  static final _decimal = NumberFormat('#,###', 'de_DE');

  /// 8700 → "8.700"
  static String steps(num value) => _decimal.format(value);

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
}
