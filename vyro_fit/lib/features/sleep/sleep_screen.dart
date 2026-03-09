import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/vyro_colors.dart';
import '../../core/theme/vyro_text_styles.dart';
import '../../core/utils/date_helper.dart';
import './widgets/last_night_card.dart';
import './widgets/sleep_score_card.dart';
import './widgets/sleep_week_card.dart';
import './widgets/sleep_times_card.dart';

class SleepScreen extends ConsumerWidget {
  final bool showHeader;
  const SleepScreen({super.key, this.showHeader = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: VyroColors.background,
      body: SafeArea(
        top: showHeader,
        bottom: false,
        child: CustomScrollView(
          slivers: [
            if (showHeader)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 52, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ANALYSE', style: VyroTextStyles.label),
                      const SizedBox(height: 6),
                      Text('Schlaf', style: VyroTextStyles.title),
                      const SizedBox(height: 4),
                      Text(DateHelper.formatHeaderDate(DateTime.now()), style: VyroTextStyles.caption),
                    ],
                  ),
                ),
              )
            else
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SleepScoreCard(),
                  const SizedBox(height: 14),
                  const LastNightCard(),
                  const SizedBox(height: 14),
                  const SleepWeekCard(),
                  const SizedBox(height: 14),
                  const SleepTimesCard(),
                ]),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
