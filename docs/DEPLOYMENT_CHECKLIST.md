# Production deployment checklist

- Use managed PostgreSQL or a protected VPS database.
- Set strong JWT secrets.
- Put the API behind HTTPS.
- Restrict CORS to the app/admin domains.
- Add rate limiting and refresh-token persistence before public release.
- Add email verification and password reset.
- Add payment-provider webhooks.
- Add Crashlytics and server monitoring.
- Replace the placeholder signal adapter with authorized live market data.
- Configure Android release signing for Play Store updates.
