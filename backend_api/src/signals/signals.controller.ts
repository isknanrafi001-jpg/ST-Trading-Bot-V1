import { Body, Controller, Post } from '@nestjs/common';
import { AnalyzeSignalDto, ScanSignalsDto } from './dto';
import { SignalsService } from './signals.service';

@Controller('signals')
export class SignalsController {
  constructor(private service: SignalsService) {}

  @Post('analyze')
  analyze(@Body() dto: AnalyzeSignalDto) {
    return this.service.analyze(dto);
  }

  @Post('scan')
  scan(@Body() dto: ScanSignalsDto) {
    return this.service.scan(dto);
  }
}
