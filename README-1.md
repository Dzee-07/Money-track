# Passbook — savings & expense tracker

A mobile-first single-page app for logging income/savings and expenses, backed by Supabase. No build step — it's one `index.html` file plus your database.

## Files
- `index.html` — the app (open it directly, or host it anywhere static)
- `supabase-schema.sql` — the database table + security policy to run once
- `README.md` — this file

## Setup (5 minutes)

1. **Create a Supabase project** at [supabase.com](https://supabase.com) (free tier is fine).
2. **Run the schema.** In your project, go to **SQL Editor → New query**, paste in the contents of `supabase-schema.sql`, and click **Run**. This creates the `transactions` table.
3. **Get your API keys.** Go to **Project Settings → API**. Copy the **Project URL** and the **anon public** key.
4. **Paste them into `index.html`.** Near the top of the `<script>` block you'll see:
   ```js
   const SUPABASE_URL = 'YOUR_SUPABASE_URL';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
   ```
   Replace both with your real values.
5. **Open `index.html`** in a browser (double-click it, or host it on Netlify/Vercel/GitHub Pages/any static host). On a phone, "Add to Home Screen" makes it feel like an app.

Until you fill in real credentials, the app shows a setup screen instead of trying to load fake data.

## How it works

- **Add tab** — choose Income/Savings or Expense, pick a category, optionally add a note, enter an amount, and set the date/time (defaults to now). It's saved straight to your Supabase table, and your balance updates immediately.
- **Home tab** — shows your all-time balance (a running total of income minus expenses — not connected to any real bank account, just a number the app tracks), today's totals, and your most recent entries.
- **History tab** — flip between Day / Week / Month / Year views, step backward and forward through time with the arrows, and see totals plus every entry for that period.
- **Stats tab** — for the selected period, see spending and income broken down by category as bars, so you can spot where the money's actually going.
- Tap the **×** next to any entry to delete it.

## Notes & things you might want to change

- **Currency symbol**: it's `$` by default — change the `SYMBOL` constant near the top of the script.
- **Categories**: edit the `EXPENSE_CATS` and `INCOME_CATS` arrays to match how you actually spend.
- **Single user, no login**: the schema uses a simple "anon key can do anything" policy, which is fine for a personal tracker as long as you don't publish your Supabase keys somewhere public. If you want multiple people to use it with separate balances, add Supabase Auth and a `user_id` column — the schema file has a comment on where to start.
- **Week start**: weeks start on Monday; change `startOfWeek()` in the script if you'd rather start on Sunday.
