# GlowBook full-stack starter

Next.js + Supabase starter for the GlowBook salon marketplace.

## Included
- Salon directory reading approved salons from Supabase
- Supabase email/password sign-in
- Protected dashboard route
- Starter PostgreSQL schema and row-level security policies
- PayFast checkout and ITN endpoint placeholders that intentionally return HTTP 501 until securely implemented

## Run locally
1. Install Node.js 20+.
2. Copy `.env.example` to `.env.local` and enter your Supabase project URL and publishable/anon key.
3. Create a Supabase project and run `supabase/schema.sql` in its SQL editor.
4. Install dependencies with `npm install`.
5. Start with `npm run dev`.

## Important
This is an implementation starter, not a live payment system. No real payments are enabled. Do not add real bank details until a backend encryption and authorization design has been reviewed. Do not expose `SUPABASE_SERVICE_ROLE_KEY`, PayFast merchant secrets or encryption keys to the browser. The first admin account must be assigned by a trusted private process. Test RLS with separate customer, salon-owner and admin accounts before deployment.

## Product rules
The proposed commercial model is a 15% booking deposit paid through GlowBook, with the remaining 85% paid directly to the salon. The server must calculate and verify both amounts. Confirm the legal, tax and payment-provider terms before launch.
