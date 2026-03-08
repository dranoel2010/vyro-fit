import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/vyro_colors.dart';
import '../../core/theme/vyro_text_styles.dart';
import '../../core/utils/date_helper.dart';
import '../../core/utils/number_formatter.dart';
import '../../providers/health_providers.dart';

/// Overview-Screen (Platzhalter – wird in Phase 10 vollständig implementiert)
class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaySummary = ref.watch(todaySummaryProvider);
    final streak = ref.watch(streakProvider);

    return Scaffold(
      backgroundColor: VyroColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // ── Header ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 52, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateHelper.getGreeting(),
                      style: VyroTextStyles.greeting,
                    ),
                    const SizedBox(height: 6),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: 'VYRO ',
                          style: VyroTextStyles.title,
                        ),
                        TextSpan(
                          text: 'Fit',
                          style: VyroTextStyles.title.copyWith(
                            fontWeight: FontWeight.w300,
                            color: VyroColors.textSecondary,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),

            // ── Streak Badges ────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _StreakBadge(
                      value: '${streak.currentStreak}',
                      label: 'Tage Streak',
                    ),
                    const SizedBox(width: 10),
                    _StreakBadge(
                      value: '${streak.weeklyGoalsCompleted}',
                      label: 'Wochen-Ziel',
                    ),
                    const SizedBox(width: 10),
                    _StreakBadge(
                      value: streak.monthlyScore > 0
                          ? NumberFormatter.percent(streak.monthlyScore)
                          : '--',
                      label: 'Monats-Score',
                    ),
                  ],
                ),
              ),
            ),

            // ── Inhalt (Phase 10 wird hier die Cards einbauen) ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: todaySummary.when(
                  data: (_) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      Icon(
                        Icons.construction_outlined,
                        size: 40,
                        color: VyroColors.accent.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Phase 1 erfolgreich!',
                        style: VyroTextStyles.title,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Setup abgeschlossen. Das Dashboard wird in Phase 10 implementiert.',
                        style: VyroTextStyles.body.copyWith(
                          color: VyroColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                  loading: () => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: CircularProgressIndicator(
                        color: VyroColors.accent,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  error: (_, __) => Text(
                    'Fehler beim Laden der Daten.',
                    style: VyroTextStyles.body.copyWith(
                      color: VyroColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

            // Platz für Navigation
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final String value;
  final String label;

  const _StreakBadge({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: VyroColors.card,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x59000000),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: VyroTextStyles.dataValueSm.copyWith(
                fontSize: 20,
                color: VyroColors.accent,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: VyroTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
