import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/vyro_colors.dart';
import '../../../core/theme/vyro_text_styles.dart';
import '../../../core/utils/date_helper.dart';
import '../../../providers/sleep_providers.dart';
import '../../../shared/widgets/vyro_card.dart';
import '../../../shared/widgets/loading_card.dart';

class SleepTimesCard extends ConsumerWidget {
  const SleepTimesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekly = ref.watch(weeklySleepProvider);

    return weekly.when(
      loading: () => const LoadingCard(height: 160),
      error: (_, __) => const SizedBox.shrink(),
      data: (sessions) {
        if (sessions.isEmpty) return const SizedBox.shrink();

        final days = DateHelper.lastNDays(7);
        return VyroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SCHLAFZEITEN', style: VyroTextStyles.label),
              const SizedBox(height: 14),
              ...days.map((day) {
                final match = sessions.where((s) =>
                    s.date.year == day.year &&
                    s.date.month == day.month &&
                    s.date.day == day.day).firstOrNull;
                final dayLabel = DateHelper.shortWeekday(day);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 32,
                        child: Text(dayLabel, style: VyroTextStyles.caption),
                      ),
                      const SizedBox(width: 8),
                      if (match != null) ...[
                        _TimeChip(time: match.bedtime, label: 'Einschlafen'),
                        const SizedBox(width: 6),
                        Text('–', style: VyroTextStyles.caption),
                        const SizedBox(width: 6),
                        _TimeChip(time: match.wakeTime, label: 'Aufwachen'),
                      ] else
                        Text('Keine Daten', style: VyroTextStyles.caption),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _TimeChip extends StatelessWidget {
  final DateTime time;
  final String label;

  const _TimeChip({required this.time, required this.label});

  @override
  Widget build(BuildContext context) {
    final formatted = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: VyroColors.accentDim,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(formatted, style: VyroTextStyles.caption.copyWith(color: VyroColors.textPrimary)),
    );
  }
}
