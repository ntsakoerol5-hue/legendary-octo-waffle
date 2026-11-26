-- GlowBook PostgreSQL starter schema (Supabase-compatible).
-- Review and test policies before production. Do not store plaintext bank details.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default '',
  role text not null default 'customer' check (role in ('customer','salon_owner','admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.salons (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete restrict,
  business_name text not null,
  contact_name text not null,
  email text not null,
  phone text not null,
  area text not null,
  category text not null check (category in ('Hair','Nails','Beauty','Barber')),
  description text not null default '',
  status text not null default 'pending' check (status in ('pending','approved','rejected','suspended')),
  reviewed_by uuid references public.profiles(id),
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.services (
  id uuid primary key default gen_random_uuid(),
  salon_id uuid not null references public.salons(id) on delete cascade,
  name text not null,
  description text not null default '',
  price_cents integer not null check (price_cents > 0),
  duration_minutes integer not null check (duration_minutes > 0),
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.profiles(id) on delete restrict,
  salon_id uuid not null references public.salons(id) on delete restrict,
  service_id uuid not null references public.services(id) on delete restrict,
  appointment_at timestamptz not null,
  total_cents integer not null check (total_cents > 0),
  deposit_cents integer not null check (deposit_cents >= 0),
  salon_balance_cents integer not null check (salon_balance_cents >= 0),
  status text not null default 'pending_deposit' check (status in ('pending_deposit','confirmed','completed','cancelled','refunded')),
  payment_reference text unique,
  created_at timestamptz not null default now(),
  check (deposit_cents + salon_balance_cents = total_cents)
);

-- These values must be encrypted by the trusted backend before insertion.
-- Never expose this table to customers or salon-owner browser clients.
create table if not exists public.settlement_accounts (
  id uuid primary key default gen_random_uuid(),
  salon_id uuid references public.salons(id) on delete cascade,
  account_holder_ciphertext text not null,
  bank_name text not null,
  account_number_ciphertext text not null,
  branch_code_ciphertext text,
  currency char(3) not null default 'ZAR',
  verified_at timestamptz,
  created_at timestamptz not null default now()
);

create or replace function public.is_admin()
returns boolean language sql stable security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.role = 'admin'
  );
$$;

alter table public.profiles enable row level security;
alter table public.salons enable row level security;
alter table public.services enable row level security;
alter table public.bookings enable row level security;
alter table public.settlement_accounts enable row level security;

create policy "profiles read self or admin" on public.profiles
for select using (id = auth.uid() or public.is_admin());
create policy "profiles update self or admin" on public.profiles
for update using (id = auth.uid() or public.is_admin())
with check (id = auth.uid() or public.is_admin());

create policy "public can view approved salons" on public.salons
for select using (status = 'approved' or owner_id = auth.uid() or public.is_admin());
create policy "salon owner submits application" on public.salons
for insert with check (owner_id = auth.uid());
create policy "owner or admin updates salon" on public.salons
for update using (owner_id = auth.uid() or public.is_admin())
with check (owner_id = auth.uid() or public.is_admin());

create policy "public can view active services of approved salons" on public.services
for select using (
  active and exists (select 1 from public.salons s where s.id = salon_id and s.status = 'approved')
  or exists (select 1 from public.salons s where s.id = salon_id and (s.owner_id = auth.uid() or public.is_admin()))
);
create policy "salon owner manages services" on public.services
for all using (exists (select 1 from public.salons s where s.id = salon_id and s.owner_id = auth.uid()) or public.is_admin())
with check (exists (select 1 from public.salons s where s.id = salon_id and s.owner_id = auth.uid()) or public.is_admin());

create policy "customer or salon owner reads booking" on public.bookings
for select using (
  customer_id = auth.uid()
  or exists (select 1 from public.salons s where s.id = salon_id and s.owner_id = auth.uid())
  or public.is_admin()
);
create policy "customer creates own booking" on public.bookings
for insert with check (customer_id = auth.uid());
create policy "authorized party updates booking" on public.bookings
for update using (
  customer_id = auth.uid()
  or exists (select 1 from public.salons s where s.id = salon_id and s.owner_id = auth.uid())
  or public.is_admin()
)
with check (
  customer_id = auth.uid()
  or exists (select 1 from public.salons s where s.id = salon_id and s.owner_id = auth.uid())
  or public.is_admin()
);

create policy "only admins access settlement accounts" on public.settlement_accounts
for all using (public.is_admin()) with check (public.is_admin());

-- Important production controls:
-- 1. Create the first admin profile only through a trusted, private server process.
-- 2. Do not allow users to update their own role; enforce role changes server-side.
-- 3. Validate appointment availability and calculate all prices/deposits server-side.
-- 4. Verify payment-provider webhook signatures before changing booking status.
-- 5. Use a dedicated KMS/secret manager for encryption keys; never put keys in this repo.
