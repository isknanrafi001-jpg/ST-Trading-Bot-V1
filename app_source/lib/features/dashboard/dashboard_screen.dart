import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/premium_card.dart';
import '../../models/market_pair.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.onOpenScanner});

  final VoidCallback onOpenScanner;

  static const pairs = [
    MarketPair(
      symbol: 'EUR/USD',
      market: 'Real',
      confidence: 88.4,
      payout: 92,
      direction: TradeDirection.up,
      recommendation: TradeRecommendation.trade,
      risk: 'Low',
      grade: 'A+',
      trend: 'Bullish',
      volatility: 'Medium',
    ),
    MarketPair(
      symbol: 'GBP/USD',
      market: 'OTC',
      confidence: 81.2,
      payout: 90,
      direction: TradeDirection.down,
      recommendation: TradeRecommendation.trade,
      risk: 'Medium',
      grade: 'A',
      trend: 'Bearish',
      volatility: 'High',
    ),
    MarketPair(
      symbol: 'USD/JPY',
      market: 'Real',
      confidence: 67.8,
      payout: 86,
      direction: TradeDirection.up,
      recommendation: TradeRecommendation.noTrade,
      risk: 'High',
      grade: 'B',
      trend: 'Mixed',
      volatility: 'Low',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/st_logo.png',
                width: 54,
                height: 54,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ST Trading AI Bot',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    'Premium Intelligence Engine',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            ),
          ],
        ),
        const SizedBox(height: 20),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, color: AppTheme.gold),
                  SizedBox(width: 8),
                  Text(
                    'AI Market Scanner',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Compare pair confidence, direction, payout, risk and recommendation.',
                style: TextStyle(color: AppTheme.textMuted),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onOpenScanner,
                  icon: const Icon(Icons.radar_rounded),
                  label: const Text('Open Scanner'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const _SectionHeader(title: 'Top opportunities', action: 'View all'),
        const SizedBox(height: 12),
        ...pairs.map((pair) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PairCard(pair: pair),
            )),
        const SizedBox(height: 8),
        const _SectionHeader(title: 'Risk overview', action: 'Balanced'),
        const SizedBox(height: 12),
        const PremiumCard(
          child: Row(
            children: [
              Expanded(child: _Metric(label: 'Risk / Trade', value: '1%')),
              _Divider(),
              Expanded(child: _Metric(label: 'Daily Limit', value: '3%')),
              _Divider(),
              Expanded(child: _Metric(label: 'Max Losses', value: '3')),
            ],
          ),
        ),
      ],
    );
  }
}

class _PairCard extends StatelessWidget {
  const _PairCard({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    final isTrade = pair.recommendation == TradeRecommendation.trade;
    final direction = pair.direction == TradeDirection.up ? 'UP' : 'DOWN';

    return PremiumCard(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF242836),
                child: Text(pair.symbol.substring(0, 1)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pair.symbol,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900)),
                    Text('${pair.market} Market · ${pair.payout}% payout',
                        style: const TextStyle(
                            color: AppTheme.textMuted, fontSize: 12)),
                  ],
                ),
              ),
              Text(
                '${pair.confidence.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Pill(
                text: direction,
                color: pair.direction == TradeDirection.up
                    ? const Color(0xFF21D99F)
                    : AppTheme.red,
              ),
              const SizedBox(width: 8),
              _Pill(
                text: isTrade ? 'TRADE' : 'NO TRADE',
                color: isTrade ? const Color(0xFF21D99F) : AppTheme.gold,
              ),
              const Spacer(),
              Text(
                'Grade ${pair.grade}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 11),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action});
  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ),
        Text(action,
            style: const TextStyle(
                color: AppTheme.red, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 38, color: const Color(0x1AFFFFFF));
  }
}
