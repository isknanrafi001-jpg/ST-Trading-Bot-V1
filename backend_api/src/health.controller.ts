import { Controller, Get } from '@nestjs/common';

@Controller()
export class HealthController {
  @Get('health')
  health() {
    return {
      ok: true,
      app: 'ST Trading AI Bot API',
      marketDataConfigured: Boolean(process.env.MARKET_DATA_API_KEY),
      timestamp: new Date().toISOString(),
    };
  }
}
