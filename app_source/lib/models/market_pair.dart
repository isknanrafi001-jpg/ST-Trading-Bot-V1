enum TradeDirection { up, down }

enum TradeRecommendation { trade, noTrade }

class MarketPair {
  const MarketPair({
    required this.symbol,
    required this.market,
    required this.confidence,
    required this.payout,
    required this.direction,
    required this.recommendation,
    required this.risk,
    required this.grade,
    required this.trend,
    required this.volatility,
  });

  final String symbol;
  final String market;
  final double confidence;
  final int payout;
  final TradeDirection direction;
  final TradeRecommendation recommendation;
  final String risk;
  final String grade;
  final String trend;
  final String volatility;
}
