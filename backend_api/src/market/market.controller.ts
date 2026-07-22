import { Controller, Get } from '@nestjs/common';
import { MarketService } from './market.service';

@Controller('market')
export class MarketController {
  constructor(private service: MarketService) {}

  @Get('pairs')
  listPairs() {
    return this.service.listPairs();
  }
}
