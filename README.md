# GlowBook — Salon Booking Marketplace Prototype

A responsive, front-end marketplace concept for salon discovery and appointment booking.

## Business model
- Client books a salon service.
- Client pays a 15% deposit online to GlowBook.
- Salon collects the remaining 85% directly from the client at the salon.
- The prototype calculates and displays the split at booking time.

## Features
- Salon discovery, search and category filters.
- Service menus with prices and durations.
- Booking form with date and time selection.
- 15% / 85% price breakdown.
- Demo booking confirmation.
- Salon dashboard with locally stored demo bookings and totals.
- Responsive desktop and mobile layout.

## Run
Open `index.html` in a browser, or enable GitHub Pages in repository Settings → Pages → Deploy from a branch → `main` → `/ (root)`.

## Important prototype limitation
This is a front-end demonstration. It does not process real payments, authenticate users, send notifications, or synchronize salon calendars. Demo bookings are stored in the current browser's localStorage and are not shared between devices.

Before accepting real deposits, integrate a South Africa-supported payment provider (for example, PayFast or Peach Payments), a secure backend/database, webhook verification, refunds/cancellations, salon onboarding and payout/reconciliation controls. Confirm the legal and contractual structure for collecting a 15% marketplace commission. Never store card details in this static app.

## Suggested production architecture
- Front end: React / Next.js
- Backend: authenticated API
- Database: PostgreSQL
- Payments: hosted checkout with verified webhooks
- Roles: client, salon owner, marketplace administrator
- Booking states: pending deposit, confirmed, completed, cancelled, refunded
