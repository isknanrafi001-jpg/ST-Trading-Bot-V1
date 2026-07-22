import { Controller, Get, Query } from '@nestjs/common';
import { PrismaService } from '../common/prisma.service';

@Controller('signals')
export class HistoryController {
  constructor(private prisma: PrismaService) {}

  @Get('history')
  history(@Query('limit') limit = '50') {
    const take = Math.min(Math.max(Number(limit) || 50, 1), 100);
    return this.prisma.signal.findMany({
      take,
      orderBy: { createdAt: 'desc' },
      include: { marketPair: true },
    });
  }
}
