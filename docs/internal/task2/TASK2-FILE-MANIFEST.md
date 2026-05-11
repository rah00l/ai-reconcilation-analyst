# Task 2 Complete File Manifest

## All Files Provided (Copy & Paste Ready)

Here are all the files you need for Task 2, organized by type:

---

## 1. DATABASE MIGRATIONS (2 files)

### File 1: `db/migrate/[timestamp]_create_payment_files.rb`
**Source:** `20260510000001_create_payment_files.rb`
- Creates `payment_files` table
- Columns: filename, region, affiliate_network, deposit_date, deposit_amount, payment_id, status, file_status_label
- Indexes on status, region, affiliate_network

### File 2: `db/migrate/[timestamp]_create_transactions.rb`
**Source:** `20260510000002_create_transactions.rb`
- Creates `transactions` table
- Columns: payment_file_id (FK), mid, merchant_name, transaction_type, amount, error_flag, error_reason, screen_type, commission_initial, commission_final, tenancy_tranx, campaign_amount, transaction_locked
- Indexes on payment_file_id, error_flag, screen_type, mid

---

## 2. MODELS (2 files)

### File 1: `app/models/payment_file.rb`
**Source:** `payment_file.rb`
- Enums: status (new, ready, processing, parsed, partial_reconciled, full_reconciled), region (uk, ca, us)
- Validations for filename, deposit_amount, payment_id
- Scopes: by_region, by_affiliate, parsed, with_errors
- Constants: AFFILIATE_NETWORKS, REGIONS_DISPLAY
- Helper methods: region_display, status_display, has_errors?, error_count, transaction_count

### File 2: `app/models/transaction.rb`
**Source:** `transaction.rb`
- Enums: transaction_type (11 types), screen_type (display, missing, tenancy, summary)
- Validations for mid, merchant_name, amount
- Scopes: with_errors, for_screen, locked, by_type
- Constants: TRANSACTION_TYPE_DISPLAY, ERROR_REASONS
- Helper methods: type_display, error_display, has_error?, total_commission

---

## 3. CONTROLLER (1 file)

### File: `app/controllers/payment_files_controller.rb`
**Source:** `payment_files_controller.rb`
- Actions:
  - `index` — Screen 1: List of payment files
  - `display` — Screen 2: Parsed breakdown
  - `errors` — Screen 3: Error transactions
  - `tenancy` — Screen 4: Tenancy settlement
  - `summary` — Screen 5: Final summary
- Before action: set_payment_file for all member actions
- Helper method: calculate_unmatched_totals (hardcoded values)

---

## 4. ROUTES (1 file)

### File: `config/routes.rb`
**Source:** `routes.rb`
- Root route: payment_files#index
- Resources: :payment_files with custom member routes (display, errors, tenancy, summary)

---

## 5. VIEWS (5 files)

### Screen 1: `app/views/payment_files/index.html.erb`
**Source:** `index_view.html.erb`
- Payment file upload list (read-only form)
- Region and affiliate network filters (static dropdowns)
- Table: 5 payment files with status badges
- Action buttons: Display, Errors links
- Chat widget indicator

### Screen 2: `app/views/payment_files/display.html.erb`
**Source:** `display_view.html.erb`
- File header with filename, date, amount
- Navigation: Display (active), Errors, Tenancy, Summary buttons
- Transaction table: MID, Merchant, Paid Sales, Paid Commission, etc.
- Summary: Tenancy Fee, Bonus, Deposit total
- Download buttons (non-functional)
- Chat widget indicator

### Screen 3: `app/views/payment_files/errors.html.erb`
**Source:** `errors_view.html.erb`
- File header with "Missing" status badge and error count
- Navigation buttons (same as Screen 2)
- Transaction table with RED highlighted error amounts
- Error summary section
- Download buttons
- Chat widget indicator (red theme)

### Screen 4: `app/views/payment_files/tenancy.html.erb`
**Source:** `tenancy_view.html.erb`
- File header
- Navigation buttons
- Tenancy settlement form with table:
  - Affiliate Network, Merchant, Tenancy Tranx, Mapped Campaign
  - Campaign Amount, Paid Amount, Tenancy Type, Agg Tranx ID
  - ADD MORE ITEM button
- Summary calculations: Tenancy Fee, Bonus, VAT, Unmatched Error, Total
- Action buttons: SAVE, DOWNLOAD, TRAN RECONCILE, FULL RECONCILE
- Chat widget indicator

