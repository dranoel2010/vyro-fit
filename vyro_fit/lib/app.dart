import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/vyro_colors.dart';
import 'core/theme/vyro_theme.dart';
import 'core/theme/vyro_text_styles.dart';
import 'features/overview/overview_screen.dart';
import 'features/heart/heart_screen.dart';
import 'features/sleep/sleep_screen.dart';
import 'features/workouts/workouts_screen.dart';
import 'features/goals/goals_screen.dart';
import 'features/settings/settings_screen.dart';
import 'providers/health_providers.dart';

/// VYRO Fit App – Entry Point
class VyroFitApp extends StatelessWidget {
  const VyroFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VYRO Fit',
      theme: VyroTheme.dark,
      debugShowCheckedModeBanner: false,
      home: const _PermissionGate(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Permission Gate
// ─────────────────────────────────────────────────────────────────────────────

class _PermissionGate extends ConsumerWidget {
  const _PermissionGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(healthAuthorizedProvider);

    return authState.when(
      data: (authorized) {
        if (authorized) return const _AppShell();
        return _PermissionScreen(
          onRequest: () => ref.invalidate(healthAuthorizedProvider),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: VyroColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: VyroColors.accent,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (_, __) => _PermissionScreen(
        onRequest: () => ref.invalidate(healthAuthorizedProvider),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Permission Screen
// ─────────────────────────────────────────────────────────────────────────────

class _PermissionScreen extends StatelessWidget {
  final VoidCallback onRequest;
  const _PermissionScreen({required this.onRequest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyroColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              Text('Guten Morgen', style: VyroTextStyles.greeting),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: 'VYRO ', style: VyroTextStyles.title.copyWith(fontSize: 32)),
                  TextSpan(
                    text: 'Fit',
                    style: VyroTextStyles.title.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: VyroColors.textSecondary,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 48),
              Text('Health Connect verbinden', style: VyroTextStyles.label.copyWith(color: VyroColors.accent)),
              const SizedBox(height: 12),
              Text(
                'VYRO Fit liest deine Gesundheitsdaten direkt von Health Connect – ohne Account, ohne Cloud, ohne Altersbeschränkung.',
                style: VyroTextStyles.body.copyWith(color: VyroColors.textSecondary, height: 1.7),
              ),
              const SizedBox(height: 16),
              Text(
                'Deine Daten bleiben ausschließlich auf deinem Gerät.',
                style: VyroTextStyles.caption.copyWith(color: VyroColors.textSecondary),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: onRequest,
                  style: FilledButton.styleFrom(
                    backgroundColor: VyroColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Health Connect verbinden',
                    style: VyroTextStyles.body.copyWith(fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App Shell: 4-Tab Navigation
// ─────────────────────────────────────────────────────────────────────────────

class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  int _currentIndex = 0;

  // Für Settings-Navigation aus GoalsScreen
  void _goToSettings() {
    setState(() => _currentIndex = 3);
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const OverviewScreen(),
      const _StatsScreen(),
      const WorkoutsScreen(),
      _ProfilScreen(onGoToSettings: _goToSettings),
    ];

    return Scaffold(
      backgroundColor: VyroColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      extendBody: true,
      bottomNavigationBar: _VyroNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats Screen: Herz | Schlaf – DefaultTabController
// ─────────────────────────────────────────────────────────────────────────────

class _StatsScreen extends StatelessWidget {
  const _StatsScreen();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: VyroColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 52, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ANALYSE', style: VyroTextStyles.label),
                    const SizedBox(height: 6),
                    Text('Stats', style: VyroTextStyles.title),
                    const SizedBox(height: 16),
                    TabBar(
                      tabs: const [Tab(text: 'Herz'), Tab(text: 'Schlaf')],
                      labelStyle: VyroTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                      unselectedLabelStyle: VyroTextStyles.body,
                      labelColor: VyroColors.accent,
                      unselectedLabelColor: VyroColors.textSecondary,
                      indicatorColor: VyroColors.accent,
                      indicatorSize: TabBarIndicatorSize.label,
                      dividerColor: VyroColors.separator,
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    HeartScreen(showHeader: false),
                    SleepScreen(showHeader: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profil Screen: Ziele oben + Einstellungen unten
// ─────────────────────────────────────────────────────────────────────────────

class _ProfilScreen extends StatefulWidget {
  final VoidCallback onGoToSettings;
  const _ProfilScreen({required this.onGoToSettings});

  @override
  State<_ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<_ProfilScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyroColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 52, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MEIN BEREICH', style: VyroTextStyles.label),
                  const SizedBox(height: 6),
                  Text('Profil', style: VyroTextStyles.title),
                  const SizedBox(height: 16),
                  // Segmented Control
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: VyroColors.card,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _TabChip(label: 'Ziele', selected: _tab == 0, onTap: () => setState(() => _tab = 0)),
                        _TabChip(label: 'Einstellungen', selected: _tab == 1, onTap: () => setState(() => _tab = 1)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _tab,
                children: [
                  GoalsScreen(onNavigateToSettings: () => setState(() => _tab = 1)),
                  const SettingsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: selected ? VyroColors.accent.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: VyroTextStyles.caption.copyWith(
              color: selected ? VyroColors.accent : VyroColors.textSecondary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VYRO Navigation Bar
// ─────────────────────────────────────────────────────────────────────────────

class _VyroNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _VyroNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xD90F1115),
        border: Border(
          top: BorderSide(color: Color(0x0AFFFFFF), width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', index: 0, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: 'Stats', index: 1, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.fitness_center_outlined, activeIcon: Icons.fitness_center, label: 'Workouts', index: 2, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profil', index: 3, currentIndex: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isActive
                ? ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [VyroColors.accent, VyroColors.accent],
                    ).createShader(bounds),
                    child: Icon(activeIcon, size: 22),
                  )
                : Icon(icon, size: 22, color: VyroColors.textSecondary),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: isActive ? VyroColors.accent : VyroColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
