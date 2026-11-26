# create-booking Edge Function

This endpoint is intentionally documented as a deployment task rather than a fake working payment endpoint.

Required server-side behavior:
1. Require a valid Supabase user JWT.
2. Accept only service ID and requested appointment time from the client.
3. Load the service and salon from PostgreSQL; require an approved salon and active service.
4. Validate salon availability and prevent overlapping bookings using a database transaction/constraint.
5. Calculate the total and 15% deposit on the server (integer cents); calculate the 85% salon balance.
6. Create a booking with status `pending_deposit`.
7. Return only the booking ID and safe summary.

Do not accept client-supplied prices, deposit amounts, salon IDs, customer IDs, or booking status as authoritative. Add rate limiting, idempotency and audit logging before production.
