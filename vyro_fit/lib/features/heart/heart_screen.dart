import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/vyro_colors.dart';
import '../../core/theme/vyro_text_styles.dart';
import '../../core/utils/date_helper.dart';
import './widgets/resting_hr_card.dart';
import './widgets/hr_timeline_card.dart';
import './widgets/hr_zones_card.dart';
import './widgets/hrv_trend_card.dart';

class HeartScreen extends ConsumerWidget {
  final bool showHeader;
  const HeartScreen({super.key, this.showHeader = true});

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
                      Text('HERZFREQUENZ', style: VyroTextStyles.label),
                      const SizedBox(height: 6),
                      Text('Herz', style: VyroTextStyles.title),
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
                  const RestingHRCard(),
                  const SizedBox(height: 14),
                  const HRTimelineCard(),
                  const SizedBox(height: 14),
                  const HRZonesCard(),
                  const SizedBox(height: 14),
                  const HRVTrendCard(),
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
