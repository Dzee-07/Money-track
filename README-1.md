# Passbook

A simple personal income/expense/savings tracker. One file, `index.html` —
no build step, just host it or open it.

## Files
- `index.html` — the app
- `supabase-schema.sql` — run this in Supabase before connecting real keys
- `README.md` — this file

## How it works

- **First open**: welcome slides, then you land straight on the Home screen
  as a **guest** — no sign-up required to start using it.
- **Guest mode**: entries are saved in the browser's local storage on that
  one device, and stay there for good (until you clear browser data) — no
  account needed. This is the default and never requires login.
- **Currency**: right after the welcome slides, the app guesses your
  currency (from your device's region, timezone, or IP) and asks you to
  confirm it. Once confirmed, it's locked in for good — it won't re-ask or
  change on its own, even while traveling or on a VPN. Change it anytime
  from **Profile → Change currency**.
- **Signing in**: tap **Profile → Login** anytime to sign up or log in
  (email/password, or Google/Facebook once you enable those providers in
  Supabase). Signing in moves your data to the cloud so it follows you
  across devices, and syncs your chosen currency too. Whatever you'd
  already entered as a guest on that device is copied into your new account
  automatically the first time you log in.
- **Sync nudge**: guests get a one-time popup after confirming their
  currency suggesting they sign in to sync — dismissible with "Not now",
  and it won't nag again.
- **Logging out**: Profile → Logout, confirm, and you're back to guest mode
  on that device. Nothing is deleted — logging back in brings your cloud
  data right back.

## Setup (10 minutes)

1. **Create a Supabase project** at [supabase.com](https://supabase.com).
2. **Run `supabase-schema.sql`** in the SQL Editor (Dashboard → SQL Editor →
   New query → paste → Run). This sets up per-user rows with Row Level
   Security, plus a `user_settings` table for synced currency.
3. **Check email auth is on.** Authentication → Providers → Email is
   enabled by default.
4. **Optional: turn off "Confirm email"** under Authentication → Settings,
   if you want people to be able to use the app immediately after signing
   up instead of needing to click a confirmation link first.
5. **Optional: enable Google / Facebook sign-in** under Authentication →
   Providers, if you want those buttons on the login screen to work (they
   are already wired up in the code — they just need credentials from
   Google Cloud Console / Meta for Developers plugged into Supabase).
6. **Get your API keys** from Project Settings → API, and paste the
   **Project URL** and **anon public** key into `index.html`, near the top
   of the `<script>` block.
7. Host `index.html` (Netlify, Vercel, GitHub Pages) or just open it
   directly — guest mode works with zero setup, Supabase is only needed
   for the login/sync features.

Categories, the Add sheet, History, and Stats all work the same regardless
of guest or signed-in mode.
