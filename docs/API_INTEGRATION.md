# Market-data API integration

Recommended adapter contract:

```ts
export interface MarketDataAdapter {
  candles(symbol: string, interval: string, outputSize: number): Promise<Candle[]>;
  quote(symbol: string): Promise<Quote>;
}
```

Provider response should be normalized before analysis:

```ts
type Candle = {
  time: Date;
  open: number;
  high: number;
  low: number;
  close: number;
  volume?: number;
};
```

Do not expose the provider API key in Flutter. Keep it only inside backend environment variables.
