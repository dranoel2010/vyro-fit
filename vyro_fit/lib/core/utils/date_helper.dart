import 'package:intl/intl.dart';

/// Datums-Hilfsfunktionen für VYRO Fit (Deutsche Lokalisierung)
class DateHelper {
  DateHelper._();

  /// Start des heutigen Tages (00:00:00)
  static DateTime get todayStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Start der aktuellen Woche (Montag 00:00)
  static DateTime get weekStart {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  /// Start des aktuellen Monats
  static DateTime get monthStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  /// "Sonntag, 8. März"
  static String formatHeaderDate(DateTime date) {
    return DateFormat('EEEE, d. MMMM', 'de_DE').format(date);
  }

  /// "10:30"
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// "Heute" / "Gestern" / "Mo" / "5. März"
  static String formatRelativeDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'Heute';
    if (diff == 1) return 'Gestern';
    if (diff < 7) return DateFormat('E', 'de_DE').format(date);
    return DateFormat('d. MMM', 'de_DE').format(date);
  }

  /// "6h 54m" aus Duration
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  /// Letzten N Tage als Liste (aufsteigend, heute zuletzt)
  static List<DateTime> lastNDays(int n) {
    final now = DateTime.now();
    return List.generate(n, (i) {
      final date = now.subtract(Duration(days: n - 1 - i));
      return DateTime(date.year, date.month, date.day);
    });
  }

  /// Kurzer Wochentag: "Mo", "Di", ...
  static String shortWeekday(DateTime date) {
    const days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    return days[date.weekday - 1];
  }

  /// Dynamische Begrüßung basierend auf Uhrzeit
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Guten Morgen';
    if (hour < 17) return 'Guten Tag';
    return 'Guten Abend';
  }
}
