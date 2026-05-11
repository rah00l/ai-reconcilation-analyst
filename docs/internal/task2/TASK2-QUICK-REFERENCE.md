# Task 2 Quick Reference Card

## Files You Have (16 Total)

### Migrations (2)
- `20260510000001_create_payment_files.rb`
- `20260510000002_create_transactions.rb`

### Models (2)
- `payment_file.rb`
- `transaction.rb`

### Controller (1)
- `payment_files_controller.rb`

### Routes (1)
- `routes.rb`

### Views (5)
- `index.html.erb` (Screen 1)
- `display.html.erb` (Screen 2)
- `errors.html.erb` (Screen 3)
- `tenancy.html.erb` (Screen 4)
- `summary.html.erb` (Screen 5)

### Seeds (1)
- `seeds.rb` (5 files, 70 transactions)

### Docs (3)
- `TASK2-IMPLEMENTATION-GUIDE.md`
- `TASK2-FILE-MANIFEST.md`
- `TASK2-COMPLETE-SUMMARY.md` (this file)

---

## Quick Setup (Copy-Paste)

```bash
# 1. Create branch
git checkout -b seed-data

# 2. Copy migrations to db/migrate/
# 3. Copy models to app/models/
# 4. Copy controller to app/controllers/
# 5. Replace config/routes.rb
# 6. Copy views to app/views/payment_files/
# 7. Replace db/seeds.rb

# 8. Run migrations
rails db:migrate

# 9. Seed database
rails db:seed

# 10. Test
rails server

# 11. Visit http://localhost:3000

# 12. Commit
git add .
git commit -m "feat(seeds): add payment reconciliation models and 5 screens"

# 13. Merge & tag
git checkout main
git merge seed-data
git tag v0.2.0-data
git push origin main --tags
```

---

## What You'll See After Setup

### Screen 1: Upload List
- 5 payment files
- Status indicators
- Action links

### Screen 2: Display
- 30 merchant transactions
- Commission columns
- Summary totals

### Screen 3: Errors
- 8 red-highlighted errors
- Discrepancy amounts
- Error count

### Screen 4: Tenancy
- Settlement form
- Fee calculations
- Summary totals

### Screen 5: Summary
- Locked transactions
- Reconciliation status
- Download options

---

## Data Summary

| Metric | Count |
|--------|-------|
| Payment Files | 5 |
| Transactions | 70 |
| Merchants | 30+ |
| Errors | 8 |
| Screens | 5 |
| Models | 2 |
| Controllers | 1 |

---

## Troubleshooting

### Issue: "Couldn't find PaymentFile"
**Fix:** Make sure migrations ran: `rails db:migrate`

### Issue: No data showing
**Fix:** Run seeds: `rails db:seed`

### Issue: Styling looks broken
**Fix:** Ensure Tailwind is configured (in app/views/layouts/application.html.erb)

### Issue: Routes not working
**Fix:** Restart server (`Ctrl+C`, then `rails server`)

---

## Success Checklist

- [ ] Branch `seed-data` created
- [ ] Migrations copied (2 files)
- [ ] Models copied (2 files)
- [ ] Controller copied (1 file)
- [ ] Routes updated (1 file)
- [ ] Views copied (5 files)
- [ ] Seeds copied (1 file)
- [ ] `rails db:migrate` ran successfully
- [ ] `rails db:seed` created data (check: "✓ Created 5 payment files")
- [ ] Screen 1 shows 5 files
- [ ] Screen 2 shows 30 transactions
- [ ] Screen 3 shows 8 errors (red highlighted)
- [ ] Screen 4 shows settlement form
- [ ] Screen 5 shows locked transactions
- [ ] All navigation working
- [ ] Commit made to `seed-data` branch
- [ ] Merged to `main`
- [ ] Tagged as `v0.2.0-data`

---

## Time Estimate

| Task | Time |
|------|------|
| Copy files | 5 min |
| Run migrations | 1 min |
| Run seeds | 1 min |
| Test all screens | 10 min |
| Troubleshoot | 10 min |
| Commit & tag | 5 min |
| **Total** | **~30 min** |

