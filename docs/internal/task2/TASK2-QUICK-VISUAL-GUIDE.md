# Task 2 — Quick Visual Guide (Your Questions Answered)

## Your Questions

### Q1: Docker or Local Setup?
### Q2: Where are the files? Where do they go?

---

## Answer 1: Docker-First Approach

### Visual Workflow

```
YOUR LAPTOP          DOCKER CONTAINER
─────────────        ─────────────────

Edit files    ──→    Docker has files
   ↓                      ↓
git commit    ──→    Rails commands run
   ↓                      ↓
git push      ←──    Results show up
   ↓                      ↓
Browser       ←──    http://localhost:3000
(see results)
```

### Key Point: No Local Rails Needed

```
❌ You don't have:          ✅ Docker has:
- Ruby 3.2                 - Ruby 3.2
- Rails 7.1                - Rails 7.1
- SQLite3                  - SQLite3
- Bundle                   - Everything

Docker runs all rails commands for you
```

### Commands to Use (Copy-Paste)

```bash
# Create branch (on your laptop)
git checkout -b seed-data

# Copy files (on your laptop)
# (See Answer 2 below for file locations)

# Build Docker image (includes your new files)
docker build -t ai-reconciliation-analyst:dev .

# Run migrations IN DOCKER
docker run --rm -v $(pwd):/app \
  ai-reconciliation-analyst:dev \
  rails db:migrate

# Seed database IN DOCKER
docker run --rm -v $(pwd):/app \
  ai-reconciliation-analyst:dev \
  rails db:seed

# Start server IN DOCKER
docker run --rm -p 3000:3000 -v $(pwd):/app \
  ai-reconciliation-analyst:dev \
  rails server -b 0.0.0.0

# Visit on your laptop browser
http://localhost:3000

# When done, stop server (Ctrl+C)

# Commit changes (on your laptop)
git add .
git commit -m "feat(seeds): add models"
git tag v0.2.0-data
git push origin main --tags
```

---

## Answer 2: File Locations

### Where Files Are NOW

```
/mnt/user-data/outputs/
│
├── 20260510000001_create_payment_files.rb
├── 20260510000002_create_transactions.rb
├── payment_file.rb
├── transaction.rb
├── payment_files_controller.rb
├── routes.rb
├── index_view.html.erb
├── display_view.html.erb
├── errors_view.html.erb
├── tenancy_view.html.erb
├── summary_view.html.erb
└── seeds.rb
```

### Where They Go IN YOUR REPO

```
ai-reconciliation-analyst/  (your repo root)
│
├── db/
│   ├── migrate/
│   │   ├── [TIMESTAMP]_create_payment_files.rb ← copy here
│   │   └── [TIMESTAMP]_create_transactions.rb ← copy here
│   │
│   └── seeds.rb ← REPLACE this file
│
├── app/
│   ├── models/
│   │   ├── payment_file.rb ← copy here
│   │   └── transaction.rb ← copy here
│   │
│   ├── controllers/
│   │   └── payment_files_controller.rb ← copy here
│   │
│   └── views/
│       └── payment_files/  ← CREATE this directory
│           ├── index.html.erb ← copy here
│           ├── display.html.erb ← copy here
│           ├── errors.html.erb ← copy here
│           ├── tenancy.html.erb ← copy here
│           └── summary.html.erb ← copy here
│
└── config/
    └── routes.rb ← REPLACE this file
```

---

## Copy Files — Three Methods

### Method 1: Terminal Commands (Fastest)

```bash
# Navigate to your repo
cd /path/to/ai-reconciliation-analyst

# Copy migrations
cp /mnt/user-data/outputs/20260510000001_create_payment_files.rb db/migrate/
cp /mnt/user-data/outputs/20260510000002_create_transactions.rb db/migrate/

# Copy models
cp /mnt/user-data/outputs/payment_file.rb app/models/
cp /mnt/user-data/outputs/transaction.rb app/models/

# Copy controller
cp /mnt/user-data/outputs/payment_files_controller.rb app/controllers/

# Replace routes
cp /mnt/user-data/outputs/routes.rb config/

# Create views directory
mkdir -p app/views/payment_files

# Copy views
cp /mnt/user-data/outputs/index_view.html.erb app/views/payment_files/index.html.erb
cp /mnt/user-data/outputs/display_view.html.erb app/views/payment_files/display.html.erb
cp /mnt/user-data/outputs/errors_view.html.erb app/views/payment_files/errors.html.erb
cp /mnt/user-data/outputs/tenancy_view.html.erb app/views/payment_files/tenancy.html.erb
cp /mnt/user-data/outputs/summary_view.html.erb app/views/payment_files/summary.html.erb

# Replace seeds
cp /mnt/user-data/outputs/seeds.rb db/

# Verify
git status
```

