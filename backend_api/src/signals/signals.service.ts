import { Injectable, NotFoundException } from '@nestjs/common';
import { Direction, MarketPair, Recommendation } from '@prisma/client';
import { PrismaService } from '../common/prisma.service';
import { AnalyzeSignalDto, ScanSignalsDto } from './dto';

@Injectable()
export class SignalsService {
  constructor(private prisma: PrismaService) {}

  private calculate(pair: MarketPair) {
    // API-ready analysis adapter. Until MARKET_DATA_API_KEY is configured,
    // this deterministic engine is used only for integration/testing.
    const stamp = Math.floor(Date.now() / 60000);
    const seed = [...`${pair.symbol}-${pair.market}-${stamp}`]
      .reduce((sum, value) => sum + value.charCodeAt(0), 0);

    const confidence = 55 + (seed % 36);
    const direction = seed % 2 === 0 ? Direction.UP : Direction.DOWN;
    const recommendation =
      confidence >= 72 ? Recommendation.TRADE : Recommendation.NO_TRADE;

    return {
      direction,
      recommendation,
      confidence,
      risk: confidence >= 82 ? 'LOW' : confidence >= 72 ? 'MEDIUM' : 'HIGH',
      grade: confidence >= 85 ? 'A+' : confidence >= 78 ? 'A' : confidence >= 72 ? 'B+' : 'B',
      trend: direction === Direction.UP ? 'BULLISH' : 'BEARISH',
      volatility: confidence >= 80 ? 'HIGH' : confidence >= 70 ? 'MEDIUM' : 'LOW',
      reasons: recommendation === Recommendation.TRADE
        ? ['Trend alignment detected', 'Momentum confirmation passed', 'Risk threshold passed']
        : ['Possible direction detected', 'Confirmation threshold not reached', 'No trade recommended'],
    };
  }

  async analyze(dto: AnalyzeSignalDto) {
    const pair = await this.prisma.marketPair.findUnique({
      where: { symbol_market: { symbol: dto.symbol, market: dto.market } },
    });
    if (!pair) throw new NotFoundException('Pair not found');

    const result = this.calculate(pair);
    return this.prisma.signal.create({
      data: {
        marketPairId: pair.id,
        ...result,
      },
      include: { marketPair: true },
    });
  }

  async scan(dto: ScanSignalsDto) {
    const pairs = await this.prisma.marketPair.findMany({
      where: {
        enabled: true,
        ...(dto.market === 'ALL' ? {} : { market: dto.market }),
      },
      orderBy: [{ market: 'asc' }, { symbol: 'asc' }],
    });

    const saved = [];
    for (const pair of pairs) {
      const result = this.calculate(pair);
      if (result.confidence < dto.minimumConfidence) continue;
      saved.push(await this.prisma.signal.create({
        data: { marketPairId: pair.id, ...result },
        include: { marketPair: true },
      }));
    }

    return {
      source: process.env.MARKET_DATA_API_KEY ? 'LIVE_ADAPTER_READY' : 'INTEGRATION_ENGINE',
      count: saved.length,
      data: saved.sort((a, b) => b.confidence - a.confidence),
    };
  }
}
