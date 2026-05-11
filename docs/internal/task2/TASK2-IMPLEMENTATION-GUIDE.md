# Task 2 (v0.2.0-data) — Implementation Guide

## Overview

You now have all the files needed to implement Task 2. This guide walks you through the exact steps to add models, migrations, seeds, controllers, and views to your Rails app.

---

## Step 1: Create Feature Branch

```bash
git checkout -b seed-data
```

---

## Step 2: Generate Models

```bash
# Generate PaymentFile model
rails generate model PaymentFile \
  filename:string \
  region:string \
  affiliate_network:string \
  deposit_date:date \
  deposit_amount:decimal \
  payment_id:string \
  status:string \
  file_status_label:string

# Generate Transaction model (with foreign key to PaymentFile)
rails generate model Transaction \
  payment_file:references \
  mid:integer \
  merchant_name:string \
  transaction_type:string \
  amount:decimal \
  error_flag:boolean \
  error_reason:string \
  screen_type:string \
  commission_initial:decimal \
  commission_final:decimal \
  tenancy_tranx:string \
  campaign_amount:decimal \
  transaction_locked:boolean
```

---

## Step 3: Update Migration Files

### File 1: `db/migrate/[timestamp]_create_payment_files.rb`

Copy the content from the migration file provided and replace the auto-generated one.

### File 2: `db/migrate/[timestamp]_create_transactions.rb`

Copy the content from the migration file provided and replace the auto-generated one.

---

## Step 4: Update Model Files

### File 1: `app/models/payment_file.rb`

Replace the entire file with the content provided (payment_file.rb).

Key includes:
- Enums for status and region
- Validations
- Scopes for filtering
- Constants for dropdown options
- Helper methods

### File 2: `app/models/transaction.rb`

Replace the entire file with the content provided (transaction.rb).

Key includes:
- Enums for transaction_type and screen_type
- Validations
- Scopes
- Constants for display names
- Helper methods

---

## Step 5: Update Routes

Replace your `config/routes.rb` with the content provided:

Key routes:
```ruby
root "payment_files#index"

resources :payment_files, only: [:index, :show] do
  member do
    get :display
    get :errors
    get :tenancy
    get :summary
  end
end
```

---

## Step 6: Create Controller

Create `app/controllers/payment_files_controller.rb` with content provided:

Key actions:
- `index` — Screen 1: Upload list
- `display` — Screen 2: Parsed breakdown
- `errors` — Screen 3: Missing/errors
- `tenancy` — Screen 4: Tenancy settlement
- `summary` — Screen 5: Final summary

---

## Step 7: Create Views

Create the following view files in `app/views/payment_files/`:

1. `index.html.erb` — Screen 1 (from index_view.html.erb)
2. `display.html.erb` — Screen 2 (from display_view.html.erb)
3. `errors.html.erb` — Screen 3 (from errors_view.html.erb)
4. `tenancy.html.erb` — Screen 4 (from tenancy_view.html.erb)
5. `summary.html.erb` — Screen 5 (from summary_view.html.erb)

---

## Step 8: Update Seeds

Replace your `db/seeds.rb` with the content provided (seeds.rb).

This creates:
- 5 payment files (various statuses)
- ~70 transactions with realistic data
- 8 error transactions (highlighted in red on Screen 3)
- Locked transactions (for Screen 5)

---

## Step 9: Run Migrations

```bash
rails db:migrate
```

Expected output:
```
== [timestamp] CreatePaymentFiles: migrating ============================
-- create_table(:payment_files)
   -> 0.0234s
== [timestamp] CreatePaymentFiles: migrated (0.0240s) ====================

== [timestamp] CreateTransactions: migrating ============================
-- create_table(:transactions)
   -> 0.0312s
== [timestamp] CreateTransactions: migrated (0.0351s) ====================
```

---

## Step 10: Seed Database

```bash
rails db:seed
```

Expected output:
```
✓ Created 5 payment files
✓ Created 70 transactions

Files created:
  - CJ-UK_2026_02_18_19711.69.xlsx (parsed) - 30 transactions
  - Linkshare-UK_2026_03_11_7109.04.xml (parsed) - 38 transactions
  - CJ-CA_2026_03_16_283.45.xlsx (full_reconciled) - 7 transactions
  - Fresh_Upload_2026_03_20_5432.10.csv (ready) - 0 transactions
  - In_Progress_2026_03_22.xlsx (processing) - 0 transactions
```

---

## Step 11: Test the App

```bash
rails server
```

Visit: `http://localhost:3000`

