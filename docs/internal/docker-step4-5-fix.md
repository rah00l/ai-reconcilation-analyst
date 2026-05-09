# Docker Setup — Fix for Gems Installation Issue

## Problem Diagnosis

The error:
```
Could not find tailwindcss-rails-4.4.0, httparty-0.24.2, dotenv-rails-3.2.0... in locally installed gems
```

**Root cause:**
1. Step 4 ran `bundle add` which modified your local `Gemfile`
2. But it didn't run `bundle install` inside the container
3. Step 5 tries to run Rails, which needs those gems
4. Container doesn't have them, so it fails

**Solution:** After `bundle add`, you must run `bundle install` inside the container.

---

## CORRECTED WORKFLOW

Replace Steps 4-5 with these corrected steps:

```bash
# Step 4 — Add gems to Gemfile
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  bundle add tailwindcss-rails httparty dotenv-rails

# Step 4b — Install the newly added gems (CRITICAL STEP)
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  bundle install

# Step 5 — Setup Tailwind CSS
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  rails tailwindcss:install

# Step 6 — Test it works
docker build -t ai-reconciliation-analyst:v0.1.0-scaffold .
docker run --rm -p 3000:3000 ai-reconciliation-analyst:v0.1.0-scaffold &
sleep 3 && curl http://localhost:3000

# Step 7 — Kill container
pkill -f "puma"

# Step 8 — Commit everything
git add .
git commit -m "chore: rails 7.1 with hotwire, tailwind, httparty (docker-first)"

# Step 9 — Tag scaffold milestone
git tag v0.1.0-scaffold
git push origin main --tags
```

---

## Why This Works

**The sequence matters:**

1. `bundle add` — modifies Gemfile (local + container)
2. `bundle install` — downloads and installs gems into container
3. `rails tailwindcss:install` — now has access to tailwindcss-rails gem

Without Step 4b (`bundle install`), the gems are listed in Gemfile but not actually installed.

---

## What to Do RIGHT NOW

Run these commands in order:

```bash
# If you haven't already, add the gems
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  bundle add tailwindcss-rails httparty dotenv-rails

# CRITICAL: Install the gems
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  bundle install

# Now setup Tailwind
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  rails tailwindcss:install

# Test
docker build -t ai-reconciliation-analyst:v0.1.0-scaffold .
docker run --rm -p 3000:3000 ai-reconciliation-analyst:v0.1.0-scaffold &
sleep 3 && curl http://localhost:3000

# Expected output: Rails HTML page

# Stop the container
pkill -f "puma"

# Commit
git add .
git commit -m "chore: rails 7.1 with hotwire, tailwind, httparty (docker-first)"

# Tag
git tag v0.1.0-scaffold
git push origin main --tags
```

---

## Expected Output at Each Step

**After `bundle add`:**
```
Installing tailwindcss-rails 4.4.0
Installing httparty 0.24.2
Installing dotenv-rails 3.2.0
```

**After `bundle install`:**
```
Bundle complete! ...
```

**After `rails tailwindcss:install`:**
```
      create  app/assets/stylesheets/application.tailwind.css
      create  config/tailwind.config.js
      create  Procfile.dev
```

**After curl test (Step 6):**
```html
<!DOCTYPE html>
<html>
...Rails welcome page...
```

---

## Summary

**The fix:** Add a `bundle install` step after `bundle add`.

**Why:** `bundle add` updates Gemfile but doesn't install. `bundle install` actually downloads and installs the gems.

**Result:** Rails can find the gems and `rails tailwindcss:install` works.

Proceed with the corrected workflow above ✓
