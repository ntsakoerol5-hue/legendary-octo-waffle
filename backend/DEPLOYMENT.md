# GlowBook backend setup checklist

## 1. Create Supabase project
1. Create a Supabase project in your own account and keep the database password private.
2. Copy the project URL and publishable/anon key from the Supabase project API settings.
3. Put those public values in your front-end app's local environment file (never commit a populated .env file).
4. Apply the SQL in `backend/schema.sql` using the Supabase SQL editor or migrations.
5. Review every RLS policy and test with separate customer, salon-owner and administrator accounts.

## 2. Authentication
- Enable email authentication and configure email confirmation.
- Set the correct production site URL and redirect allow-list.
- Create the first administrator role through a trusted private SQL/admin process only.
- Do not allow a user to set their own role. Do not expose service-role credentials.

## 3. Deploy trusted functions
- Implement and deploy `create-booking` and `payfast-create-checkout` using the contracts in the matching folders.
- Store provider secrets with Supabase Edge Function secrets, not in GitHub.
- Add rate limits, audit logs, idempotency keys and monitoring.

## 4. PayFast
- Register/verify a PayFast merchant account.
- Configure sandbox credentials first.
- Implement the current official hosted checkout signature rules and ITN server validation.
- Test successful, failed, cancelled, duplicate and tampered notifications.
- Only switch to live credentials after reconciliation and refund tests pass.

## 5. Front-end integration
The current `index.html` remains a browser-only demonstration. The TypeScript files in `backend/src` are integration modules, not wired into that static page. A production front end needs a build setup (for example Vite), dependency installation, environment variables and real sign-in/booking screens calling these modules.

## 6. Launch gates
- Legal review of the marketplace's 15% deposit/commission arrangement.
- POPIA privacy notice, retention/deletion process and incident response.
- Secure handling of customer and merchant data.
- Tested booking availability, cancellations, refunds and settlement reconciliation.
- No real banking details or payment credentials stored in localStorage.
