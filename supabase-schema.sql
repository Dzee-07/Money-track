-- Run this once in your Supabase project's SQL Editor
-- (Dashboard → SQL Editor → New query → paste → Run)

create extension if not exists pgcrypto;

create table if not exists transactions (
  id uuid primary key default gen_random_uuid(),
  type text not null check (type in ('income', 'expense')),
  category text not null,
  note text,
  amount numeric(12,2) not null check (amount > 0),
  occurred_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create index if not exists transactions_occurred_at_idx
  on transactions (occurred_at desc);

alter table transactions enable row level security;

-- Simple single-user setup: the anon key can read/write everything.
-- This is fine for a personal tracker as long as your anon key + URL
-- stay private (don't publish the site publicly with them exposed).
--
-- If you ever add Supabase Auth for multiple users, instead add a
-- user_id uuid references auth.users column, and replace the policy
-- below with one scoped to auth.uid() = user_id.
create policy "anon full access"
  on transactions
  for all
  to anon
  using (true)
  with check (true);
