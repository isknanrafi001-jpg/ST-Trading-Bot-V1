import '../../models/market_pair.dart';

abstract final class DemoData {
  static DateTime _time(int minutesAgo) =>
      DateTime.now().subtract(Duration(minutes: minutesAgo));

  static List<MarketPair> signals() => [
        MarketPair(
          id: 'demo-eurusd',
          symbol: 'EUR/USD',
          market: 'REAL',
          confidence: 88.4,
          payout: 92,
          direction: TradeDirection.up,
          recommendation: TradeRecommendation.trade,
          risk: 'LOW',
          grade: 'A+',
          trend: 'BULLISH',
          volatility: 'MEDIUM',
          reasons: const [
            'EMA trend alignment confirmed',
            'RSI momentum remains healthy',
            'Support zone held successfully',
          ],
          createdAt: _time(2),
        ),
        MarketPair(
          id: 'demo-gbpusd',
          symbol: 'GBP/USD',
          market: 'REAL',
          confidence: 79.6,
          payout: 90,
          direction: TradeDirection.down,
          recommendation: TradeRecommendation.trade,
          risk: 'MEDIUM',
          grade: 'A',
          trend: 'BEARISH',
          volatility: 'HIGH',
          reasons: const [
            'Lower-high structure detected',
            'MACD momentum is bearish',
            'Volatility filter passed',
          ],
          createdAt: _time(6),
        ),
        MarketPair(
          id: 'demo-usdjpy',
          symbol: 'USD/JPY',
          market: 'REAL',
          confidence: 66.8,
          payout: 86,
          direction: TradeDirection.up,
          recommendation: TradeRecommendation.noTrade,
          risk: 'HIGH',
          grade: 'B',
          trend: 'MIXED',
          volatility: 'LOW',
          reasons: const [
            'Possible bullish direction',
            'Higher-timeframe confirmation is weak',
            'Confidence is below trade threshold',
          ],
          createdAt: _time(11),
        ),
        MarketPair(
          id: 'demo-eurotc',
          symbol: 'EUR/USD',
          market: 'OTC',
          confidence: 61.2,
          payout: 88,
          direction: TradeDirection.down,
          recommendation: TradeRecommendation.noTrade,
          risk: 'HIGH',
          grade: 'B',
          trend: 'BEARISH',
          volatility: 'MEDIUM',
          reasons: const [
            'OTC adapter is not connected',
            'Direction is demonstration data only',
            'Live OTC trading is disabled',
          ],
          createdAt: _time(17),
        ),
      ];
}
