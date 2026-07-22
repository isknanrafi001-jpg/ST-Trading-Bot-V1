import 'package:flutter/material.dart';
import '../../core/network/api_config.dart';
import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/premium_card.dart';
import '../../core/widgets/signal_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.controller,
    required this.onOpenScanner,
    required this.onOpenSignals,
  });

  final AppController controller;
  final VoidCallback onOpenScanner;
  final VoidCallback onOpenSignals;

  @override
  Widget build(BuildContext context) {
    final trades = controller.signals.where((e) => e.isTrade).length;
    final average = controller.signals.isEmpty
        ? 0.0
        : controller.signals
                .map((e) => e.confidence)
                .reduce((a, b) => a + b) /
            controller.signals.length;

    return RefreshIndicator(
      onRefresh: controller.refreshSignals,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 110),
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset('assets/images/st_logo.png',
                    width: 54, height: 54),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ST Trading AI Bot',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w900)),
                    Text(
                      ApiConfig.isConfigured
                          ? 'Backend connected'
                          : 'API-ready preview data',
                      style: const TextStyle(
                          color: AppTheme.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: controller.refreshSignals,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 18),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Market intelligence',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                const Text(
                  'Direction is always shown. TRADE appears only when filters pass.',
                  style: TextStyle(color: AppTheme.textMuted),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _Metric('Signals', '${controller.signals.length}')),
                    Expanded(child: _Metric('Trade setups', '$trades')),
                    Expanded(child: _Metric('Avg confidence', '${average.toStringAsFixed(0)}%')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onOpenScanner,
                        icon: const Icon(Icons.radar_rounded),
                        label: const Text('Scanner'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: onOpenSignals,
                        icon: const Icon(Icons.bolt_rounded),
                        label: const Text('Signals'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('Top opportunities',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          if (controller.loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            )
          else if (controller.signals.isEmpty)
            const PremiumCard(
              child: Text('No signal passed the current filters.'),
            )
          else
            ...controller.signals.take(3).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SignalCard(signal: item, compact: true),
                  ),
                ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
      ],
    );
  }
}
