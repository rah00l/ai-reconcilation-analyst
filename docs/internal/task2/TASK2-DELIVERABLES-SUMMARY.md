# Task 2 Deliverables — Complete Package

## 📦 What's In The Box

You have **everything needed** to build a 5-screen payment reconciliation portfolio app with 70 realistic transactions.

---

## 📋 Complete File List

### Code Files (12 files, ready to copy-paste)

```
1. db/migrate/20260510000001_create_payment_files.rb
   └─ Creates payment_files table (8 columns, 3 indexes)

2. db/migrate/20260510000002_create_transactions.rb
   └─ Creates transactions table (13 columns, 4 indexes)

3. app/models/payment_file.rb
   └─ Model with 2 enums, validations, 5 scopes, 5 helper methods

4. app/models/transaction.rb
   └─ Model with 2 enums, validations, 4 scopes, 3 helper methods

5. app/controllers/payment_files_controller.rb
   └─ 5 actions (index, display, errors, tenancy, summary)

6. config/routes.rb
   └─ Resource routes with 4 member routes

7. app/views/payment_files/index.html.erb (Screen 1)
   └─ 160 lines, 5 payment files, filter dropdowns, upload form

8. app/views/payment_files/display.html.erb (Screen 2)
   └─ 155 lines, 30 merchant transactions, navigation, totals

9. app/views/payment_files/errors.html.erb (Screen 3)
   └─ 140 lines, 8 error rows, red highlighting, status badges

10. app/views/payment_files/tenancy.html.erb (Screen 4)
    └─ 175 lines, settlement form, calculations, buttons

11. app/views/payment_files/summary.html.erb (Screen 5)
    └─ 190 lines, reconciled data, unmatched data, locked status

12. db/seeds.rb
    └─ 250 lines, 5 payment files, 70 transactions with realistic data
```

### Documentation Files (4 files, reference materials)

```
13. TASK2-IMPLEMENTATION-GUIDE.md
    └─ 14-step walkthrough with expected outputs

14. TASK2-FILE-MANIFEST.md
    └─ Complete file reference guide

15. TASK2-COMPLETE-SUMMARY.md
    └─ Context and design decisions explained

16. TASK2-QUICK-REFERENCE.md
    └─ Quick lookup card for commands and troubleshooting
```

---

## 📊 Data Package

### Payment Files (5)
```
CJ-UK_2026_02_18_19711.69.xlsx
├─ Region: UK
├─ Affiliate: Commission Junction - UK
├─ Amount: £19,711.69
├─ Status: PARSED
└─ Transactions: 30 (clean, no errors)

Linkshare-UK_2026_03_11_7109.04.xml
├─ Region: UK
├─ Affiliate: Linkshare - UK
├─ Amount: £7,109.04
├─ Status: PARSED (with errors)
└─ Transactions: 38 + 8 errors

CJ-CA_2026_03_16_283.45.xlsx
├─ Region: CA
├─ Affiliate: Commission Junction - CA
├─ Amount: $283.45
├─ Status: FULL_RECONCILED
└─ Transactions: 7 (all locked)

Fresh_Upload_2026_03_20_5432.10.csv
├─ Region: UK
├─ Affiliate: Awin - UK
├─ Amount: £5,432.10
├─ Status: READY
└─ Transactions: 0 (not yet processed)

In_Progress_2026_03_22.xlsx
├─ Region: CA
├─ Affiliate: Linkshare - CA
├─ Amount: $3,210.50
├─ Status: PROCESSING
└─ Transactions: 0 (in progress)
```

### Merchants (30+)
```
UK: Ancestry UK, ASOS, Aveda, Bonmarche, Buyagift, Cabin Zero,
    Childsplay Clothing, Cutter and Squidge, e.l.f. Cosmetics,
    Estee Lauder, Face the Future, Gatwick Holiday Parking, H&M,
    Laithwaites, Mainline, Office Shoes, Oliver Bonas, Red Letter
    Days, Samsung, Temple Spa, The Perfume Shop, Threadbare, Tory
    Burch, Urban Outfitters, Weekday

CA: 123Ink.ca, ASDA Groceries, ASOS Groceries, Bose, BrandAlley,
    Columbia Sportswear Canada, Dell Refurbished, Direct Ferries,
    DinersGlobe, Emirates, Expedia Canada, Fernell, Footshop,
    George at ASDA, Hotels.com, Sony, Temu Canada
```