---

## Key Model Methods

### PaymentFile
```ruby
@file.region_display        # "UK" or "CA"
@file.status_display        # "Parsed"
@file.has_errors?           # true/false
@file.error_count           # 8
@file.transaction_count     # 30
@file.transactions          # All Transaction objects
```

### Transaction
```ruby
@txn.type_display           # "Paid Commission"
@txn.error_display          # "Amount Mismatch"
@txn.has_error?             # true/false
@txn.total_commission       # Sum of initial + final
```

---

## Database Indexes

- `payment_files.status`
- `payment_files.region`
- `payment_files.affiliate_network`
- `transactions.payment_file_id`
- `transactions.error_flag`
- `transactions.screen_type`
- `transactions.mid`

---

## Enums Reference

### PaymentFile.status
- new
- ready
- processing
- parsed
- partial_reconciled
- full_reconciled

### PaymentFile.region
- uk
- ca
- us

### Transaction.transaction_type
- paid_sales
- paid_commission
- declined_sales
- declined_commission
- missing_sales
- missing_commission
- closed_sales
- closed_commission
- bonus
- tenancy_fee
- transaction

### Transaction.screen_type
- display
- missing
- tenancy
- summary

---

## Routes Reference

```ruby
GET  /payment_files              # Screen 1: Index
GET  /payment_files/:id/display  # Screen 2: Display
GET  /payment_files/:id/errors   # Screen 3: Errors
GET  /payment_files/:id/tenancy  # Screen 4: Tenancy
GET  /payment_files/:id/summary  # Screen 5: Summary
```

---

## View Directory Structure

```
app/views/payment_files/
├── index.html.erb
├── display.html.erb
├── errors.html.erb
├── tenancy.html.erb
└── summary.html.erb
```

---

## Git Commands Summary

```bash
# Create & work on branch
git checkout -b seed-data
# ... make changes ...

# Commit
git add .
git commit -m "feat(seeds): add models and screens"

# Merge to main
git checkout main
git merge seed-data
git tag v0.2.0-data

# Push
git push origin main --tags
```

---

## What Comes Next

✓ Task 2 complete: 5 screens, 70 transactions, read-only UI
→ Task 3: Add chat widget (Stimulus JS)
→ Task 4: Turbo Streams (real-time)
→ Task 5: AI integration (connect engine)
→ Task 6: Full chat experience
→ Task 7: Deploy to Render

---

## Pro Tips

1. **Test incrementally** — After each migration, test before moving on
2. **Keep seeds simple** — All data is immutable, just for display
3. **Read-only UI** — No editing, deleting, or validation needed
4. **Focus on beauty** — Tailwind CSS makes it look professional
5. **Prepare for Task 3** — Each screen will have a chat bubble asking questions

---

## Contact Points for Help

- **Routes issue:** Check `config/routes.rb` syntax
- **View issue:** Check file names (exactly as listed above)
- **Data issue:** Check seeds created (rails db:seed output)
- **Styling issue:** Check Tailwind CSS is configured

---

## Success Looks Like This

```
$ rails db:seed
✓ Created 5 payment files
✓ Created 70 transactions

Files created:
  - CJ-UK_2026_02_18_19711.69.xlsx (parsed) - 30 transactions
  - Linkshare-UK_2026_03_11_7109.04.xml (parsed) - 38 transactions
  - CJ-CA_2026_03_16_283.45.xlsx (full_reconciled) - 7 transactions
  - Fresh_Upload_2026_03_20_5432.10.csv (ready) - 0 transactions
  - In_Progress_2026_03_22.xlsx (processing) - 0 transactions

$ rails server
=> Booting Puma
=> Rails 7.1.0 application starting in development
=> Listening on http://127.0.0.1:3000

# Visit http://localhost:3000
# ✓ Screen 1 loads perfectly
# ✓ All 5 screens accessible
# ✓ Data displays correctly
```

---

## YOU'RE READY TO BUILD

All files are provided. All instructions are clear. No guesswork needed.

**Copy files → Run migrations → Run seeds → Test → Commit → Move to Task 3**

Let's go! 🚀
