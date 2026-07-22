import 'package:flutter/material.dart';
import '../../models/market_pair.dart';
import '../theme/app_theme.dart';
import 'premium_card.dart';

class SignalCard extends StatelessWidget {
  const SignalCard({super.key, required this.signal, this.compact = false});
  final MarketPair signal;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final directionColor =
        signal.isUp ? const Color(0xFF20D99F) : AppTheme.red;
    final recommendationColor =
        signal.isTrade ? const Color(0xFF20D99F) : AppTheme.gold;

    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: directionColor.withValues(alpha: .13),
                child: Text(
                  signal.symbol.characters.first,
                  style: TextStyle(
                    color: directionColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(signal.symbol,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900)),
                    Text(
                      '${signal.market} · ${signal.payout}% payout',
                      style: const TextStyle(
                          color: AppTheme.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                '${signal.confidence.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: AppTheme.gold,
                  fontWeight: FontWeight.w900,
                  fontSize: 21,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Pill(
                text: signal.isUp ? 'UP' : 'DOWN',
                color: directionColor,
              ),
              _Pill(
                text: signal.isTrade ? 'TRADE' : 'NO TRADE',
                color: recommendationColor,
              ),
              _Pill(text: 'RISK ${signal.risk}', color: Colors.blueGrey),
              _Pill(text: 'GRADE ${signal.grade}', color: Colors.deepPurpleAccent),
            ],
          ),
          if (!compact) ...[
            const SizedBox(height: 14),
            Text(
              '${signal.trend} trend · ${signal.volatility} volatility',
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            ...signal.reasons.take(3).map(
                  (reason) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded,
                            size: 16, color: AppTheme.gold),
                        const SizedBox(width: 7),
                        Expanded(child: Text(reason)),
                      ],
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
