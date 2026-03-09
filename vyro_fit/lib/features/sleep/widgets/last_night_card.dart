import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../providers/sleep_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/sleep_phase_bar.dart';
import '../../../shared/widgets/stat_row.dart';
import '../../../shared/widgets/loading_card.dart';

class LastNightCard extends ConsumerWidget {
  const LastNightCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleep = ref.watch(lastNightProvider);

    return sleep.when(
      loading: () => const LoadingCard(height: 200),
      error: (_, __) => const SizedBox.shrink(),
      data: (s) {
        if (s == null) {
          return VyroCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LETZTE NACHT', style: VyroTextStyles.label),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.bedtime_outlined, color: VyroColors.textSecondary, size: 20),
                    const SizedBox(width: 8),
                    Text('Keine Schlafdaten', style: VyroTextStyles.body.copyWith(color: VyroColors.textSecondary)),
                  ],
                ),
              ],
            ),
          );
        }
        return VyroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('LETZTE NACHT', style: VyroTextStyles.label),
              const SizedBox(height: 10),
              Text(
                NumberFormatter.hoursToHM(s.totalHours),
                style: VyroTextStyles.dataValue,
              ),
              const SizedBox(height: 4),
              Text(
                '${_fmt(s.bedtime)} – ${_fmt(s.wakeTime)}',
                style: VyroTextStyles.caption,
              ),
              const SizedBox(height: 16),
              SleepPhaseBar(sleep: s),
              const SizedBox(height: 14),
              StatRow(
                label: 'Tiefschlaf',
                value: s.deep != null ? '${s.deep!.inMinutes} min' : '--',
                showDivider: true,
              ),
              StatRow(
                label: 'REM',
                value: s.rem != null ? '${s.rem!.inMinutes} min' : '--',
                showDivider: true,
              ),
              StatRow(
                label: 'Leichtschlaf',
                value: s.light != null ? '${s.light!.inMinutes} min' : '--',
                showDivider: true,
              ),
              StatRow(
                label: 'Wach',
                value: s.awake != null ? '${s.awake!.inMinutes} min' : '--',
              ),
            ],
          ),
        );
      },
    );
  }

  String _fmt(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
