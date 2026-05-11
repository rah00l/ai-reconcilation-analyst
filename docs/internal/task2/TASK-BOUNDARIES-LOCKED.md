# Task Boundaries — Crystal Clear Definition

## Task 2 (v0.2.0-data) — SEED DATA

### What IS Included in Task 2

✅ **Models Creation**
```bash
rails generate model PaymentFile ...
rails generate model Transaction ...
```
- Creates migrations automatically
- You edit the model files (add enums, scopes, validations)

✅ **Controller Creation**
```bash
# You create (not generate)
app/controllers/payment_files_controller.rb
```
- 5 actions: index, display, errors, tenancy, summary
- Just returns `@payment_files` or `@transactions`
- NO view rendering yet

✅ **Routes Configuration**
```ruby
config/routes.rb
```
- Resource routes defined
- 5 member routes added

✅ **Seeds Data**
```bash
rails db:seed
```
- 5 payment files created
- 70 transactions created
- All seed data in database
- NO UI to display this yet

✅ **Database Setup**
```bash
rails db:migrate
```
- Tables created with proper columns
- Indexes added
- Foreign keys configured

### What IS NOT Included in Task 2

❌ **NO Views** (HTML templates)
- No `app/views/payment_files/index.html.erb`
- No display screens
- No navigation between screens

❌ **NO UI/Styling**
- No Tailwind CSS applied
- No forms rendered
- No tables displayed

❌ **NO Controllers Actions Rendering Views**
- Controllers exist but do nothing yet
- They fetch data but don't render
- No ERB templates

❌ **NO Browser Testing**
- You won't visit http://localhost:3000
- No visual feedback
- Can't click buttons

---

## Task 3 (v0.3.0-screens-1-2) — SCREENS 1 & 2

### What IS Included in Task 3

✅ **Views for Screen 1 & 2**
```
app/views/payment_files/
├── index.html.erb (Screen 1: Upload list)
└── display.html.erb (Screen 2: Breakdown)
```

✅ **Controller Actions Rendering**
```ruby
def index
  @payment_files = PaymentFile.all
  render :index  # ← Now it renders the view
end

def display
  @payment_file = PaymentFile.find(params[:id])
  @transactions = @payment_file.transactions
  render :display
end
```

✅ **Styling**
- Tailwind CSS applied
- Tables styled
- Status badges colored
- Navigation links working

✅ **Browser Testing**
```
http://localhost:3000
http://localhost:3000/payment_files/1/display
```
- You see Screen 1 (file list)
- Click "Display" → Screen 2 (transaction breakdown)

---

## Task 4 (v0.4.0-screens-3-4-5) — SCREENS 3, 4, 5

### What IS Included in Task 4

✅ **Views for Screens 3, 4, 5**
```
app/views/payment_files/
├── errors.html.erb (Screen 3: Errors)
├── tenancy.html.erb (Screen 4: Settlement)
└── summary.html.erb (Screen 5: Final)
```

✅ **Navigation Between All Screens**
- Screen 1 → 2 → 3 → 4 → 5 all linked
- Back buttons working
- Full workflow visible

✅ **Error Highlighting**
- Red-highlighted errors on Screen 3
- Status badges
- Error counts

✅ **All 5 Screens Fully Functional**
- Read-only UI
- All data displaying
- Professional appearance

---

## Visual Task Breakdown

```
Task 2: FOUNDATION (No UI)
├─ Models created
├─ Controllers created
├─ Routes configured
├─ Seeds run
├─ Database populated
└─ [No views, no screens, no browser testing]

Task 3: SCREENS 1-2 (UI appears)
├─ Views for Screen 1 & 2 created
├─ Styling applied (Tailwind)
├─ Navigation working (click Display → Screen 2)
├─ Browser testing possible
└─ Can see file list and breakdown

Task 4: SCREENS 3-5 (Complete UI)
├─ Views for Screens 3, 4, 5 created
├─ All screens linked
├─ Error highlighting
├─ Full navigation
└─ Professional 5-screen workflow visible
```

---

## Task 2 Verification (How to Know It's Done)

**After Task 2, you verify with:**

```bash
# Run migrations
rails db:migrate
# ✓ Output: "== [timestamp] CreatePaymentFiles: migrated"

# Check database
rails dbconsole
> select count(*) from payment_files;
# ✓ Output: 5

> select count(*) from transactions;
# ✓ Output: 70

# Verify models load
rails console
> PaymentFile.first
# ✓ Returns the first file with all attributes

> Transaction.first
# ✓ Returns the first transaction

> exit
```

**You do NOT test in browser yet.** That's Task 3.

---

## Task 3 Verification (How to Know It's Done)

**After Task 3, you verify with:**

```bash
# Start server
rails server

# Visit in browser
http://localhost:3000

# ✓ See Screen 1: List of 5 payment files
# ✓ Click "Display" on any file
# ✓ See Screen 2: 30 transactions with breakdown

# ✓ Click back
# ✓ UI looks professional (Tailwind styled)
```

---

## Task 4 Verification (How to Know It's Done)

**After Task 4, you verify with:**

