import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

/// Homescreen-Widget: Schritte (2×1)
/// Aktualisiert die home_widget Daten alle 30 Minuten (über AppWidgetProvider)
class StepsWidget {
  static const _widgetName = 'StepsWidget';

  /// Schritt-Daten ans Widget senden
  static Future<void> update({
    required int steps,
    required int goal,
  }) async {
    await HomeWidget.saveWidgetData<int>('steps', steps);
    await HomeWidget.saveWidgetData<int>('steps_goal', goal);
    await HomeWidget.saveWidgetData<int>(
      'steps_percent',
      ((steps / goal) * 100).clamp(0, 100).round(),
    );
    await HomeWidget.updateWidget(
      name: _widgetName,
      androidName: _widgetName,
    );
  }

  /// Widget-Klick-Callback registrieren (öffnet App)
  static Future<void> registerCallback() async {
    HomeWidget.setAppGroupId('com.vyrofit.app');
  }
}
