# Task 1 Complete — Docker & Git Strategy Clarification

## Question 1: Docker vs Docker Compose — When to Use Each

### Docker vs Docker Compose Quick Reference

| Scenario | Tool | Why |
|----------|------|-----|
| **Single service** (just your Rails app) | `docker run` | Simple, one command, no config file needed |
| **Multiple services** (Rails app + engine) | `docker-compose` | Orchestrates both services, networking, startup order |
| **Development** (local testing) | `docker-compose` | Easy `docker compose up`, manages entire stack |
| **Production** (deployed system) | `docker-compose` or orchestrator (K8s) | Manages scaling, health checks, networking |

---

### Your Architecture Requires Both

**Current state (Task 1):**
```
Rails app only
├─ docker run (for local testing)
└─ docker build (for image creation)
```

**Next state (Task 2 - docker-compose.yml):**
```
Rails app + Engine (two services)
├─ docker-compose up (starts both)
├─ Rails app on port 3000
├─ Engine on port 4567
└─ Both on same network (analyst-net)
```

---

## Question 1 Answer — Locked Decision

**For development (local):** Use `docker-compose`
**For deployment:** Use `docker-compose` or Kubernetes

**Why:**
- Your app depends on the engine
- Engine runs on port 4567, app on port 3000
- They need to communicate (http://engine:4567)
- Docker Compose handles all of this automatically

---

### Your docker-compose.yml (Task 2)

```yaml
version: "3.8"
services:
  engine:
    image: ai-analyst-engine:v1.0.0
    env_file: .env
    ports:
      - "4567:4567"
    networks:
      - analyst-net

  app:
    build: .
    image: ai-reconciliation-analyst:v0.1.0-scaffold
    env_file: .env
    ports:
      - "3000:3000"
    depends_on:
      - engine
    environment:
      ENGINE_URL: http://engine:4567
    networks:
      - analyst-net

networks:
  analyst-net:
    driver: bridge
```

**Usage:**
```bash
# Start both services
docker compose up

# Rails: http://localhost:3000
# Engine: http://localhost:4567
```

---

## Question 2: Git Branching Strategy — Confirmed

Your original plan was **CORRECT**. Let me clarify the exact flow:

### Git Strategy (Locked from Earlier Discussion)

**Branch naming:**
- Task branches for feature work
- Tags for milestones/releases
- Main is merge-only (never direct commits)

**Your current state should be:**

```
Git History:
├─ main
│  ├─ tag: v0.1.0-scaffold (current)
│  └─ commit: "chore: rails 7.1 with hotwire, tailwind, httparty"
│
└─ branches:
   ├─ setup (MERGED to main, tag added)
   ├─ seed-data (NEXT)
   ├─ screens-1-2 (THEN)
   ├─ screens-3-4-5 (THEN)
   ├─ engine-integration (THEN)
   ├─ chat-integration (THEN)
   └─ deploy (FINAL)
```

---

## Answer to Question 2 — The Flow

### CURRENT STATE (Task 1 Complete)

You are currently on `main` with:
- ✓ Rails 7.1 scaffold created
- ✓ Tailwind CSS installed
- ✓ Gems added (httparty, dotenv-rails, tailwindcss-rails)
- ✓ Git commit made
- ✓ v0.1.0-scaffold tag created

**This is correct.** You committed directly to main because Task 1 is foundational.

---

### NEXT: Task 2 (Seed Data) — Branches Start Here

Now you **create a task branch** for each feature:

```bash
# Step 1 — Create and checkout branch for Task 2
git checkout -b seed-data

# Step 2 — Add seed data
cat > db/seeds.rb << 'EOF'
# Create fictional data
PaymentFile.create(...)
Transaction.create(...)
Merchant.create(...)
EOF

# Step 3 — Commit the work
git add db/seeds.rb
git commit -m "feat(seeds): add fictional payment data for development"

# Step 4 — Create pull request (or merge manually for solo dev)
git checkout main
git merge seed-data

# Step 5 — Tag the milestone
git tag v0.2.0-data
git push origin main --tags
```

---

## Why This Branching Strategy?

| Stage | Branch Type | Why |
|-------|------------|-----|
| Task 1 (Setup) | Direct to main | Foundational, no dependencies |
| Task 2+ (Features) | Feature branches | Isolates changes, cleaner history |
| Milestones | Tags on main | Records stable points (v0.1.0, v0.2.0, v1.0.0) |
| Production | Dedicated branch | For hotfixes (main → stable) |

---

## Confirmed Git Strategy (Locked)

### Branch Names (Task 2 onwards)

```
main (protected, merge-only)
├─ v0.1.0-scaffold ✓ (Task 1 complete)
├─ v0.2.0-data (Task 2)
├─ v0.3.0-screens-1-2 (Task 3)
├─ v0.4.0-screens-3-4-5 (Task 4)
├─ v0.5.0-engine (Task 5 — engine integration)
├─ v0.6.0-chat (Task 6 — chat widget)
└─ v1.0.0 (Final portfolio release, Task 7)
```

### Commit Messages (Conventional Commits)

```
feat(feature-name): description        # New feature
fix(component): description            # Bug fix
refactor(module): description          # Code cleanup
chore: description                     # Build/config changes
docs: description                      # Documentation
```

---

## Task 2 Plan (Locked)

Now that Task 1 is complete, here's Task 2:

```bash
# Task 2 — Seed Data (v0.2.0-data)

# Step 1 — Create branch
git checkout -b seed-data

# Step 2 — Create Models
rails generate model PaymentFile status:string file_name:string
rails generate model Transaction payment_file:references amount:decimal status:string
rails generate model Merchant name:string
rails db:migrate

# Step 3 — Add seed data
cat > db/seeds.rb << 'EOF'
# Merchants
m1 = Merchant.create!(name: "Acme Corp", id: 1)
m2 = Merchant.create!(name: "Global Payments", id: 2)

# Payment Files
pf1 = PaymentFile.create!(status: "NEW", file_name: "payment_batch_001.csv")
pf2 = PaymentFile.create!(status: "READY", file_name: "payment_batch_002.csv")

# Transactions
Transaction.create!(payment_file: pf1, merchant: m1, amount: 1500.00, status: "PROCESSING")
Transaction.create!(payment_file: pf1, merchant: m2, amount: 2300.50, status: "PARSED")
EOF

# Step 4 — Seed the database
rails db:seed

# Step 5 — Commit
git add db/migrate db/seeds.rb
git commit -m "feat(seeds): add payment, transaction, merchant models with seed data"

# Step 6 — Merge to main
git checkout main
git merge seed-data

# Step 7 — Tag
git tag v0.2.0-data
git push origin main --tags
```

---

## Summary — Both Decisions Locked

### Decision 1: Docker Strategy
- **Local dev:** Use `docker-compose up` (starts Rails app + engine together)
- **Single commands:** Use `docker run` or `docker build`
- **Task 2:** You'll create docker-compose.yml to wire both services

### Decision 2: Git Strategy
- **Task 1 (setup):** Commit directly to main ✓ (already done)
- **Task 2+ (features):** Create feature branches (seed-data, screens-1-2, etc.)
- **Tags:** After each branch merges to main, create a tag (v0.2.0, v0.3.0, etc.)
- **Main is merge-only:** Never commit directly after Task 1

---

## Your Next Action

You have two options:

### Option A — Proceed to Task 2 Now
```bash
# Task 2 — Seed data and models
git checkout -b seed-data
# ... follow Task 2 plan above ...
```

### Option B — Create docker-compose.yml First
If you want to test both services together before adding screens, create the docker-compose.yml from Task 2 of the original plan.

**Recommendation:** Do Task 2 (seed data) first, then docker-compose.yml will reference the actual models.

Confirm which you'd like to start with, and I'll provide the exact step-by-step for Task 2 ✓
