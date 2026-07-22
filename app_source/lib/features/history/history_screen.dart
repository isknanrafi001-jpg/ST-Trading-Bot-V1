import 'package:flutter/material.dart';
import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/premium_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final trades = controller.history.where((e) => e.isTrade).length;
    final noTrades = controller.history.length - trades;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 110),
      children: [
        const Text('Signal History',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 5),
        const Text('Saved scanner decisions and their technical context.',
            style: TextStyle(color: AppTheme.textMuted)),
        const SizedBox(height: 16),
        PremiumCard(
          child: Row(
            children: [
              Expanded(child: _Metric('Total', '${controller.history.length}')),
              Expanded(child: _Metric('Trade', '$trades')),
              Expanded(child: _Metric('No Trade', '$noTrades')),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...controller.history.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(
                    item.isUp
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: item.isUp
                        ? const Color(0xFF20D99F)
                        : AppTheme.red,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item.symbol} · ${item.market}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900)),
                        Text(
                          '${item.createdAt.hour.toString().padLeft(2, '0')}:${item.createdAt.minute.toString().padLeft(2, '0')} · ${item.confidence.toStringAsFixed(1)}%',
                          style: const TextStyle(
                              color: AppTheme.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    item.isTrade ? 'TRADE' : 'NO TRADE',
                    style: TextStyle(
                      color: item.isTrade
                          ? const Color(0xFF20D99F)
                          : AppTheme.gold,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        Text(label,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
      ],
    );
  }
}