### Transactions (70 total)
```
✓ 62 clean transactions (display normally)
✓ 8 error transactions (highlighted red on Screen 3)
✓ Commission breakdown for each (initial, final, partner, internal)
✓ Realistic amounts (£0.25 to £93,422.36)
✓ Multiple transaction types (sales, commission, declined, bonus)
✓ 7 locked transactions (on Screen 5 only)
```

---

## 🎨 5 Screens You'll Have

### Screen 1: Upload List (index)
```
┌─────────────────────────────────────────┐
│ Payment Reconciliation                  │
├─────────────────────────────────────────┤
│ Filters: [Region ▼] [Affiliate ▼]       │
│                                         │
│ Upload New Payment File                 │
│ [Date] [Amount] [ID] [File] [Upload]   │
│                                         │
│ Payment Reconciliation Status List      │
│ ┌──────────────────────────────────────┐│
│ │ Region │ Affiliate │ Date │ ... │    ││
│ ├──────────────────────────────────────┤│
│ │ UK │ CJ-UK │ 2026-02-18 │ ... [Display] ││
│ │ UK │ Linkshare │ 2026-03-11 │ ... [Errors] ││
│ │ CA │ CJ-CA │ 2026-03-16 │ ... [Display] ││
│ │ UK │ Awin │ 2026-03-20 │ ... [▼] ││
│ │ CA │ Linkshare │ 2026-03-22 │ ... [▼] ││
│ └──────────────────────────────────────┘│
└─────────────────────────────────────────┘
```

### Screen 2: Display (parsed breakdown)
```
┌─────────────────────────────────────────┐
│ CJ-UK_2026_02_18_19711.69.xlsx          │
├─────────────────────────────────────────┤
│ [Display] [Errors] [Tenancy] [Summary]  │
│                                         │
│ ┌──────────────────────────────────────┐│
│ │ MID │ Merchant │ Paid Sales │ Paid   ││
│ │     │          │ Commission │ ...    ││
│ ├──────────────────────────────────────┤│
│ │ 35838 │ Ancestry UK │ 269.66 │ 26.97 ││
│ │ 8980 │ ASOS │ 3794.51 │ 659.56 ││
│ │ ... │ ... │ ... │ ... ││
│ └──────────────────────────────────────┘│
│ Tenancy Fee: 1500.00 │ Deposit: 19711.69 │
│ [Download Parsed] [Remove Parse]        │
└─────────────────────────────────────────┘
```

### Screen 3: Errors (highlighted)
```
┌─────────────────────────────────────────┐
│ Linkshare-UK_2026_03_11_7109.04.xml    │
│ Status: [Missing (8 errors)]            │
├─────────────────────────────────────────┤
│ [Display] [Errors] [Tenancy] [Summary]  │
│                                         │
│ ┌──────────────────────────────────────┐│
│ │ MID │ Merchant │ Paid Commission     ││
│ ├──────────────────────────────────────┤│
│ │ 30745 │ Karcher │ [2.93] (RED)  ││
│ │ 34601 │ Lands' End UK │ [9.29] (RED) ││
│ │ 26004 │ RS Components │ [6.75] (RED) ││
│ │ ... │ ... │ [x.xx] (RED) ││
│ └──────────────────────────────────────┘│
│ 8 transaction(s) with errors detected   │
└─────────────────────────────────────────┘
```

### Screen 4: Tenancy Settlement
```
┌─────────────────────────────────────────┐
│ Tenancy Settlement                      │
├─────────────────────────────────────────┤
│ ┌──────────────────────────────────────┐│
│ │ Affiliate │ Merchant │ Tenancy Tranx ││
│ │ Campaign │ Paid Amount │ Type       ││
│ ├──────────────────────────────────────┤│
│ │ CJ-UK │ George @ ASDA │ WL37017... ││
│ │ George at ASDA-... │ 1500.00 │ Tenancy ││
│ └──────────────────────────────────────┘│
│ [ADD MORE ITEM]                         │
│                                         │
│ Tenancy Fee: 1500.00                    │
│ Bonus: -0.03                            │
│ Error: 106.07                           │
│ Total: 1606.04                          │
│ [SAVE] [DOWNLOAD] [TRAN] [FULL]        │
└─────────────────────────────────────────┘
```

