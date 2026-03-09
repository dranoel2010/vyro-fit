import 'package:home_widget/home_widget.dart';

/// Homescreen-Widget: Aktivitäts-Score (2×2)
class ScoreWidget {
  static const _widgetName = 'ScoreWidget';

  /// Score + Detaildaten ans Widget senden
  static Future<void> update({
    required int score,
    required int steps,
    required double calories,
    required double sleepHours,
  }) async {
    await HomeWidget.saveWidgetData<int>('score', score);
    await HomeWidget.saveWidgetData<int>('score_steps', steps);
    await HomeWidget.saveWidgetData<String>(
        'score_calories', calories.round().toString());
    await HomeWidget.saveWidgetData<String>(
        'score_sleep', sleepHours.toStringAsFixed(1));
    await HomeWidget.updateWidget(
      name: _widgetName,
      androidName: _widgetName,
    );
  }
}
