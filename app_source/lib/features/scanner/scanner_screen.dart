import 'package:flutter/material.dart';
import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/premium_card.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({
    super.key,
    required this.controller,
    required this.onFinished,
  });
  final AppController controller;
  final VoidCallback onFinished;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  double confidence = 72;
  double balance = 100;
  double risk = 1.5;
  String market = 'REAL';

  Future<void> scan() async {
    await widget.controller.runScan(
      minimumConfidence: confidence,
      market: market,
    );
    if (!mounted) return;
    if (widget.controller.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.controller.error!)),
      );
    } else {
      widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    final amount = balance * risk / 100;
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 110),
      children: [
        const Text('AI Scanner',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 5),
        const Text('Configure filters and scan available market pairs.',
            style: TextStyle(color: AppTheme.textMuted)),
        const SizedBox(height: 18),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Market source',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'REAL', label: Text('Real Forex')),
                  ButtonSegment(value: 'OTC', label: Text('Quotex OTC')),
                  ButtonSegment(value: 'ALL', label: Text('All')),
                ],
                selected: {market},
                onSelectionChanged: (value) =>
                    setState(() => market = value.first),
              ),
              if (market == 'OTC' || market == 'ALL') ...[
                const SizedBox(height: 12),
                const Text(
                  'OTC live feed will remain disabled until an authorized adapter is configured.',
                  style: TextStyle(color: AppTheme.gold, fontSize: 12),
                ),
              ],
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Account balance',
                  prefixText: '\$ ',
                ),
                controller: TextEditingController(text: balance.toStringAsFixed(0)),
                onChanged: (value) =>
                    balance = double.tryParse(value) ?? balance,
              ),
              const SizedBox(height: 18),
              Text('Minimum confidence: ${confidence.toStringAsFixed(0)}%'),
              Slider(
                value: confidence,
                min: 55,
                max: 95,
                divisions: 40,
                onChanged: (value) => setState(() => confidence = value),
              ),
              Text('Risk per trade: ${risk.toStringAsFixed(1)}%'),
              Slider(
                value: risk,
                min: .5,
                max: 5,
                divisions: 18,
                onChanged: (value) => setState(() => risk = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: Row(
            children: [
              Expanded(child: _Result('Suggested amount', '\$${amount.toStringAsFixed(2)}')),
              Expanded(child: _Result('Daily loss limit', '\$${(amount * 3).toStringAsFixed(2)}')),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 58,
          child: FilledButton.icon(
            onPressed: widget.controller.loading ? null : scan,
            icon: widget.controller.loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome_rounded),
            label: Text(widget.controller.loading
                ? 'Scanning markets...'
                : 'Start Premium Scan'),
          ),
        ),
      ],
    );
  }
}

class _Result extends StatelessWidget {
  const _Result(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 5),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
      ],
    );
  }
}
