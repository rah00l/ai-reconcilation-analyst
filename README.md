# AI Reconciliation Analyst

AI-powered explanation layer for payment reconciliation workflows. Accounting teams ask questions about system states and errors directly within the reconciliation UI and receive intelligent, grounded explanations in real-time.

## What It Does

- **Explains system states** — What does "PARSED" mean? Why is this status showing?
- **Clarifies errors** — What caused "Mapping Error - Payment ID Not Found"?
- **Guides workflow** — What happens after "READY"? Can we proceed?
- **Answers follow-ups** — Does this block reconciliation? Who owns this?

## Architecture

```
┌─────────────────────────────────────────────┐
│     Accounting User (Browser)               │
│     ↓ Types in chat widget                  │
├─────────────────────────────────────────────┤
│  Rails 7.1 App (Hotwire + Tailwind)         │
│  ├─ Stimulus Chat Controller                │
│  ├─ Turbo Streams (real-time updates)       │
│  └─ Engine Client (HTTP calls)              │
│     ↓ POST to /analyze                      │
├─────────────────────────────────────────────┤
│  AI Analyst Engine (Sinatra API)            │
│  ├─ Deterministic intent resolution         │
│  ├─ Knowledge eligibility gates             │
│  ├─ Template-based explanations             │
│  └─ Context-aware follow-up projection      │
│     ↓ Returns JSON contract                 │
├─────────────────────────────────────────────┤
│  Turbo Stream Response                      │
│  └─ Renders structured chat bubble          │
└─────────────────────────────────────────────┘
```

## Quick Start

### Prerequisites
- Docker & Docker Compose (no local Ruby needed)
- Git

### Run Locally

```bash
# Clone
git clone <repo-url>
cd ai-reconciliation-analyst

# Start services
docker compose up

# Visit
http://localhost:3000

# Engine also available at
http://localhost:4567/analyze
```

### Development

```bash
# Build image
docker build -t ai-reconciliation-analyst:latest .

# Run with seed data
docker run --rm -p 3000:3000 ai-reconciliation-analyst:latest
```

## Stack

- **Backend:** Rails 7.1 · Ruby 3.2 · SQLite
- **Frontend:** Hotwire (Stimulus JS + Turbo) · Tailwind CSS
- **Engine:** Sinatra API (v1.0.0 · deterministic reasoning)
- **Deployment:** Docker · Docker Compose · Render.com (production ready)

## Project Structure

```
app/
├── controllers/      # Rails controllers
├── models/          # Data models
├── views/           # HTML templates
└── javascript/      # Stimulus JS
config/
├── database.yml     # PostgreSQL config
├── puma.rb         # Server config (production-ready)
└── environments/   # Dev/test/prod settings
db/
├── migrate/        # Migrations
├── seeds.rb        # Sample data
└── schema.rb       # Current schema
Dockerfile          # Container image
docker-compose.yml  # Services orchestration
```

## Dependencies

### Gems
- **rails 7.1.x** — Web framework
- **tailwindcss-rails** — Styling framework
- **httparty** — HTTP client for engine calls
- **dotenv-rails** — Environment management

### External
- **ai-analyst-engine:v1.0.0** — Reasoning engine (separate repo)
  - Port: 4567
  - Endpoint: `POST /analyze`
  - Returns: ExplanationContract JSON

  ## Features

  - ✅ Real-time chat with Hotwire Turbo Streams
  - ✅ PostgreSQL backend (production-ready)
  - ✅ HTTP Basic Auth + environment-based config
  - ✅ Independent AI reasoning engine (reusable)
  - ✅ Docker containerized (dev ≈ prod)
  - ✅ Health checks for monitoring
  - ✅ Ready for Railway.app deployment

  ## Environment Setup

  ```bash
  # Copy template
  cp .env.example .env

  # Required variables
  RAILS_ENV=production
  SECRET_KEY_BASE=<generated>
  RAILS_MASTER_KEY=<generated>
  HTTP_AUTH_USER=<username>
  HTTP_AUTH_PASSWORD=<password>
  ENGINE_URL=http://engine:4567
  DATABASE_URL=postgresql://...  # Railway provides
  ```

## Testing

### Manual Testing
```bash
# Start services
docker compose up

# Test chat endpoint (from another terminal)
curl -X POST http://localhost:3000/chat \
  -H "Content-Type: application/json" \
  -d '{"question":"What does PARSED mean?"}'

# Expected: Explanation contract JSON
```

## Deployment

### Render.com
1. Connect GitHub repo
2. Set environment variables (from .env)
3. Deploy — automatically runs `docker-compose up`

### Manual Deployment
```bash
# Build production image
docker build -t ai-reconciliation-analyst:v1.0.0 .

# Push to registry
docker tag ai-reconciliation-analyst:v1.0.0 myregistry/ai-reconciliation-analyst:v1.0.0
docker push myregistry/ai-reconciliation-analyst:v1.0.0

# Deploy with docker-compose
docker compose -f docker-compose.yml up -d
```

## Design Principles

1. **Deterministic first** — Engine uses rules, not LLM, for auditability
2. **Graceful fallback** — LLM only when engine can't answer (future enhancement)
3. **Minimal and fast** — Zero local setup, 2-3 min deploy time
4. **Read-only** — UI doesn't mutate reconciliation state
5. **Self-contained** — Engine is independent, can be swapped

## Security

- **No secrets in code** — All credentials via environment variables
- **HTTP Basic Auth** — Built-in Rails authentication
- **.gitignore** — Protects `.env`, `config/master.key`, `credentials.yml.enc`
- **Connection pooling** — PostgreSQL pool=5 for concurrency
- **HTTPS ready** — Enforced in production.rb

## Performance

- **Threads** — Configurable via RAILS_MAX_THREADS (default: 3)
- **Database** — PostgreSQL with connection pool (default: 5)
- **Caching** — Ready for Redis integration
- **Scaling** — Horizontal (container replicas) + Vertical (thread scaling)

## Related

- **Engine Repo:** [ai-analyst-engine](https://github.com/rah00l/ai-analyst-engine)
  - Pure reasoning logic, no UI, reusable
  - Powered by deterministic intent resolution + knowledge gates
  - Can be used standalone or integrated into any application

## License

MIT

## Support

For issues, feature requests, or questions:
1. Check [TASK-SUMMARIES](./docs/TASK-SUMMARIES.md) for architecture decisions
2. Review [docker-compose.yml](./docker-compose.yml) for service configuration
3. Check [.env.example](./.env.example) for required environment variables
