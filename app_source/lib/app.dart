import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/scanner/scanner_screen.dart';
import 'features/signals/signals_screen.dart';
import 'features/history/history_screen.dart';
import 'features/profile/profile_screen.dart';

class StTradingApp extends StatefulWidget {
  const StTradingApp({super.key});

  @override
  State<StTradingApp> createState() => _StTradingAppState();
}

class _StTradingAppState extends State<StTradingApp> {
  bool signedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ST Trading AI Bot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: signedIn
          ? const MainShell()
          : LoginScreen(onSignedIn: () => setState(() => signedIn = true)),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(onOpenScanner: () => setState(() => index = 1)),
      const ScannerScreen(),
      const SignalsScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
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
