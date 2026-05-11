# Task 2 Quick Start - How to Use All Code Files

## You Now Have

A single document with ALL 5 code files you need for Task 2:
**TASK2-ALL-CODE-FILES.md** (above)

---

## What To Do Now

### Step 1: Copy File 1 - payment_file.rb

From the document above, find the section:
```
## FILE 1: app/models/payment_file.rb
```

Copy the entire Ruby code block (starts with `class PaymentFile` ends with `end`)

### Step 2: Create File In Your Project

```bash
# On your local machine
cd /path/to/your/ai-reconciliation-analyst

# Create the file
cat > app/models/payment_file.rb << 'EOF'
# PASTE THE CODE YOU COPIED HERE
EOF
```

Or use any text editor to create: `app/models/payment_file.rb` and paste the code.

### Step 3: Repeat For Other Files

Do the same for:
- FILE 2: `app/models/transaction.rb`
- FILE 3: `db/migrate/20260510000001_create_payment_files.rb`
- FILE 4: `db/migrate/20260510000002_create_transactions.rb`
- FILE 5: `db/seeds.rb` (replace existing)

### Step 4: Run Migrations

```bash
# Make sure you're in your project folder
cd /path/to/your/ai-reconciliation-analyst

# Run migrations in Docker
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  rails db:migrate
```

### Step 5: Seed Database

```bash
# Run seeds in Docker
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  rails db:seed
```

### Step 6: Verify Success

```bash
# Check output
# You should see:
# ✓ Created 5 payment files
# ✓ Created 70 transactions
```

---

## File Checklist

- [ ] FILE 1: `app/models/payment_file.rb` created
- [ ] FILE 2: `app/models/transaction.rb` created
- [ ] FILE 3: `db/migrate/[timestamp]_create_payment_files.rb` created
- [ ] FILE 4: `db/migrate/[timestamp]_create_transactions.rb` created
- [ ] FILE 5: `db/seeds.rb` created/replaced
- [ ] `rails db:migrate` ran successfully
- [ ] `rails db:seed` ran successfully
- [ ] Saw output: "✓ Created 5 payment files" and "✓ Created 70 transactions"

---

## You're Done With Task 2!

After completing all steps above:

```bash
# Commit your work
git add .
git commit -m "feat(seeds): add payment file and transaction models with 70 seed records"

# Merge to main
git checkout main
git merge seed-data

# Tag
git tag v0.2.0-data

# Push
git push origin main --tags
```

---

## What You Accomplished

✅ Created 2 Rails models (PaymentFile, Transaction)
✅ Created 2 database migrations
✅ Seeded 5 payment files
✅ Seeded 70 transactions
✅ Database ready for Task 3 (UI screens)

**Task 2 is complete!** 🎉

---

## Next: Task 3

After Task 2, Task 3 will add:
- Controller
- Routes
- Views (Screen 1 & 2)

Those files will also be provided in the same way.

**Let's build!** 🚀
