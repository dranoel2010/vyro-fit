import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// NotificationService – flutter_local_notifications Wrapper
/// Initialisierung in main.dart: await NotificationService.init()
///
/// WICHTIG: UI greift niemals direkt auf diesen Service zu.
/// Nur über Settings (Toggles) und Repositories (checkStreak etc.)
class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'vyro_fit_main';
  static const _channelName = 'VYRO Fit';
  static const _channelDesc = 'Aktivitäts- und Schlaf-Erinnerungen';

  // Notification-IDs
  static const _sleepId = 1;
  static const _activityId = 2;
  static const _streakId = 3;
  static const _weeklyId = 4;

  /// App-Start: Plugin initialisieren
  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);

    // Android Notification Channel erstellen
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.defaultImportance,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Tägliche Schlaf-Erinnerung zur gewünschten Zeit
  static Future<void> scheduleSleepReminder(TimeOfDay time) async {
    await _plugin.periodicallyShow(
      _sleepId,
      'Zeit zum Schlafen 🌙',
      'Dein Schlafziel ist ${time.hour}:${time.minute.toString().padLeft(2, '0')} Uhr. Gute Nacht!',
      RepeatInterval.daily,
      _details(),
      androidScheduleMode: AndroidScheduleMode.inexact,
    );
  }

  /// Tägliche Bewegungs-Erinnerung (15:00)
  static Future<void> scheduleActivityCheck() async {
    await _plugin.periodicallyShow(
      _activityId,
      'Bewegungs-Check ⚡',
      'Wie ist dein Schritt-Fortschritt heute? Bleib aktiv!',
      RepeatInterval.daily,
      _details(),
      androidScheduleMode: AndroidScheduleMode.inexact,
    );
  }

  /// Streak-Warnung wenn >= 3 Tage kein Training
  static Future<void> checkWorkoutStreak(int daysSinceLastWorkout) async {
    if (daysSinceLastWorkout < 3) return;

    await _plugin.show(
      _streakId,
      'Dein Streak ist in Gefahr! 🔥',
      'Du warst $daysSinceLastWorkout Tage ohne Training. Leg heute los!',
      _details(),
    );
  }

  /// Wöchentlicher Bericht (Sonntag 20:00)
  static Future<void> scheduleWeeklyReport() async {
    await _plugin.periodicallyShow(
      _weeklyId,
      'Dein Wochenbericht 📊',
      'Schau dir deine Statistiken für diese Woche an!',
      RepeatInterval.weekly,
      _details(),
      androidScheduleMode: AndroidScheduleMode.inexact,
    );
  }

  /// Alle geplanten Notifications abbrechen
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// Einzelne Notification abbrechen
  static Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  static NotificationDetails _details() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
      ),
    );
  }
}
