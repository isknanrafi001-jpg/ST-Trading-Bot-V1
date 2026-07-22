import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/premium_card.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String risk = 'Balanced';
  double confidence = 72;
  double balance = 100;
  double riskPercent = 1;

  double get suggestedAmount => balance * riskPercent / 100;

  void applyRisk(String value) {
    setState(() {
      risk = value;
      if (value == 'Safe') {
        confidence = 78;
        riskPercent = .5;
      } else if (value == 'Aggressive') {
        confidence = 65;
        riskPercent = 2;
      } else {
        confidence = 72;
        riskPercent = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
      children: [
        const Text(
          'AI Scanner',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        const Text(
          'Configure risk and scan market pairs.',
          style: TextStyle(color: AppTheme.textMuted),
        ),
        const SizedBox(height: 18),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Risk profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Safe', label: Text('Safe')),
                  ButtonSegment(value: 'Balanced', label: Text('Balanced')),
                  ButtonSegment(value: 'Aggressive', label: Text('Aggressive')),
                ],
                selected: {risk},
                onSelectionChanged: (value) => applyRisk(value.first),
              ),
              const SizedBox(height: 18),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Account balance'),
                controller: TextEditingController(
                  text: balance.toStringAsFixed(0),
                ),
                onChanged: (v) => setState(() {
                  balance = double.tryParse(v) ?? balance;
                }),
              ),
              const SizedBox(height: 14),
              Text('Minimum confidence: ${confidence.toStringAsFixed(0)}%'),
              Slider(
                value: confidence,
                min: 60,
                max: 90,
                divisions: 30,
                onChanged: (value) => setState(() => confidence = value),
              ),
              const SizedBox(height: 4),
              Text('Risk per trade: ${riskPercent.toStringAsFixed(1)}%'),
              Slider(
                value: riskPercent,
                min: .5,
                max: 5,
                divisions: 9,
                onChanged: (value) => setState(() => riskPercent = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: Row(
            children: [
              Expanded(
                child: _Result(
                  label: 'Suggested amount',
                  value: '\$${suggestedAmount.toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: _Result(
                  label: 'Daily loss limit',
                  value: '\$${(suggestedAmount * 3).toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 58,
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Scanner request prepared.')),
              );
            },
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Text(
              'Start Premium Scan',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({required this.label, required this.value});
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
