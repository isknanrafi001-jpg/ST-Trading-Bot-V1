import 'package:flutter/material.dart';
import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/premium_card.dart';
import '../../core/widgets/signal_card.dart';

class SignalsScreen extends StatefulWidget {
  const SignalsScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<SignalsScreen> createState() => _SignalsScreenState();
}

class _SignalsScreenState extends State<SignalsScreen> {
  String filter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final data = widget.controller.signals.where((item) {
      if (filter == 'TRADE') return item.isTrade;
      if (filter == 'NO_TRADE') return !item.isTrade;
      return true;
    }).toList();

    return RefreshIndicator(
      onRefresh: widget.controller.refreshSignals,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 110),
        children: [
          const Text('Live Signals',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          const Text(
            'Ranked by confidence, risk and confirmation filters.',
            style: TextStyle(color: AppTheme.textMuted),
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'ALL', label: Text('All')),
              ButtonSegment(value: 'TRADE', label: Text('Trade')),
              ButtonSegment(value: 'NO_TRADE', label: Text('No Trade')),
            ],
            selected: {filter},
            onSelectionChanged: (value) =>
                setState(() => filter = value.first),
          ),
          const SizedBox(height: 16),
          if (data.isEmpty)
            const PremiumCard(
              child: Text('No signals match this filter.'),
            )
          else
            ...data.map(
              (signal) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SignalCard(signal: signal),
              ),
            ),
        ],
      ),
    );
  }
}
