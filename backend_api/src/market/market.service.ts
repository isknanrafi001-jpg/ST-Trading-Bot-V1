import { Injectable } from '@nestjs/common';
import { PrismaService } from '../common/prisma.service';

@Injectable()
export class MarketService {
  constructor(private prisma: PrismaService) {}

  listPairs() {
    return this.prisma.marketPair.findMany({
      where: { enabled: true },
      orderBy: [{ market: 'asc' }, { symbol: 'asc' }],
    });
  }
}
