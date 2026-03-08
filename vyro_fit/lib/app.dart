import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/vyro_colors.dart';
import 'core/theme/vyro_theme.dart';
import 'core/theme/vyro_text_styles.dart';
import 'features/overview/overview_screen.dart';
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
// Permission Gate: prüft Health Connect vor App-Start
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
// Permission Screen: Erklärungs-Screen für Health Connect
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

              // Brand
              Text(
                'Guten Morgen',
                style: VyroTextStyles.greeting,
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: 'VYRO ',
                    style: VyroTextStyles.title.copyWith(fontSize: 32),
                  ),
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

              // Erklärung
              Text(
                'Health Connect verbinden',
                style: VyroTextStyles.label.copyWith(
                  color: VyroColors.accent,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'VYRO Fit liest deine Gesundheitsdaten direkt von Health Connect – ohne Account, ohne Cloud, ohne Altersbeschränkung.',
                style: VyroTextStyles.body.copyWith(
                  color: VyroColors.textSecondary,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Deine Daten bleiben ausschließlich auf deinem Gerät.',
                style: VyroTextStyles.caption.copyWith(
                  color: VyroColors.textSecondary,
                ),
              ),

              const Spacer(flex: 3),

              // Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: onRequest,
                  style: FilledButton.styleFrom(
                    backgroundColor: VyroColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Health Connect verbinden',
                    style: VyroTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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
// App Shell: Haupt-Navigation mit 4 Tabs
// ─────────────────────────────────────────────────────────────────────────────

class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  int _currentIndex = 0;

  static const _screens = <Widget>[
    OverviewScreen(),
    _PlaceholderScreen(title: 'Herzfrequenz', icon: Icons.favorite_outline),
    _PlaceholderScreen(title: 'Workouts', icon: Icons.fitness_center_outlined),
    _PlaceholderScreen(title: 'Profil', icon: Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyroColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // extendBody: true → Content geht hinter NavBar (erfordert bottom padding in Screens)
      extendBody: true,
      bottomNavigationBar: _VyroNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VYRO Navigation Bar: Glassmorphism-Style
// ─────────────────────────────────────────────────────────────────────────────

class _VyroNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _VyroNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // rgba(15,17,21,0.85) – leicht transluzent wie im Mockup
        color: Color(0xD90F1115),
        border: Border(
          top: BorderSide(
            color: Color(0x0AFFFFFF), // 4% weiß = separator
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.favorite_outline,
                activeIcon: Icons.favorite,
                label: 'Stats',
                index: 1,
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.fitness_center_outlined,
                activeIcon: Icons.fitness_center,
                label: 'Workouts',
                index: 2,
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profil',
                index: 3,
                currentIndex: currentIndex,
                onTap: onTap,
              ),
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
            // Icon mit Glow wenn aktiv
            isActive
                ? ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [VyroColors.accent, VyroColors.accent],
                    ).createShader(bounds),
                    child: Icon(activeIcon, size: 22),
                  )
                : Icon(
                    icon,
                    size: 22,
                    color: VyroColors.textSecondary,
                  ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Platzhalter für noch nicht implementierte Screens
// ─────────────────────────────────────────────────────────────────────────────

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyroColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: VyroColors.textSecondary),
              const SizedBox(height: 16),
              Text(title, style: VyroTextStyles.title),
              const SizedBox(height: 8),
              Text(
                'Kommt bald...',
                style: VyroTextStyles.body.copyWith(
                  color: VyroColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
