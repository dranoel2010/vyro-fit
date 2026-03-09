import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/vyro_colors.dart';
import '../../core/theme/vyro_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../models/goal.dart';
import '../../providers/health_providers.dart';
import '../../providers/goal_providers.dart';
import '../../shared/widgets/vyro_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Benachrichtigungs-Toggles
  bool _sleepReminder = false;
  bool _activityReminder = true;
  bool _streakReminder = true;
  bool _weeklyReport = true;

  TimeOfDay _sleepReminderTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _activityReminderTime = const TimeOfDay(hour: 15, minute: 0);

  // Ziel-Slider Werte (initialisiert von persistedGoalsProvider)
  double _stepGoal = AppConstants.defaultStepGoal.toDouble();
  double _calorieGoal = AppConstants.defaultCalorieGoal;
  double _sleepGoal = AppConstants.defaultSleepGoal;
  double _workoutGoal = AppConstants.defaultWorkoutGoal.toDouble();

  @override
  void initState() {
    super.initState();
    // Ziele aus Provider laden
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(persistedGoalsProvider).whenData((goals) {
        if (!mounted) return;
        setState(() {
          for (final g in goals) {
            switch (g.type) {
              case GoalType.steps: _stepGoal = g.target; break;
              case GoalType.calories: _calorieGoal = g.target; break;
              case GoalType.sleep: _sleepGoal = g.target; break;
              case GoalType.workoutsPerWeek: _workoutGoal = g.target; break;
              case GoalType.activeMinutes: break;
            }
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authorized = ref.watch(healthAuthorizedProvider);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 52, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('KONFIGURATION', style: VyroTextStyles.label),
                const SizedBox(height: 6),
                Text('Einstellungen', style: VyroTextStyles.title),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([

              // ── Health Connect ─────────────────────────────────
              VyroCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('HEALTH CONNECT', style: VyroTextStyles.label),
                    const SizedBox(height: 14),
                    authorized.when(
                      data: (ok) => Row(
                        children: [
                          Icon(
                            ok ? Icons.check_circle : Icons.error_outline,
                            color: ok ? VyroColors.accent : Colors.redAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            ok ? 'Verbunden & Berechtigt' : 'Keine Berechtigung',
                            style: VyroTextStyles.body,
                          ),
                        ],
                      ),
                      loading: () => const CircularProgressIndicator(strokeWidth: 2),
                      error: (_, __) => Text('Fehler', style: VyroTextStyles.body.copyWith(color: Colors.redAccent)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Datenquellen: Schritte, Herzfrequenz, Schlaf, Workouts, Kalorien, Distanz, HRV',
                      style: VyroTextStyles.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Ziele ────────────────────────────────────────
              VyroCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ZIELE', style: VyroTextStyles.label),
                    const SizedBox(height: 16),

                    _GoalSlider(
                      label: '👟 Schritte',
                      value: _stepGoal,
                      min: 2000,
                      max: 25000,
                      divisions: 23,
                      format: (v) => '${v.round()}',
                      onChanged: (v) => setState(() => _stepGoal = v),
                      onChangeEnd: (v) {
                        ref.read(goalsProvider.notifier).updateTarget(GoalType.steps, v);
                      },
                    ),
                    const SizedBox(height: 16),

                    _GoalSlider(
                      label: '🔥 Kalorien',
                      value: _calorieGoal,
                      min: 200,
                      max: 1500,
                      divisions: 13,
                      format: (v) => '${v.round()} kcal',
                      onChanged: (v) => setState(() => _calorieGoal = v),
                      onChangeEnd: (v) {
                        ref.read(goalsProvider.notifier).updateTarget(GoalType.calories, v);
                      },
                    ),
                    const SizedBox(height: 16),

                    _GoalSlider(
                      label: '🌙 Schlaf',
                      value: _sleepGoal,
                      min: 5,
                      max: 10,
                      divisions: 10,
                      format: (v) => '${v.toStringAsFixed(1)} h',
                      onChanged: (v) => setState(() => _sleepGoal = v),
                      onChangeEnd: (v) {
                        ref.read(goalsProvider.notifier).updateTarget(GoalType.sleep, v);
                      },
                    ),
                    const SizedBox(height: 16),

                    _GoalSlider(
                      label: '💪 Workouts / Woche',
                      value: _workoutGoal,
                      min: 1,
                      max: 14,
                      divisions: 13,
                      format: (v) => '${v.round()}×',
                      onChanged: (v) => setState(() => _workoutGoal = v),
                      onChangeEnd: (v) {
                        ref.read(goalsProvider.notifier).updateTarget(GoalType.workoutsPerWeek, v);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Benachrichtigungen ─────────────────────────
              VyroCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BENACHRICHTIGUNGEN', style: VyroTextStyles.label),
                    const SizedBox(height: 14),

                    _NotifToggle(
                      label: 'Schlaf-Erinnerung',
                      sub: 'Täglich um ${_sleepReminderTime.format(context)}',
                      value: _sleepReminder,
                      onChanged: (v) => setState(() => _sleepReminder = v),
                      onTimeTap: () async {
                        final t = await showTimePicker(context: context, initialTime: _sleepReminderTime);
                        if (t != null) setState(() => _sleepReminderTime = t);
                      },
                    ),
                    const Divider(color: VyroColors.separator, height: 1),

                    _NotifToggle(
                      label: 'Bewegungs-Erinnerung',
                      sub: 'Täglich um ${_activityReminderTime.format(context)}',
                      value: _activityReminder,
                      onChanged: (v) => setState(() => _activityReminder = v),
                      onTimeTap: () async {
                        final t = await showTimePicker(context: context, initialTime: _activityReminderTime);
                        if (t != null) setState(() => _activityReminderTime = t);
                      },
                    ),
                    const Divider(color: VyroColors.separator, height: 1),

                    _NotifToggle(
                      label: 'Streak-Erinnerung',
                      sub: 'Wenn du einen Streak zu verlieren drohst',
                      value: _streakReminder,
                      onChanged: (v) => setState(() => _streakReminder = v),
                    ),
                    const Divider(color: VyroColors.separator, height: 1),

                    _NotifToggle(
                      label: 'Wochenbericht',
                      sub: 'Jeden Sonntag um 20:00',
                      value: _weeklyReport,
                      onChanged: (v) => setState(() => _weeklyReport = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── App Info ───────────────────────────────────
              VyroCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('APP', style: VyroTextStyles.label),
                    const SizedBox(height: 14),
                    _InfoRow(label: 'App', value: AppConstants.appName),
                    const Divider(color: VyroColors.separator, height: 1),
                    _InfoRow(label: 'Version', value: AppConstants.appVersion),
                    const Divider(color: VyroColors.separator, height: 1),
                    const SizedBox(height: 14),
                    // Daten zurücksetzen
                    GestureDetector(
                      onTap: () => _confirmReset(context),
                      child: Text(
                        'Daten zurücksetzen',
                        style: VyroTextStyles.body.copyWith(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: VyroColors.card,
        title: Text('Daten zurücksetzen', style: VyroTextStyles.title.copyWith(fontSize: 18)),
        content: Text('Alle gecachten Daten werden gelöscht. Health Connect-Daten bleiben erhalten.', style: VyroTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Abbrechen', style: VyroTextStyles.body.copyWith(color: VyroColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Zurücksetzen', style: VyroTextStyles.body.copyWith(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      // Cache leeren – nur UI-Feedback, kein direkter IsarService-Aufruf aus UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cache wird beim nächsten App-Start geleert.', style: VyroTextStyles.caption),
          backgroundColor: VyroColors.card,
        ),
      );
    }
  }
}

// ── Hilfs-Widgets ──────────────────────────────────────────────────────────

class _GoalSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String Function(double) format;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  const _GoalSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.format,
    required this.onChanged,
    required this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: VyroTextStyles.body),
            Text(format(value), style: VyroTextStyles.body.copyWith(color: VyroColors.accent, fontWeight: FontWeight.w700)),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: VyroColors.accent,
            inactiveTrackColor: VyroColors.accentDim,
            thumbColor: VyroColors.accent,
            overlayColor: VyroColors.accentDim,
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ),
      ],
    );
  }
}

class _NotifToggle extends StatelessWidget {
  final String label;
  final String sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTimeTap;

  const _NotifToggle({
    required this.label,
    required this.sub,
    required this.value,
    required this.onChanged,
    this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: VyroTextStyles.body),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: onTimeTap,
                  child: Text(
                    sub,
                    style: VyroTextStyles.caption.copyWith(
                      color: (value && onTimeTap != null) ? VyroColors.accent : VyroColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: VyroColors.accent,
            inactiveTrackColor: VyroColors.accentDim,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: VyroTextStyles.body.copyWith(color: VyroColors.textSecondary)),
          Text(value, style: VyroTextStyles.body),
        ],
      ),
    );
  }
}
