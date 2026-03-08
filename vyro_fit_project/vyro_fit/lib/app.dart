import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/vyro_colors.dart';
import 'core/theme/vyro_theme.dart';
import 'features/overview/overview_screen.dart';
import 'shared/providers/health_providers.dart';

class VyroFitApp extends StatelessWidget {
  const VyroFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VYRO Fit',
      theme: VyroTheme.light,
      debugShowCheckedModeBanner: false,
      home: const _PermissionGate(),
    );
  }
}

/// Prüft Health Connect Berechtigungen bevor die App startet
class _PermissionGate extends ConsumerWidget {
  const _PermissionGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(healthAuthorizedProvider);

    return authState.when(
      data: (authorized) {
        if (authorized) {
          return const _AppShell();
        }
        return _PermissionScreen(
          onRequest: () => ref.refresh(healthAuthorizedProvider),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (_, __) => _PermissionScreen(
        onRequest: () => ref.refresh(healthAuthorizedProvider),
      ),
    );
  }
}

/// Permission-Anfrage Screen
class _PermissionScreen extends StatelessWidget {
  final VoidCallback onRequest;
  const _PermissionScreen({required this.onRequest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyroColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⭕', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 24),
              const Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: 'VYRO ',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: 'Fit',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: VyroColors.textSecondary,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              const Text(
                'VYRO Fit braucht Zugriff auf Health Connect, um deine Gesundheitsdaten anzuzeigen.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: VyroColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Deine Daten bleiben auf deinem Gerät.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: VyroColors.textTertiary,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: onRequest,
                  style: FilledButton.styleFrom(
                    backgroundColor: VyroColors.steps,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Health Connect verbinden',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Haupt-App mit Bottom Navigation
class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  int _currentIndex = 0;

  final _screens = const [
    OverviewScreen(),
    _PlaceholderScreen(title: 'Herz', icon: '❤️'),
    _PlaceholderScreen(title: 'Schlaf', icon: '🌙'),
    _PlaceholderScreen(title: 'Training', icon: '💪'),
    _PlaceholderScreen(title: 'Ziele', icon: '🎯'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: VyroColors.separator, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(icon: Text('📊', style: TextStyle(fontSize: 20)), label: 'Übersicht'),
            BottomNavigationBarItem(icon: Text('❤️', style: TextStyle(fontSize: 20)), label: 'Herz'),
            BottomNavigationBarItem(icon: Text('🌙', style: TextStyle(fontSize: 20)), label: 'Schlaf'),
            BottomNavigationBarItem(icon: Text('💪', style: TextStyle(fontSize: 20)), label: 'Training'),
            BottomNavigationBarItem(icon: Text('🎯', style: TextStyle(fontSize: 20)), label: 'Ziele'),
          ],
        ),
      ),
    );
  }
}

/// Platzhalter für noch nicht implementierte Screens
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String icon;
  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyroColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: VyroColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kommt bald...',
              style: TextStyle(color: VyroColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
