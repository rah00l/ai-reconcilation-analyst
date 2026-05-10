# Task 1 Final Fix — Rebuild Docker Image with All Gems

## Problem Root Cause

The issue is:
- `docker run` creates a temporary container
- `bundle install` runs inside that container
- Gems are installed in the container
- Container exits and is discarded (--rm flag)
- Next `docker run` creates a fresh container with NO gems
- Rails commands fail because gems don't exist

**Solution:** Rebuild the Docker image to include all gems permanently.

---

## FINAL SOLUTION — One Command

Instead of running multiple `docker run` commands, rebuild the image with all gems baked in:

```bash
# Step 1 — Rebuild the Docker image (includes bundle install)
docker build -t ai-reconciliation-analyst:dev .

# This single command will:
# 1. Start with ruby:3.2-bookworm
# 2. Install system dependencies
# 3. Copy Gemfile + Gemfile.lock
# 4. Run bundle install (gems are baked into image)
# 5. Copy app code

# Step 2 — Run rails tailwindcss:install (gems now exist in image)
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  rails tailwindcss:install

# Step 3 — Rebuild again (includes Tailwind CSS assets)
docker build -t ai-reconciliation-analyst:v0.1.0-scaffold .

# Step 4 — Test it works
docker run --rm -p 3000:3000 ai-reconciliation-analyst:v0.1.0-scaffold &
sleep 3 && curl http://localhost:3000

# Expected: Rails HTML page

# Step 5 — Kill container
pkill -f "puma"

# Step 6 — Commit and tag
git add .
git commit -m "chore: rails 7.1 with hotwire, tailwind, httparty (docker-first)"
git tag v0.1.0-scaffold
git push origin main --tags
```

---

## Why This Works

When you run `docker build -t ai-reconciliation-analyst:dev .`, the Dockerfile executes these steps:

```dockerfile
FROM ruby:3.2-bookworm
RUN apt-get update && apt-get install -y build-essential libsqlite3-dev curl
WORKDIR /app
COPY Gemfile Gemfile.lock ./     # ← Gemfile exists here (from bundle add)
RUN bundle install               # ← Gems installed HERE and baked into image
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
```

The key: `RUN bundle install` is part of the image build, so gems are **permanently included** in the Docker image.

When you later run `docker run ... rails tailwindcss:install`, the gems already exist in the image.

---

## What to Do RIGHT NOW

Run these commands in order:

```bash
# Step 1 — Rebuild image (installs gems permanently)
docker build -t ai-reconciliation-analyst:dev .

# Step 2 — Setup Tailwind (gems now exist)
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  rails tailwindcss:install

# Step 3 — Rebuild image again (includes Tailwind assets)
docker build -t ai-reconciliation-analyst:v0.1.0-scaffold .

# Step 4 — Test
docker run --rm -p 3000:3000 ai-reconciliation-analyst:v0.1.0-scaffold &
sleep 3 && curl http://localhost:3000

# Step 5 — Stop
pkill -f "puma"

# Step 6 — Commit and tag
git add .
git commit -m "chore: rails 7.1 with hotwire, tailwind, httparty (docker-first)"
git tag v0.1.0-scaffold
git push origin main --tags
```

---

## Expected Output

**After Step 1 (docker build):**
```
[+] Building ...
 => [1/6] FROM ruby:3.2-bookworm
 => [2/6] RUN apt-get update && apt-get install -y...
 => [3/6] COPY Gemfile Gemfile.lock ./
 => [4/6] RUN bundle install
   Fetching gem metadata...
   Installing tailwindcss-rails 4.4.0
   ... all gems install ...
   Bundle complete! 99 gems installed.
 => [5/6] COPY . .
 => [6/6] Successfully built ...
```

**After Step 2 (rails tailwindcss:install):**
```
      create  app/assets/stylesheets/application.tailwind.css
      create  config/tailwind.config.js
      create  Procfile.dev
```

**After Step 4 curl test:**
```html
<!DOCTYPE html>
<html>
...Rails welcome page...
```

---

## Summary

**The fix:** Use `docker build` to permanently include gems in the image.

**Why:** `docker run` alone creates temporary containers. Gems don't persist between runs.

**Result:** Gems are baked into the image, so `rails tailwindcss:install` works.

Proceed with the steps above now ✓
