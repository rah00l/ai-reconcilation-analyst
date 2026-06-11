# ReconPilot AI

> AI Analyst Assistant for Affiliate Payment Reconciliation — powered by Anthropic Claude API with RAG architecture.

[![Live on Railway](https://img.shields.io/badge/Live%20Demo-Railway-6B21A8?style=flat&logo=railway&logoColor=white)](https://reconpilot-ai.up.railway.app)
[![Deploy Status](https://img.shields.io/badge/deploy-live-brightgreen?style=flat)](https://reconpilot-ai.up.railway.app)
[![Ruby on Rails](https://img.shields.io/badge/Rails-7.x-CC0000?style=flat&logo=rubyonrails&logoColor=white)](https://rubyonrails.org)
[![Python](https://img.shields.io/badge/Python-3.x-3776AB?style=flat&logo=python&logoColor=white)](https://python.org)
[![Docker](https://img.shields.io/badge/Docker-multi--service-2496ED?style=flat&logo=docker&logoColor=white)](https://docker.com)
[![Anthropic Claude](https://img.shields.io/badge/LLM-Anthropic%20Claude-6B21A8?style=flat)](https://anthropic.com)
[![CI](https://github.com/rah00l/ai-reconcilation-analyst/actions/workflows/ci.yml/badge.svg)](https://github.com/rah00l/ai-reconcilation-analyst/actions/workflows/ci.yml)

---

## Demo

![ReconPilot AI Demo](demo/reconpilot-demo.gif)

🔗 **[View Live App →](https://reconpilot-ai.up.railway.app)**

---

## What It Does

ReconPilot is the **AI capability layer** built on top of a production affiliate payment reconciliation platform. It enables accounting and operations teams to interact with reconciliation data in natural language — replacing hours of manual report analysis with a conversational AI interface.

- **Ask questions** — *"Show discrepancies for October"* / *"Which affiliates have unmatched transactions?"*
- **Surface discrepancies** — AI reasons over reconciliation rules and flags mismatches
- **Audit-trail explanations** — plain-language summaries of why a transaction is flagged
- **Follow-up suggestions** — chatbot proactively suggests next actions based on context
- **Session continuity** — multi-turn conversation maintains context across queries

---

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                    Railway (Cloud)                   │
│                                                     │
│  ┌──────────────────┐    ┌─────────────────────┐   │
│  │  Rails 7.x App   │───▶│  Sinatra AI Engine  │   │
│  │  (Web + UI)      │    │  (Reasoning Layer)  │   │
│  └──────────────────┘    └─────────┬───────────┘   │
│           │                        │               │
│  ┌────────▼──────┐        ┌────────▼───────────┐   │
│  │  PostgreSQL   │        │  Anthropic Claude  │   │
│  │  (Data Store) │        │  API  (LLM)        │   │
│  └───────────────┘        └────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

Each service is independently containerised with **Docker** and deployable separately.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Web Application | Ruby on Rails 7.x |
| AI Reasoning Engine | Sinatra + Python + FastAPI |
| LLM | Anthropic Claude API |
| RAG Pipeline (Phase 2) | LangChain + ChromaDB + OpenAI Embeddings |
| Database | PostgreSQL |
| Frontend | Tailwind CSS (fully responsive) |
| Containerisation | Docker (multi-service) |
| Deployment | Railway |

---

## Roadmap

- [x] **Phase 1** — Rule-based reconciliation engine (live)
- [x] **Phase 1** — Anthropic Claude API chatbot with session continuity
- [x] **Phase 1** — Multi-service Docker architecture deployed on Railway
- [ ] **Phase 2** — LangChain + ChromaDB vector database pipeline
- [ ] **Phase 2** — OpenAI Embeddings for semantic search over reconciliation data
- [ ] **Phase 3** — Role-based access for accounting vs operations teams

---

## Background

ReconPilot is the AI extension of a production reconciliation platform built during the **Intelliswift / Incentive Networks (Tenerity)** engagement. The domain expertise — reconciliation rules, transaction matching, affiliate payment flows — was developed over 3+ years of production work and forms the knowledge base for AI-assisted reasoning in this system.

---

## Local Setup

```bash
# Clone the repo
git clone https://github.com/rah00l/ai-reconcilation-analyst.git
cd ai-reconcilation-analyst

# Copy environment variables
cp .env.example .env
# Add your ANTHROPIC_API_KEY to .env

# Start all services with Docker
docker-compose up --build

# App runs at http://localhost:3000
```

> Requires Docker and a valid `ANTHROPIC_API_KEY` in your `.env` file.

---

## Author

**Rahul Patil** — Senior Software Engineer / AI Engineer
[LinkedIn](https://linkedin.com/in/rahulpatil2387) · [GitHub](https://github.com/rah00l) · [Blog](https://rah00l.github.io)
