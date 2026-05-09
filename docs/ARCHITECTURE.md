# Architecture

## System Overview

The AI Reconciliation Analyst is a hybrid system combining deterministic reasoning (engine) with a web UI layer.
User (Browser)
↓
Rails App (Hotwire + Tailwind)
↓ HTTP POST /analyze
AI Analyst Engine (Sinatra)
↓ Returns ExplanationContract
Turbo Stream Response
↓
Chat Bubble (Real-time update)

## Components

### Rails 7.1 App (Frontend)
- Stimulus JS controllers for chat interactions
- Turbo Streams for real-time updates
- Tailwind CSS for styling
- SQLite database with fictional seed data

### AI Analyst Engine (Backend)
- Deterministic intent resolution
- Knowledge eligibility gates
- Template-based explanations
- Context-aware follow-up projection
- No LLM in core (pure logic)

## Data Flow

1. User types question in chat
2. Stimulus controller captures event
3. Rails sends POST to /analyze endpoint
4. Engine processes question deterministically
5. Returns ExplanationContract JSON
6. Turbo Stream renders chat bubble
7. No page reload (real-time)

## Why This Architecture

- **Deterministic core** — Auditable, reproducible, governs financial workflow
- **Graceful fallback** — LLM can be added later for novel questions (demo layer, not engine)
- **Minimal** — No unnecessary dependencies
- **Fast** — Deterministic reasoning is instant

See [README.md](../README.md) for quick start.
