-- Schema for index-accounts.html (the guest / sign-up-and-login version).
-- Run this once in your Supabase project's SQL Editor
-- (Dashboard → SQL Editor → New query → paste → Run)
--
-- Difference from the plain supabase-schema.sql: each row belongs to a
-- signed-in user (user_id), and Row Level Security only lets people see
-- and edit their own rows. Guests never touch this table at all — their
-- entries live only in the browser's local storage until they sign up.

create extension if not exists pgcrypto;

create table if not exists transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  type text not null check (type in ('income', 'expense')),
  category text not null,
  note text,
  amount numeric(12,2) not null check (amount > 0),
  occurred_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create index if not exists transactions_user_occurred_idx
  on transactions (user_id, occurred_at desc);

alter table transactions enable row level security;

-- Signed-in users can only ever see/change/delete their own rows.
create policy "select own rows"
  on transactions for select
  to authenticated
  using (auth.uid() = user_id);

create policy "insert own rows"
  on transactions for insert
  to authenticated
  with check (auth.uid() = user_id);

create policy "update own rows"
  on transactions for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "delete own rows"
  on transactions for delete
  to authenticated
  using (auth.uid() = user_id);

-- Per-user settings (currently just the chosen currency). One row per
-- signed-in user; guests never touch this table — their currency choice
-- lives only in that browser's local storage until they sign up.
create table if not exists user_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  currency_code text,
  currency_symbol text,
  currency_name text,
  updated_at timestamptz not null default now()
);

alter table user_settings enable row level security;

create policy "select own settings"
  on user_settings for select
  to authenticated
  using (auth.uid() = user_id);

create policy "insert own settings"
  on user_settings for insert
  to authenticated
  with check (auth.uid() = user_id);

create policy "update own settings"
  on user_settings for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- One-time setup notes:
-- 1. In your Supabase project, go to Authentication → Providers and make
--    sure "Email" is enabled (it is by default).
-- 2. Authentication → Settings → if you'd rather people be able to use the
--    app immediately after signing up (no "confirm your email" step),
--    turn OFF "Confirm email". If you leave it ON, new sign-ups will need
--    to click the confirmation link Supabase emails them before they can
--    log in — the app already shows a message telling them to do that.
