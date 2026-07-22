enum TradeDirection { up, down }

enum TradeRecommendation { trade, noTrade }

class MarketPair {
  const MarketPair({
    required this.id,
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
    required this.reasons,
    required this.createdAt,
  });

  final String id;
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
  final List<String> reasons;
  final DateTime createdAt;

  bool get isTrade => recommendation == TradeRecommendation.trade;
  bool get isUp => direction == TradeDirection.up;

  factory MarketPair.fromJson(Map<String, dynamic> json) {
    final pair = json['marketPair'] is Map<String, dynamic>
        ? json['marketPair'] as Map<String, dynamic>
        : json;

    return MarketPair(
      id: (json['id'] ?? pair['id'] ?? '${pair['symbol']}-${DateTime.now().millisecondsSinceEpoch}').toString(),
      symbol: (pair['symbol'] ?? json['symbol'] ?? 'EUR/USD').toString(),
      market: (pair['market'] ?? json['market'] ?? 'REAL').toString(),
      confidence: ((json['confidence'] ?? 0) as num).toDouble(),
      payout: ((pair['payout'] ?? json['payout'] ?? 0) as num).round(),
      direction: (json['direction'] ?? 'UP').toString().toUpperCase() == 'DOWN'
          ? TradeDirection.down
          : TradeDirection.up,
      recommendation: (json['recommendation'] ?? 'NO_TRADE').toString().toUpperCase() == 'TRADE'
          ? TradeRecommendation.trade
          : TradeRecommendation.noTrade,
      risk: (json['risk'] ?? 'MEDIUM').toString(),
      grade: (json['grade'] ?? 'B').toString(),
      trend: (json['trend'] ?? 'MIXED').toString(),
      volatility: (json['volatility'] ?? 'MEDIUM').toString(),
      reasons: (json['reasons'] is List)
          ? List<String>.from((json['reasons'] as List).map((e) => e.toString()))
          : const ['Awaiting analysis details'],
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'symbol': symbol,
        'market': market,
        'confidence': confidence,
        'payout': payout,
        'direction': isUp ? 'UP' : 'DOWN',
        'recommendation': isTrade ? 'TRADE' : 'NO_TRADE',
        'risk': risk,
        'grade': grade,
        'trend': trend,
        'volatility': volatility,
        'reasons': reasons,
        'createdAt': createdAt.toIso8601String(),
      };
}