You should see:
- ✓ Screen 1: List of 5 payment files
- ✓ Click "Display" → Screen 2: Merchant breakdown
- ✓ Click "Errors" → Screen 3: Red-highlighted errors
- ✓ Click "Tenancy" → Screen 4: Settlement form
- ✓ Click "Summary" → Screen 5: Final reconciliation

---

## Step 12: Verify All 5 Screens Work

### Screen 1: Upload List
- Shows 5 payment files
- Status badges: PARSED (green), READY (yellow), PROCESSING (gray)
- Click "Display" button → goes to Screen 2

### Screen 2: Display
- Shows file header with filename, amount
- Shows 30 transactions in table
- Commission columns: Paid Sales, Paid Commission, etc.
- Bottom summary: Tenancy Fee, Bonus, Deposit total
- Links to Screen 3 (Errors), 4 (Tenancy), 5 (Summary)

### Screen 3: Errors
- Shows only 8 error transactions
- Highlighted in red
- Status badge: "Missing"
- Shows error count

### Screen 4: Tenancy
- Shows settlement form
- One sample tenancy entry (George at ASDA)
- Summary calculations: Tenancy Fee (1500), Bonus, VAT, Error, Total

### Screen 5: Summary
- Shows locked transactions
- "Reconciled Data Summary" table with locked status ✓
- "Unmatched Data Summary" (empty, all matched)
- Download buttons

---

## Step 13: Commit Your Work

```bash
git add .
git commit -m "feat(seeds): add payment file and transaction models with 70+ seed records

Models:
- PaymentFile: 5 files with various statuses (new, ready, processing, parsed, full_reconciled)
- Transaction: 70 transactions with realistic reconciliation data

Features:
- Screen 1: File upload list with filtering
- Screen 2: Parsed file breakdown with merchant data
- Screen 3: Error highlighting (8 discrepancies in red)
- Screen 4: Tenancy settlement form with calculations
- Screen 5: Final summary with locked transactions

Seeds include realistic merchants (UK/CA), amounts, and error scenarios."
```

---

## Step 14: Tag & Push

```bash
git tag v0.2.0-data
git push origin seed-data --set-upstream
git checkout main
git merge seed-data
git tag v0.2.0-data
git push origin main --tags
```

---

## File Checklist

- [ ] `db/migrate/[timestamp]_create_payment_files.rb` — Created
- [ ] `db/migrate/[timestamp]_create_transactions.rb` — Created
- [ ] `app/models/payment_file.rb` — Updated with enums
- [ ] `app/models/transaction.rb` — Updated with enums
- [ ] `app/controllers/payment_files_controller.rb` — Created
- [ ] `config/routes.rb` — Updated with resource routes
- [ ] `app/views/payment_files/index.html.erb` — Screen 1 created
- [ ] `app/views/payment_files/display.html.erb` — Screen 2 created
- [ ] `app/views/payment_files/errors.html.erb` — Screen 3 created
- [ ] `app/views/payment_files/tenancy.html.erb` — Screen 4 created
- [ ] `app/views/payment_files/summary.html.erb` — Screen 5 created
- [ ] `db/seeds.rb` — Updated with 5 files + 70 transactions
- [ ] `rails db:migrate` — Run migrations
- [ ] `rails db:seed` — Populate database
- [ ] `rails server` — Test locally
- [ ] `git commit` — Commit changes
- [ ] `git tag v0.2.0-data` — Tag milestone

---

## Expected Result

After completing all steps:

✓ Rails app running with full payment reconciliation UI
✓ 5 screens fully functional (read-only, no edits)
✓ 5 payment files with realistic data
✓ 70 transactions showing across screens
✓ 8 error transactions highlighted
✓ All navigation working (Screen 1 → 2 → 3 → 4 → 5)
✓ Ready for Task 3 (add chat widget)
✓ Ready for Task 5 (integrate AI engine)

---

## Troubleshooting

### Migration Error: "Column type 'string' doesn't exist"

Run migrations again:
```bash
rails db:drop
rails db:create
rails db:migrate
rails db:seed
```

### Seeds not running

```bash
rails db:seed RAILS_ENV=development
```

### Stylesheet/JS issues

Add to `app/views/layouts/application.html.erb`:
```erb
<link rel="stylesheet" href="https://cdn.tailwindcss.com">
```

### Routes not found

Restart server:
```bash
# Kill server (Ctrl+C)
rails server
```

---

## Next Steps (Task 3)

After Task 2 is complete and merged to main:

1. Create `chat-integration` branch
2. Add Stimulus controller for chat widget
3. Add Turbo Streams for real-time responses
4. Integrate AI engine (POST to /analyze)
5. Display engine responses in chat bubbles

See you in Task 3! ✓
