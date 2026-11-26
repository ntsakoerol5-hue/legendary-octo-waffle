# PayFast ITN webhook

Implement the PayFast Instant Transaction Notification receiver against PayFast's current official documentation before enabling live payments.

The endpoint must:
- Accept provider callbacks over HTTPS.
- Verify the PayFast signature using the exact canonicalization rules and server-side passphrase.
- Validate the callback with PayFast's server validation process as specified by the current integration guide.
- Verify merchant ID, amount, currency, payment status and merchant reference against the stored pending booking.
- Be idempotent: repeated notifications must not double-credit or double-confirm a booking.
- Persist a payment event/audit record and update booking status only after all checks succeed.
- Reject mismatched, replayed, malformed or unverified notifications.

Do not trust the browser return URL. Do not mark a booking paid merely because a customer returns to the success page.
