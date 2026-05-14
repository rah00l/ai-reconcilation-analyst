# Architectural Decisions

## Decision 1: Rails 7.1 (not 8.0)
**Chosen:** Rails 7.1.x (LTS)
**Rationale:** Production stability > cutting edge. LTS support until 2027. No gem compatibility issues.

## Decision 2: Ruby 3.2-bookworm (not 3.2-slim or trixie)
**Chosen:** ruby:3.2-bookworm
**Rationale:** Stable Debian mirrors, includes build tools, reliable for production.

## Decision 3: Hotwire (Stimulus + Turbo)
**Chosen:** Native Rails 7 Hotwire
**Rationale:** Perfect for real-time chat without full SPA complexity. Ships with Rails 7.

## Decision 4: Tailwind CSS
**Chosen:** tailwindcss-rails gem
**Rationale:** Fast, minimal, native Rails integration, no webpack complexity.

## Decision 5: Importmap (not webpack)
**Chosen:** Importmap (Rails 7 default)
**Rationale:** No yarn/webpack bloat. JavaScript bundling via import maps.

## Decision 6: SQLite (not PostgreSQL)
**Chosen:** SQLite with db/seeds.rb
**Rationale:** Development-focused, no database overhead, seed data for local testing.

## Decision 7: Engine as separate service
**Chosen:** Sinatra API (v1.0.0) via docker-compose
**Rationale:** Independent reasoning logic, reusable, can be upgraded separately.

## Decision 8: Git branching strategy
**Chosen:** Task 1 direct to main, Tasks 2-7 feature branches
**Rationale:** Task 1 is foundational (no prior task). Features use branches for professional audit trail.


## A.1: Tailwindcss Integration

### Decision: Use tailwindcss-rails v2.x

**Why not v4.4:**
- v4.4 is designed for Node.js workflows
- Requires explicit --input/--output CLI parameters
- Complex manual build process
- Not Rails-native

**Why v2.x:**
- Designed specifically for Rails asset pipeline
- Automatic CSS generation
- Rails generators integration (rails tailwindcss:install)
- Simple, professional workflow
- Industry standard for Rails + Tailwindcss

### Docker-First Development

**Volume Sync:**
- Local ↔ Container: Automatic via `volumes: - .:/app`
- One-time generators create files that sync automatically
- After git commit, files persist across rebuilds

**Workflow:**
1. Generate in Docker container
2. Files auto-sync to local (via volumes)
3. Commit to git
4. Future rebuilds pull from git (no generator needed)

### Key Learnings

- "Latest version" ≠ "Best version"
- Check framework compatibility, not just version numbers
- Docker volumes provide bidirectional sync
- Generators only need to run once if files are committed