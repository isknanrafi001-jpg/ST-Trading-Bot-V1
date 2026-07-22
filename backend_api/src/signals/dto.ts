import { IsIn, IsNumber, IsOptional, IsString, Max, Min } from 'class-validator';

export class AnalyzeSignalDto {
  @IsString()
  symbol!: string;

  @IsIn(['REAL', 'OTC'])
  market!: 'REAL' | 'OTC';

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(100)
  payout?: number;
}

export class ScanSignalsDto {
  @IsOptional()
  @IsIn(['REAL', 'OTC', 'ALL'])
  market: 'REAL' | 'OTC' | 'ALL' = 'REAL';

  @IsOptional()
  @IsNumber()
  @Min(50)
  @Max(99)
  minimumConfidence = 72;
}
