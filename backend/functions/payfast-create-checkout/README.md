# payfast-create-checkout Edge Function

This is the integration contract for creating a hosted PayFast checkout. It is not a live payment endpoint until implemented, tested in PayFast sandbox and deployed.

Required behavior:
- Require a valid authenticated user.
- Load the booking from the database and verify the caller owns it.
- Confirm booking is still pending and no successful payment exists.
- Calculate the payable amount from the server-stored deposit amount.
- Build the hosted checkout request using PayFast's current official integration specification.
- Generate any required signature on the server only, using secrets stored with Supabase Edge Function secrets.
- Use sandbox mode until end-to-end tests pass.
- Return the hosted checkout URL and safe reference only.

Never put merchant keys, passphrases, service-role keys or signatures in browser code or GitHub. Never mark a booking paid based on a browser redirect.
