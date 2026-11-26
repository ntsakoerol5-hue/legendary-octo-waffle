# GlowBook — Salon Booking Marketplace

GlowBook is a responsive salon-discovery and booking marketplace prototype. It demonstrates the customer journey and the administration workflow for a South African salon marketplace.

## Business model
- A client selects a salon service and submits a booking.
- The proposed model collects a 15% deposit through GlowBook.
- The salon collects the remaining 85% directly from the client at the salon.
- A live launch must collect the deposit through a hosted payment provider and confirm bookings only after a verified payment webhook.

## Current prototype features
- Responsive marketplace with salon search and category filters.
- Service menus, prices and durations.
- Booking form with date/time selection and 15% / 85% calculation.
- Demo booking confirmation and booking activity.
- Salon partner application form.
- Admin review workflow to approve, reject or reopen salon applications.
- Approved demo salons appear in the marketplace.
- Booking management actions: confirm, complete and cancel.
- Admin sign-in screen and admin dashboard preview.
- GlowBook settlement bank-detail form with masked account display.
- Salon dashboard and booking/deposit totals.

## Run
Open `index.html` in a browser, or enable GitHub Pages in repository Settings → Pages → Deploy from a branch → `main` → `/ (root)`.

## Important security and payment limitations
This is still a browser-only prototype. Salon applications, bookings and bank settings are stored in the current browser's localStorage; they are not shared between devices and are not protected by server-side access controls. The admin sign-in screen is a visual demo only: it does not verify credentials. Do not enter real passwords, customer information or bank details. No real payments are taken and no booking is actually confirmed by a payment processor.

A live launch requires:
1. A secure backend and hosted PostgreSQL database.
2. Real authentication (e.g. Supabase Auth) with server-enforced administrator, salon-owner and customer roles.
3. Server-side authorization and row-level security for every private record.
4. Encrypted-at-rest banking details with access restricted to authorized settlement administrators.
5. Hosted checkout through a South Africa-supported provider, signed webhook verification, refund/cancellation handling and reconciliation.
6. Salon identity/business verification, terms, privacy notices and support processes.

## Backend starter
`backend/schema.sql` is a starter PostgreSQL schema for profiles, salon applications/listings, services, bookings and settlement accounts. It is not deployed or connected to this front end. Review it with a developer/security professional, configure the required database roles and secrets, and test the row-level-security policies before production use.

## Suggested production architecture
- Front end: React / Next.js
- Authentication: Supabase Auth or equivalent
- Database: PostgreSQL with row-level security
- Payments: hosted checkout + verified webhooks
- Roles: customer, salon owner, marketplace administrator
- Booking states: pending deposit, confirmed, completed, cancelled, refunded
- Settlement: GlowBook's 15% platform amount reconciled separately from the 85% collected by the salon in person

Confirm the legal, tax and contractual structure for collecting marketplace deposits and commissions before accepting money from customers.


## Backend integration scaffold (not live yet)
The `backend/` folder now contains a Supabase client/auth starter, PostgreSQL schema, deployment checklist and PayFast integration contracts. The current static `index.html` is not connected to these modules. No Supabase project, authentication provider, payment merchant account or live webhook has been configured. Follow [backend/DEPLOYMENT.md](backend/DEPLOYMENT.md) and configure your own project credentials before integration. Never commit populated environment files or secret keys.