```bash
# Start server
rails server

# Visit in browser
http://localhost:3000

# ✓ See Screen 1: File list
# ✓ Click "Display" → Screen 2: Breakdown
# ✓ Click "Errors" → Screen 3: Red-highlighted errors
# ✓ Click "Tenancy" → Screen 4: Settlement form
# ✓ Click "Summary" → Screen 5: Final summary
# ✓ All screens linked and styled
# ✓ Professional 5-screen workflow
```

---

## Task Boundaries (LOCKED)

### Task 2: Data Foundation
- **Scope:** Models, controller skeleton, routes, seeds
- **No UI:** Views not created
- **No Rendering:** Controllers don't render views
- **No Styling:** No Tailwind CSS yet
- **Duration:** 45 minutes

### Task 3: First Two Screens
- **Scope:** Screen 1 (list), Screen 2 (display)
- **With UI:** Views created and rendered
- **With Styling:** Tailwind CSS applied
- **With Navigation:** Screen 1 → Screen 2 working
- **Duration:** 45 minutes

### Task 4: Last Three Screens
- **Scope:** Screen 3 (errors), Screen 4 (tenancy), Screen 5 (summary)
- **With UI:** All 5 screens complete
- **With Styling:** Professional appearance
- **With Navigation:** Screen 1 ↔ 2 ↔ 3 ↔ 4 ↔ 5
- **Duration:** 60 minutes

---

## Why This Boundary Makes Sense

### Task 2: Proves You Can Build Data Models
- ✓ Rails migrations
- ✓ Model relationships
- ✓ Enums and validations
- ✓ Seed data management
- Shows: **Backend understanding**

### Task 3: Proves You Can Build UI Basics
- ✓ Rails views (ERB)
- ✓ Two-screen navigation
- ✓ CSS framework integration
- ✓ Data binding to views
- Shows: **Frontend + backend integration**

### Task 4: Proves You Can Complete Features
- ✓ Multi-screen navigation
- ✓ Complex table layouts
- ✓ Status indicators
- ✓ Professional UX
- Shows: **Complete feature delivery**

---

## Git Tags at Each Milestone

```
After Task 2:
git tag v0.2.0-data
# App has models, seeds, database but no UI

After Task 3:
git tag v0.3.0-screens-1-2
# App has 2 functional screens with styling

After Task 4:
git tag v0.4.0-screens-3-4-5
# App has all 5 functional screens (complete UI)

After Task 5 (Engine Integration):
git tag v0.5.0-engine
# App connects to AI engine

After Task 6 (Chat Widget):
git tag v0.6.0-chat
# App has chat assistant on all screens

Final:
git tag v1.0.0
# Complete portfolio piece ready for hiring managers
```

---

## Implementation Plan (Next 3 Tasks)

```
THIS WEEK:
├─ Task 2 (Today) → v0.2.0-data (backend only)
├─ Task 3 (Tomorrow) → v0.3.0-screens-1-2 (2 screens)
└─ Task 4 (Day after) → v0.4.0-screens-3-4-5 (5 screens complete)

NEXT WEEK:
├─ Task 5 → v0.5.0-engine (AI integration)
├─ Task 6 → v0.6.0-chat (Chat widget)
└─ Task 7 → v1.0.0 (Live deployment)
```

---

## Exact File Locations for Task 2

```
Task 2 Deliverables:
├─ app/models/payment_file.rb (you create)
├─ app/models/transaction.rb (you create)
├─ app/controllers/payment_files_controller.rb (you create)
├─ config/routes.rb (you update)
├─ db/migrate/[timestamp]_create_payment_files.rb (rails generates, you verify)
├─ db/migrate/[timestamp]_create_transactions.rb (rails generates, you verify)
└─ db/seeds.rb (you replace)

Note: NO view files in Task 2
```

---

## Summary Table

| Task | Deliverable | UI? | Views? | Styling? | Browser? |
|------|-------------|-----|--------|----------|----------|
| **Task 2** | Models + Seeds | ❌ | ❌ | ❌ | ❌ |
| **Task 3** | Screens 1-2 | ✅ | ✅ | ✅ | ✅ |
| **Task 4** | Screens 3-5 | ✅ | ✅ | ✅ | ✅ |
| **Task 5** | Engine Link | - | - | - | - |
| **Task 6** | Chat Widget | ✅ | ✅ | ✅ | ✅ |

---

## You Are Here

```
Task 1 (Setup): ✅ COMPLETE
Task 2 (Seeds): 👈 NEXT (Today)
Task 3 (Screens 1-2): 🔜 After Task 2
Task 4 (Screens 3-5): 🔜 After Task 3
Task 5-7: 🔜 Later
```

---

## Clear Instruction for Task 2

**Task 2 Boundary:**

1. ✅ Create models (copy-paste model files)
2. ✅ Run migrations (rails db:migrate)
3. ✅ Create controller (copy-paste controller)
4. ✅ Update routes (replace routes.rb)
5. ✅ Run seeds (rails db:seed)
6. ✅ Verify in console (rails console)

**Do NOT:**
- ❌ Create view files
- ❌ Start styling
- ❌ Test in browser
- ❌ Add navigation between screens

**That's Task 3 and Task 4.**

---

## Confirmation

**Is this clear?**

- Task 2 = Backend only (models, seeds, no UI)
- Task 3 = Screens 1-2 (2 views, styling, navigation)
- Task 4 = Screens 3-5 (3 more views, complete UI)

**Proceed with Task 2 using the provided implementation guide.**
