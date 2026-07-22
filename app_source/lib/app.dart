import 'package:flutter/material.dart';
import 'core/state/app_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/history/history_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/scanner/scanner_screen.dart';
import 'features/signals/signals_screen.dart';

class StTradingApp extends StatefulWidget {
  const StTradingApp({super.key});

  @override
  State<StTradingApp> createState() => _StTradingAppState();
}

class _StTradingAppState extends State<StTradingApp> {
  final controller = AppController();

  @override
  void initState() {
    super.initState();
    controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          title: 'ST Trading AI Bot',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          home: !controller.initialized
              ? const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                )
              : controller.signedIn
                  ? MainShell(controller: controller)
                  : LoginScreen(controller: controller),
        );
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.controller});
  final AppController controller;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        controller: widget.controller,
        onOpenScanner: () => setState(() => index = 1),
        onOpenSignals: () => setState(() => index = 2),
      ),
      ScannerScreen(
        controller: widget.controller,
        onFinished: () => setState(() => index = 2),
      ),
      SignalsScreen(controller: widget.controller),
      HistoryScreen(controller: widget.controller),
      ProfileScreen(controller: widget.controller),
    ];

    return Scaffold(
      body: SafeArea(child: IndexedStack(index: index, children: screens)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.radar_outlined),
            selectedIcon: Icon(Icons.radar_rounded),
            label: 'Scanner',
          ),
          NavigationDestination(
            icon: Icon(Icons.bolt_outlined),
            selectedIcon: Icon(Icons.bolt_rounded),
            label: 'Signals',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