### Method 2: File Explorer (Easiest)

1. Open `/mnt/user-data/outputs/` in file explorer
2. Open your repo folder in another window
3. Drag & drop files to exact locations shown above
4. Run `git status` to verify all 12 files copied

### Method 3: Manual Copy-Paste

1. Open each file from `/mnt/user-data/outputs/`
2. Copy content
3. Paste into corresponding location in your repo
4. Save

---

## Verify Files Are In Place

```bash
cd /path/to/ai-reconciliation-analyst

# Check migrations
ls -la db/migrate/ | grep create_payment
ls -la db/migrate/ | grep create_transactions

# Check models
ls -la app/models/payment_file.rb
ls -la app/models/transaction.rb

# Check controller
ls -la app/controllers/payment_files_controller.rb

# Check routes
ls -la config/routes.rb

# Check views
ls -la app/views/payment_files/
# Should show 5 .html.erb files

# Check seeds
ls -la db/seeds.rb

# Quick status
git status
# Should show 12 files changed/added
```

---

## Important Details

### File Names MUST Match Exactly

```
✅ Correct names:
   db/migrate/20260510000001_create_payment_files.rb
   app/models/payment_file.rb
   app/controllers/payment_files_controller.rb
   app/views/payment_files/index.html.erb

❌ Wrong names (these won't work):
   db/migrate/20260510000001_create_payment_files (missing .rb)
   app/models/payment_file.erb (wrong extension)
   app/controllers/payment_files.rb (missing _controller)
   app/views/payment_files/index_view.html (missing .erb)
```

### Routes.rb REPLACE (Don't Append)

Your current `config/routes.rb`:
```ruby
Rails.application.routes.draw do
  # Some existing routes
end
```

Becomes (completely replaced):
```ruby
Rails.application.routes.draw do
  root "payment_files#index"
  
  resources :payment_files, only: [:index, :show] do
    member do
      get :display
      get :errors
      get :tenancy
      get :summary
    end
  end
end
```

### Seeds.rb REPLACE (Don't Append)

Same — completely replace the entire file.

---

## Timeline (Start to Finish)

```
Copy files:           5 min
Build Docker:         2 min
Run migrations:       1 min
Run seeds:            1 min
Start server:         1 min
Test 5 screens:      10 min
Commit & tag:         5 min
─────────────
TOTAL:              ~25 min
```

---

## Quick Checklist

- [ ] Files copied from /mnt/user-data/outputs/ to repo
- [ ] All 12 files in correct locations
- [ ] git status shows 12 files
- [ ] Docker image built
- [ ] Migrations run (no errors)
- [ ] Seeds run (✓ Created 5 payment files)
- [ ] Server running (http://localhost:3000 works)
- [ ] Screen 1 loads (5 files visible)
- [ ] Screen 2 loads (30 transactions visible)
- [ ] Screen 3 loads (8 errors in red)
- [ ] Screen 4 loads (settlement form)
- [ ] Screen 5 loads (summary)
- [ ] All navigation works
- [ ] Committed to seed-data branch
- [ ] Merged to main
- [ ] Tagged v0.2.0-data
- [ ] Pushed to origin

---

## All 12 Files Belong in Task 2 (NOT Split)

```
Task 2 (v0.2.0-data):
├─ Migrations (2) ← NOW
├─ Models (2) ← NOW
├─ Controller (1) ← NOW
├─ Routes (1) ← NOW
├─ Views (5) ← NOW
└─ Seeds (1) ← NOW

Task 3 will add:
├─ Stimulus controller (chat)
├─ Turbo Stream actions
└─ Chat views

No overlap between tasks.
```

---

## Docker Quick Reference

```bash
# Build image
docker build -t ai-reconciliation-analyst:dev .

# Run migration
docker run --rm -v $(pwd):/app \
  ai-reconciliation-analyst:dev rails db:migrate

# Run seeds
docker run --rm -v $(pwd):/app \
  ai-reconciliation-analyst:dev rails db:seed

# Start server
docker run --rm -p 3000:3000 -v $(pwd):/app \
  ai-reconciliation-analyst:dev rails server -b 0.0.0.0

# Stop server
Ctrl+C

# Access database in Docker
docker run --rm -v $(pwd):/app \
  ai-reconciliation-analyst:dev rails dbconsole
```

---

## Your Task Right Now

1. **Copy files** from `/mnt/user-data/outputs/` to your repo
2. **Verify** with `git status` (should show 12 files)
3. **Run Docker commands** above
4. **Test** at http://localhost:3000
5. **Commit & tag**

**You're ready. All pieces are here. Let's build!** ✓
