import { supabase } from "./supabase";

// Calls a trusted Edge Function. The server must load the service price,
// validate salon approval and availability, and calculate the 15% deposit.
// Never trust prices or payment amounts supplied by the browser.
export async function createBooking(input: {
  serviceId: string;
  appointmentAt: string;
}) {
  const { data, error } = await supabase.functions.invoke("create-booking", {
    body: input
  });
  if (error) throw error;
  return data;
}

// Requests a hosted PayFast checkout from a trusted server function.
// Merchant credentials and payment signatures must never be generated in
// client-side code.
export async function startDepositCheckout(bookingId: string) {
  const { data, error } = await supabase.functions.invoke("payfast-create-checkout", {
    body: { bookingId }
  });
  if (error) throw error;
  return data;
}
