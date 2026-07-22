import { Module } from '@nestjs/common';
import { PrismaService } from '../common/prisma.service';
import { SignalsController } from './signals.controller';
import { SignalsService } from './signals.service';

@Module({
  controllers: [SignalsController],
  providers: [SignalsService, PrismaService],
})
export class SignalsModule {}