### Screen 5: Final Summary
```
┌─────────────────────────────────────────┐
│ Reconciled Data Summary                 │
├─────────────────────────────────────────┤
│ ┌──────────────────────────────────────┐│
│ │ MID │ Merchant │ Type │ Commission ││
│ │     │ Commission Layout             ││
│ ├──────────────────────────────────────┤│
│ │ 25463 │ 123Ink.ca │ 6.11 │ ✓Locked ││
│ │ 28278 │ Columbia │ 58.00 │ ✓Locked ││
│ │ Total │ │ 283.45 │ 6 ││
│ └──────────────────────────────────────┘│
│ [DOWNLOAD SUMMARY] [DOWNLOAD TRANS]     │
│                                         │
│ Unmatched Data Summary                  │
│ No unmatched items - All reconciled ✓   │
└─────────────────────────────────────────┘
```

---

## 🔧 Tech Stack

```
Framework:    Rails 7.1
Language:     Ruby 3.2
Database:     SQLite (dev), migrations ready for PostgreSQL
Styling:      Tailwind CSS
JavaScript:   None (yet - Task 3 adds Stimulus)
Views:        ERB templates
Models:       2 (PaymentFile, Transaction)
Controller:   1 (PaymentFilesController)
Routes:       RESTful resources
```

---

## ✅ Implementation Checklist

```
SETUP (5 min)
  ☐ Create seed-data branch
  ☐ Copy migration files (2)
  ☐ Copy model files (2)
  ☐ Copy controller file (1)
  ☐ Update routes.rb (1)

VIEWS (5 min)
  ☐ Create app/views/payment_files/ directory
  ☐ Copy 5 view files

SEEDS (2 min)
  ☐ Replace db/seeds.rb

DATABASE (3 min)
  ☐ Run rails db:migrate
  ☐ Run rails db:seed

TEST (10 min)
  ☐ Start rails server
  ☐ Visit http://localhost:3000
  ☐ Test Screen 1 (file list)
  ☐ Test Screen 2 (display)
  ☐ Test Screen 3 (errors)
  ☐ Test Screen 4 (tenancy)
  ☐ Test Screen 5 (summary)
  ☐ Test all navigation

GIT (5 min)
  ☐ git add .
  ☐ git commit -m "feat(seeds): ..."
  ☐ git checkout main
  ☐ git merge seed-data
  ☐ git tag v0.2.0-data
  ☐ git push origin main --tags

TOTAL TIME: ~30 minutes
```

---

## 📈 Project Status After Task 2

```
TASK 1: ✅ COMPLETE (v0.1.0-scaffold)
└─ Rails 7.1 scaffold
└─ Hotwire + Tailwind ready
└─ Docker configured

TASK 2: ✅ THIS TASK (v0.2.0-data)
└─ 2 models created
└─ 5 screens built
└─ 70 transactions seeded
└─ Read-only UI ready

TASK 3: 🔜 NEXT (Chat widget)
└─ Stimulus controller
└─ Turbo Streams
└─ Chat UI

TASK 4: 🔜 Engine integration
└─ HTTP client
└─ API calls

TASK 5: 🔜 AI assistant
└─ Real explanations
└─ Context-aware responses

TASK 6: 🔜 Full demo
└─ All screens with chat

TASK 7: 🔜 Deploy
└─ Render.com
└─ Live portfolio
```

---

## 🎯 What Hiring Managers Will See

```
✓ Beautiful, professional UI (Tailwind)
✓ Real-world use case (payment reconciliation)
✓ Clean code (enums, scopes, validations)
✓ Substantial data (70 transactions, 30+ merchants)
✓ Error handling (8 error scenarios)
✓ Navigation (5 interconnected screens)
✓ Business logic (commission breakdown, settlement)
✓ Plus: AI assistant (Task 5+) explaining it all

👉 This is a REAL portfolio piece
```

---

## 🚀 Ready to Build?

You have everything. No missing pieces. No guesswork.

**Your next 30 minutes:**

1. Copy files from `/mnt/user-data/outputs/`
2. Follow `TASK2-QUICK-REFERENCE.md`
3. Run migrations & seeds
4. Test all 5 screens
5. Commit & tag

**Then move to Task 3: Chat widget** ✓

---

## Questions?

- **Where are the files?** `/mnt/user-data/outputs/` — Copy to your repo
- **How to implement?** `TASK2-IMPLEMENTATION-GUIDE.md` — Step by step
- **Quick lookup?** `TASK2-QUICK-REFERENCE.md` — Commands & troubleshooting
- **More context?** `TASK2-COMPLETE-SUMMARY.md` — Design decisions & reasoning

---

## Let's Build This

You're 30 minutes away from a stunning 5-screen payment reconciliation app.

**Go. Build. Ship. 🚀**