### Screen 5: `app/views/payment_files/summary.html.erb`
**Source:** `summary_view.html.erb`
- File header with status
- Navigation buttons (Summary active)
- Reconciled Data Summary table:
  - MID, Merchant, Transaction Type, Commission columns
  - Total row (bold) with locked transaction status
  - Download buttons
- Unmatched Data Summary (empty):
  - Shows "No unmatched items"
  - Total row: 0.00
  - Download buttons
- Chat widget indicator

---

## 6. SEEDS (1 file)

### File: `db/seeds.rb`
**Source:** `seeds.rb`
- Destroys all existing PaymentFile and Transaction records
- Creates 5 payment files:
  1. CJ-UK (PARSED, 30 clean transactions)
  2. Linkshare-UK (PARSED with errors, 38 transactions + 8 errors)
  3. CJ-CA (FULL_RECONCILED, 7 locked transactions)
  4. Fresh Upload (READY, 0 transactions)
  5. In Progress (PROCESSING, 0 transactions)
- Total: 70 transactions, 8 with error_flag: true
- Realistic merchant names from UK/CA retailers
- Decimal amounts (0.25 to 93422.36)
- Commission breakdown for each transaction

---

## 7. DOCUMENTATION (1 file)

### File: `TASK2-IMPLEMENTATION-GUIDE.md`
**Source:** `TASK2-IMPLEMENTATION-GUIDE.md`
- Step-by-step implementation instructions
- 14 numbered steps from branch creation to tagging
- File checklist
- Troubleshooting guide
- Expected output at each step

---

## Implementation Sequence

### 1. Copy Migration Files
```bash
# Copy the two migration files to:
# - db/migrate/[timestamp]_create_payment_files.rb
# - db/migrate/[timestamp]_create_transactions.rb
```

### 2. Copy Model Files
```bash
# Copy to:
# - app/models/payment_file.rb
# - app/models/transaction.rb
```

### 3. Copy Controller
```bash
# Copy to:
# - app/controllers/payment_files_controller.rb
```

### 4. Update Routes
```bash
# Replace:
# - config/routes.rb
```

### 5. Copy Views
```bash
# Create directory: app/views/payment_files/
# Copy 5 view files:
# - index.html.erb
# - display.html.erb
# - errors.html.erb
# - tenancy.html.erb
# - summary.html.erb
```

### 6. Update Seeds
```bash
# Replace:
# - db/seeds.rb
```

### 7. Run Migrations & Seeds
```bash
rails db:migrate
rails db:seed
```

### 8. Test
```bash
rails server
# Visit http://localhost:3000
```

---

## Total Lines of Code

- Migrations: ~50 lines
- Models: ~80 lines
- Controller: ~35 lines
- Routes: ~12 lines
- Views: ~800 lines (5 screens × ~160 lines each)
- Seeds: ~250 lines
- **Total: ~1227 lines**

Time to implement: **1-2 hours** (copy, paste, run migrations, test)

---

## All Files At a Glance

| File | Type | Lines | Purpose |
|------|------|-------|---------|
| 20260510000001_create_payment_files.rb | Migration | 22 | Create payment_files table |
| 20260510000002_create_transactions.rb | Migration | 28 | Create transactions table |
| payment_file.rb | Model | 55 | PaymentFile with enums & scopes |
| transaction.rb | Model | 65 | Transaction with enums & scopes |
| payment_files_controller.rb | Controller | 35 | 5 screen actions |
| routes.rb | Routes | 12 | Resource routes |
| index.html.erb | View | 160 | Screen 1: Upload list |
| display.html.erb | View | 155 | Screen 2: Parsed breakdown |
| errors.html.erb | View | 140 | Screen 3: Error highlighting |
| tenancy.html.erb | View | 175 | Screen 4: Tenancy settlement |
| summary.html.erb | View | 190 | Screen 5: Final summary |
| seeds.rb | Seeds | 250 | 5 files, 70 transactions |
| TASK2-IMPLEMENTATION-GUIDE.md | Docs | 350 | Step-by-step guide |

---

## Ready to Begin?

You have everything. Now follow the 14-step guide in TASK2-IMPLEMENTATION-GUIDE.md to implement Task 2.

After completion:
- ✓ All 5 screens working
- ✓ 70 realistic transactions
- ✓ 8 error scenarios
- ✓ Read-only UI (perfect for demo)
- ✓ Ready for Task 3 (chat widget)

**Proceed with implementation!** ✓
