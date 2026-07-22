import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { MarketModule } from './market/market.module';
import { SignalsModule } from './signals/signals.module';
import { HistoryModule } from './history/history.module';
import { PrismaService } from './common/prisma.service';
import { HealthController } from './health.controller';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    AuthModule,
    UsersModule,
    MarketModule,
    SignalsModule,
    HistoryModule,
  ],
  controllers: [HealthController],
  providers: [PrismaService],
})
export class AppModule {}
