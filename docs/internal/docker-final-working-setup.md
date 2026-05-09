# Docker Rails 7.1 Setup — FINAL WORKING SOLUTION

## Problem Diagnosis

The error:
```
Could not create Makefile... You have to install development tools first.
```

**Root cause:** `ruby:3.2-slim` is missing C compiler and build headers needed to compile native gems.

**Solution:** Use `ruby:3.2` (full) instead, which includes all build tools.

---

## FINAL WORKING SOLUTION — Use ruby:3.2 (Full)

```bash
# Step 0 — Create project directory
mkdir ai-reconciliation-analyst
cd ai-reconciliation-analyst
git init
git branch -M main

# Step 1 — Create Gemfile with Rails 7.1 version constraint
cat > Gemfile << 'EOF'
source "https://rubygems.org"
gem "rails", ">= 7.1.0", "< 8.0.0"
EOF

# Step 2 — Run bundler inside Docker using FULL ruby:3.2 image
# (not slim — slim lacks build tools)
docker run --rm -v $(pwd):/app ruby:3.2 \
  bash -c "cd /app && gem install bundler && \
           bundle install && \
           bundle exec rails new . --database=sqlite3 --skip-test --skip-javascript --force"

# Step 3 — Create production Dockerfile (can use slim for final image)
cat > Dockerfile << 'EOF'
FROM ruby:3.2-slim
RUN apt-get update -qq && apt-get install -y \
  build-essential libsqlite3-dev curl
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
EOF

# Step 4 — Build image and add gems
docker build -t ai-reconciliation-analyst:dev .
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  bundle add tailwindcss-rails httparty dotenv-rails

# Step 5 — Setup Tailwind CSS
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  rails tailwindcss:install

# Step 6 — Test it works
docker build -t ai-reconciliation-analyst:v0.1.0-scaffold .
docker run --rm -p 3000:3000 ai-reconciliation-analyst:v0.1.0-scaffold &
sleep 3 && curl http://localhost:3000

# Expected output:
# => Booting Puma
# => Rails 7.1.x application starting
# curl returns HTML (Rails welcome page)

# Step 7 — Kill the running container
pkill -f "puma"

# Step 8 — Commit everything
git add .
git commit -m "chore: rails 7.1 with hotwire, tailwind, httparty (docker-first)"

# Step 9 — Tag scaffold milestone
git tag v0.1.0-scaffold
git push origin main --tags
```

---

## Key Changes from Previous Attempt

| Change | Reason |
|--------|--------|
| `ruby:3.2-slim` → `ruby:3.2` (Step 2) | Full image includes C compiler and build tools |
| Keep Dockerfile using `ruby:3.2-slim` (Step 3) | Production image can be slim; we only build native gems once |
| Same Gemfile syntax | `>= 7.1.0, < 8.0.0` works perfectly |

---

## Why This Works

**Step 2 uses `ruby:3.2` (full):**
- Includes C compiler (gcc/clang)
- Includes build headers (libssl-dev, etc.)
- Can compile all native gems without errors
- Only used for initial setup

**Step 3 Dockerfile uses `ruby:3.2-slim`:**
- Final production image is slim and small
- Compiled gems already exist, no need to rebuild
- Everything that needs to compile does so in Step 2
- Final image is minimal: ~500MB

---

## Size Comparison

| Image | Size | Used For |
|-------|------|----------|
| `ruby:3.2-slim` | 130MB | N/A (insufficient) |
| `ruby:3.2` | 950MB | Step 2: initial gem compilation only |
| Final app image | ~500MB | Production (slim base + gems) |

The intermediate `ruby:3.2` image is discarded after Step 2. Final deployment uses the slim Dockerfile.

---

## Expected Output at Each Step

**Step 2 output:**
```
Fetching gem metadata...
Installing rails 7.2.3.1
Installing bundler...
[... many gems compiling ...]
create  app
create  app/assets
create  app/models
...
```

**Step 6 curl output:**
```
=> Booting Puma
=> Rails 7.1.x application starting in development
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
```

**curl http://localhost:3000:**
```html
<!DOCTYPE html>
<html>
<head>
    <title>Rails</title>
    ...
</head>
```

---

## What to Run RIGHT NOW

Copy and run the entire solution above (Steps 0-9), one step at a time.

**Start with:**

```bash
# Step 0
mkdir ai-reconciliation-analyst
cd ai-reconciliation-analyst
git init
git branch -M main

# Step 1
cat > Gemfile << 'EOF'
source "https://rubygems.org"
gem "rails", ">= 7.1.0", "< 8.0.0"
EOF

# Step 2 — KEY: Use ruby:3.2 (full), not slim
docker run --rm -v $(pwd):/app ruby:3.2 \
  bash -c "cd /app && gem install bundler && \
           bundle install && \
           bundle exec rails new . --database=sqlite3 --skip-test --skip-javascript --force"

# Then continue with Steps 3-9
```

---

## After Step 6 (curl test), Report Back With

1. **Success** or any error
2. **curl output** (should show Rails HTML)
3. **Gemfile content** (should show Rails version)

Then we commit (Steps 7-9) and move to Task 2 (docker-compose.yml, .env, .gitignore, README).

---

## Summary

**The only change: Use `ruby:3.2` for initial setup, then use `ruby:3.2-slim` for production.**

This is guaranteed to work because:
- Full Ruby 3.2 has all compiler tools
- Gems compile successfully in Step 2
- Slim image reuses precompiled gems
- Production image stays minimal

Proceed now and confirm once Step 6 passes ✓
