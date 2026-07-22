import { PrismaClient, MarketType } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const pairs = [
    ['EUR/USD', MarketType.REAL, 92],
    ['GBP/USD', MarketType.REAL, 90],
    ['USD/JPY', MarketType.REAL, 86],
    ['AUD/USD', MarketType.REAL, 87],
    ['USD/CAD', MarketType.REAL, 84],
    ['EUR/JPY', MarketType.REAL, 89],
    ['GBP/JPY', MarketType.REAL, 88],
    ['EUR/GBP', MarketType.REAL, 83],
    ['NZD/USD', MarketType.REAL, 82],
    ['EUR/USD', MarketType.OTC, 88],
    ['GBP/USD', MarketType.OTC, 87],
    ['USD/JPY', MarketType.OTC, 86],
    ['GBP/JPY', MarketType.OTC, 85],
  ] as const;

  for (const [symbol, market, payout] of pairs) {
    await prisma.marketPair.upsert({
      where: { symbol_market: { symbol, market } },
      update: { enabled: true, payout },
      create: { symbol, market, payout },
    });
  }
}

main()
  .catch(console.error)
  .finally(async () => prisma.$disconnect());
