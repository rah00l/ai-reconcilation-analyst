# Quick Reference: File Locations & Docker Mounting

## The Simple Answer

```
/mnt/user-data/outputs/  ← Files are HERE (your local machine)
                            ↓ (copy them)
                            ↓
your-project/app/models/ ← Files go HERE (your local machine)
                            ↓ (Docker mounts this folder)
                            ↓
Docker Container sees: /app/app/models/
```

---

## Step-by-Step (Visual)

### STEP 1: Files Exist Here (Your Local Machine)
```
/mnt/user-data/outputs/
├─ payment_file.rb         ← I created these for you
├─ transaction.rb
├─ seeds.rb
├─ 20260510000001_create_payment_files.rb
├─ 20260510000002_create_transactions.rb
└─ ... more files
```

### STEP 2: Copy To Your Project (Your Local Machine)
```
cp /mnt/user-data/outputs/payment_file.rb \
   your-project/app/models/

cp /mnt/user-data/outputs/transaction.rb \
   your-project/app/models/

cp /mnt/user-data/outputs/seeds.rb \
   your-project/db/seeds.rb
```

### STEP 3: Your Project Now Has Files (Your Local Machine)
```
your-project/
├─ app/
│  └─ models/
│     ├─ payment_file.rb        ← Now here (copied)
│     └─ transaction.rb         ← Now here (copied)
└─ db/
   └─ seeds.rb                 ← Now here (copied)
```

### STEP 4: Run Docker From Your Project Folder
```bash
cd your-project

docker run -v $(pwd):/app ai-reconciliation-analyst:dev \
  rails db:migrate

# What happens:
# Your folder (your-project/) gets mounted as /app inside Docker
# So Docker sees the files you just copied
```

### STEP 5: Docker Container Sees The Same Files
```
Inside Docker Container:
/app/
├─ app/
│  └─ models/
│     ├─ payment_file.rb        ← Same files (via mount)
│     └─ transaction.rb         ← Same files (via mount)
└─ db/
   └─ seeds.rb                 ← Same files (via mount)
```

### STEP 6: Database Created On Your Local Machine
```
After Docker runs:

your-project/db/
├─ development.sqlite3         ← NEW! Created by Docker
├─ seeds.rb
└─ migrate/
```

---

## The Key Insight: Volume Mounting

```bash
docker run -v $(pwd):/app ...
           ↑
           Volume mount flag

$(pwd)     = Your current folder on LOCAL MACHINE
:/app      = Where it appears INSIDE DOCKER
           = They're the SAME FILES, different paths

Local Path:     your-project/app/models/payment_file.rb
Docker Path:    /app/app/models/payment_file.rb
                (same file, just different path)
```

---

## Where Are Files Really?

### Before You Start
```
/mnt/user-data/outputs/  ← Files (on your machine)
your-project/            ← Your Rails app (on your machine)
                          ← EMPTY (needs files copied)
```

### After You Copy Files
```
/mnt/user-data/outputs/  ← Original files (can leave here)
your-project/            ← Your Rails app (on your machine)
  ├─ app/models/
  │  ├─ payment_file.rb  ← COPIED from /mnt/user-data/outputs/
  │  └─ transaction.rb   ← COPIED from /mnt/user-data/outputs/
  └─ db/
     └─ seeds.rb         ← COPIED from /mnt/user-data/outputs/
```

### After Docker Runs
```
/mnt/user-data/outputs/  ← Still here (unchanged)
your-project/            ← Your Rails app (on your machine)
  ├─ app/models/
  │  ├─ payment_file.rb  ← Still here
  │  └─ transaction.rb   ← Still here
  └─ db/
     ├─ seeds.rb         ← Still here
     ├─ migrate/
     │  ├─ [timestamp]_create_payment_files.rb     ← CREATED by Rails
     │  └─ [timestamp]_create_transactions.rb      ← CREATED by Rails
     └─ development.sqlite3                        ← CREATED by Docker
```

---

## Common Questions

### Q: Do the files in `/mnt/user-data/outputs/` disappear?
**A:** No. They stay there. You're just copying them.

### Q: Is `/mnt/user-data/outputs/` on Docker?
**A:** No. It's on your local machine (where you are reading this).

### Q: Can I delete `/mnt/user-data/outputs/` after copying?
**A:** Yes. They're just source files. You can delete them after copying.

### Q: How does Docker see my files if they're not on Docker?
**A:** Volume mount! The `-v $(pwd):/app` flag mounts your folder into Docker.

### Q: Where is the database created?
**A:** On your local machine: `your-project/db/development.sqlite3`

### Q: Does Docker create the database inside Docker or on my machine?
**A:** Docker creates it, but because of the mount, it ends up on your machine.

---

## Copy Command Examples

### Copy All Files At Once
```bash
# Navigate to your project
cd /path/to/your/ai-reconciliation-analyst

# Copy models
cp /mnt/user-data/outputs/payment_file.rb app/models/
cp /mnt/user-data/outputs/transaction.rb app/models/

# Copy migrations  
cp /mnt/user-data/outputs/20260510000001_create_payment_files.rb db/migrate/
cp /mnt/user-data/outputs/20260510000002_create_transactions.rb db/migrate/

# Copy seeds (replace existing)
cp /mnt/user-data/outputs/seeds.rb db/seeds.rb

# Copy controller (for later, Task 3)
cp /mnt/user-data/outputs/payment_files_controller.rb app/controllers/

# Verify
ls app/models/
ls db/migrate/
cat db/seeds.rb
```

### Or Use File Manager
```
1. Open file manager
2. Navigate to /mnt/user-data/outputs/
3. Drag files to your-project/app/models/
4. Drag files to your-project/db/migrate/
5. Drag seeds.rb to your-project/db/
```

---

## After Files Are Copied: Run Docker

```bash
# Make sure you're in your project folder
cd /path/to/your/ai-reconciliation-analyst

# Run migrations (Docker will see your files via mount)
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  rails db:migrate

# Run seeds
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  rails db:seed

# Check database was created (on YOUR machine)
ls db/
# Should show: development.sqlite3
```

---

## Everything Is On YOUR Local Machine

```
NOTHING is on Docker's disk.
EVERYTHING stays on your local machine.

Files just:
1. Start in /mnt/user-data/outputs/
2. Get copied to your-project/
3. Docker accesses via volume mount
4. Changes saved to your-project/
5. You can access anytime, Docker or not
```

---

## Ready To Start

✅ Understand: Files are on your local machine
✅ Understand: Copy them to your project locally
✅ Understand: Docker accesses via volume mount
✅ Understand: Database created on your machine

**You're ready for Task 2!**

**See:** `TASK2-DOCKER-FIRST-EXECUTION.md` for next steps
