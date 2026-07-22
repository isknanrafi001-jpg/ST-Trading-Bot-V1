import 'package:flutter/material.dart';
import '../../core/network/api_config.dart';
import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/premium_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
      children: [
        const Text('Profile',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 18),
        PremiumCard(
          child: Row(
            children: [
              const CircleAvatar(
                radius: 34,
                backgroundColor: AppTheme.darkRed,
                child: Icon(Icons.person_rounded, size: 36),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.userName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900)),
                    Text(controller.userEmail,
                        style: const TextStyle(color: AppTheme.textMuted)),
                    const SizedBox(height: 6),
                    Text(
                      ApiConfig.isConfigured ? 'PRODUCTION CLIENT' : 'PREVIEW MODE',
                      style: const TextStyle(
                        color: AppTheme.gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const PremiumCard(
          child: Column(
            children: [
              _Setting(Icons.workspace_premium_rounded, 'Subscription', 'Premium'),
              Divider(),
              _Setting(Icons.notifications_active_outlined, 'Signal alerts', 'Enabled'),
              Divider(),
              _Setting(Icons.security_rounded, 'Risk protection', 'Balanced'),
              Divider(),
              _Setting(Icons.api_rounded, 'Backend API', 'Ready to configure'),
              Divider(),
              _Setting(Icons.info_outline_rounded, 'Version', '2.0.0'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: controller.logout,
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Sign out'),
        ),
      ],
    );
  }
}

class _Setting extends StatelessWidget {
  const _Setting(this.icon, this.title, this.value);
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppTheme.gold),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      trailing: Text(value,
          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
    );
  }
}
