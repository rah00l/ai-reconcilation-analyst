
## Quick Start

### First Time Setup
```bash
# 1. Clone both repos in same directory
mkdir ai-reconciliation-project
cd ai-reconciliation-project

git clone <rails-repo-url> ai-reconciliation-analyst
git clone <engine-repo-url> ai-analyst-engine

# 2. Go to Rails directory
cd ai-reconciliation-analyst

# 3. Start both services
docker compose up

# 4. Wait for both to start
# You should see:
# - "Rails server listening on 0.0.0.0:3000"
# - "Sinatra server listening on 0.0.0.0:4567"
```

### Access Services
- Rails App: http://localhost:3000
- Engine Endpoint: http://localhost:4567/analyze

### Subsequent Runs
```bash
cd ai-reconciliation-analyst
docker compose up
```

## Common Commands

### Stop Services
```bash
docker compose down
```

### Rebuild Services (after code changes to Dockerfile)
```bash
docker compose build
docker compose up
```

### View Logs
```bash
docker compose logs -f web      # Rails logs
docker compose logs -f engine   # Engine logs
docker compose logs -f          # Both
```

### Clean Up
```bash
docker compose down -v  # Remove volumes too
```

## Troubleshooting

### Port Already in Use
```bash
# Change ports in docker-compose.yml
ports:
  - "3001:3000"  # Changed from 3000
  - "4568:4567"  # Changed from 4567
```

### Engine Service Won't Start
```bash
# Check Engine repo has Dockerfile
ls ../ai-analyst-engine/Dockerfile

# Check Engine repo structure
docker compose logs engine
```

### Rails Can't Connect to Engine
```bash
# Check environment variable
docker compose exec web env | grep ENGINE_URL
# Should show: ENGINE_URL=http://engine:4567

# Check if engine is running
curl http://localhost:4567/analyze
```

## Production Deployment
For production (Render.com):
- Deploy Rails service separately
- Deploy Engine service separately
- Set ENGINE_URL environment variable in Rails service
- See DEPLOYMENT.md for details
