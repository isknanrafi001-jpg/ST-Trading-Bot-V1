# ST Trading AI Bot — Fullstack Ready V2

এই ZIP-এ Flutter app এবং NestJS/PostgreSQL backend দুটোই সম্পূর্ণভাবে সংযুক্ত করার মতো করে প্রস্তুত করা হয়েছে।

## APK এখন কী করবে

API URL না দিলে:

- Login কাজ করবে
- Home dashboard পূর্ণ data দেখাবে
- Scanner কাজ করবে
- Real Forex / OTC filter থাকবে
- Signals page পূর্ণ থাকবে
- TRADE / NO TRADE recommendation দেখাবে
- History page data দেখাবে
- Profile page পূর্ণ থাকবে
- App স্পষ্টভাবে preview/API-ready mode-এ থাকবে

API URL দিলে:

- Login backend-এ যাবে
- Scanner `POST /signals/scan` ব্যবহার করবে
- Signals/history server database থেকে আসবে
- PostgreSQL-এ signal save হবে

## Repository root

```text
.github/
app_source/
backend_api/
docs/
docker-compose.yml
README.md
```

## GitHub দিয়ে APK build

1. ZIP extract করে repository root-এর file upload করো।
2. Actions → `Build ST Trading AI Bot`
3. `Run workflow`
4. API না থাকলে `api_base_url` খালি রাখো।
5. API deploy করার পরে লিখবে:

```text
https://YOUR-DOMAIN/api/v1
```

6. Artifact থেকে APK download করো।

## Backend endpoints

```text
GET  /api/v1/health
POST /api/v1/auth/register
POST /api/v1/auth/login
GET  /api/v1/market/pairs
POST /api/v1/signals/analyze
POST /api/v1/signals/scan
GET  /api/v1/signals/history
```

## Backend local/VPS deployment

```bash
cp backend_api/.env.example backend_api/.env
docker compose up -d --build
docker compose exec api npx prisma db push
docker compose exec api npm run prisma:seed
```

## Market data API পরে যোগ করার জায়গা

`backend_api/.env`:

```env
MARKET_DATA_API_KEY=
MARKET_DATA_BASE_URL=
```

বর্তমান analysis engine app/backend integration test করার জন্য। Real Forex provider API পাওয়া গেলে `SignalsService.calculate()`-এর জায়গায় live OHLC adapter এবং indicator engine যুক্ত করতে হবে। Quotex OTC-কে live হিসেবে দেখাতে কেবল authorized feed ব্যবহার করতে হবে।
