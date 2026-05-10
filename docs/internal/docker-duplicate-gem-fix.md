# Docker Setup — Fix for Duplicate Gem Error

## Problem Diagnosis

The error:
```
You cannot specify the same gem twice with different version requirements.
You specified: tailwindcss-rails (~> 4.4) and tailwindcss-rails (>= 0)
```

**Root cause:**
- Step 4 already ran `bundle add tailwindcss-rails httparty dotenv-rails` 
- Your `Gemfile` already has these gems
- Running `bundle add` again tries to add them twice
- Bundler rejects duplicate specifications

**Solution:** Skip `bundle add` and go straight to `bundle install`.

---

## CORRECTED WORKFLOW

Since the gems are already in your Gemfile, just run:

```bash
# Step 4b — Install gems (gems already in Gemfile from previous attempt)
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  bundle install

# Step 5 — Setup Tailwind CSS
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  rails tailwindcss:install

# Step 6 — Test it works
docker build -t ai-reconciliation-analyst:v0.1.0-scaffold .
docker run --rm -p 3000:3000 ai-reconciliation-analyst:v0.1.0-scaffold &
sleep 3 && curl http://localhost:3000

# Expected: Rails HTML page with 200 status

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

## What to Do RIGHT NOW

Just run these three commands in order:

```bash
# Step 1 — Install gems (they're already in Gemfile)
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  bundle install

# Step 2 — Setup Tailwind
docker run --rm -v $(pwd):/app ai-reconciliation-analyst:dev \
  rails tailwindcss:install

# Step 3 — Test
docker build -t ai-reconciliation-analyst:v0.1.0-scaffold .
docker run --rm -p 3000:3000 ai-reconciliation-analyst:v0.1.0-scaffold &
sleep 3 && curl http://localhost:3000

# Step 4 — Kill
pkill -f "puma"

# Step 5 — Commit and tag
git add .
git commit -m "chore: rails 7.1 with hotwire, tailwind, httparty (docker-first)"
git tag v0.1.0-scaffold
git push origin main --tags
```

---

## Expected Output

**After `bundle install`:**
```
Bundle complete!
```

**After `rails tailwindcss:install`:**
```
      create  app/assets/stylesheets/application.tailwind.css
      create  config/tailwind.config.js
      create  Procfile.dev
```

**After curl test:**
```html
<!DOCTYPE html>
<html>
  <head>
    <title>Rails</title>
    ...
  </head>
```

---

## Summary

**The fix:** Skip `bundle add` (gems already exist). Just run `bundle install`.

**Why:** Your Gemfile already has tailwindcss-rails, httparty, and dotenv-rails from the previous Step 4.

**Result:** Gems install cleanly, Tailwind setup works, Rails runs.

Proceed with the three commands above ✓
