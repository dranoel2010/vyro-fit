import 'package:intl/intl.dart';

/// Datums-Hilfsfunktionen für VYRO Fit
class DateHelper {
  DateHelper._();

  /// Start des heutigen Tages (00:00)
  static DateTime get todayStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Start der aktuellen Woche (Montag)
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

  /// Formatiert Datum als "Sonntag, 8. März"
  static String formatHeaderDate(DateTime date) {
    return DateFormat('EEEE, d. MMMM', 'de_DE').format(date);
  }

  /// Formatiert Zeit als "10:30"
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// Formatiert relative Zeit ("Heute", "Gestern", "Mo")
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

  /// Formatiert Dauer als "6h 54m"
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  /// Gibt die letzten 7 Tage als Liste zurück
  static List<DateTime> lastSevenDays() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      return DateTime(date.year, date.month, date.day);
    });
  }

  /// Kurzer Wochentag ("Mo", "Di", ...)
  static String shortWeekday(DateTime date) {
    const days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    return days[date.weekday - 1];
  }
}
