1st - 
# Step 0 — Create project directory (no Ruby needed)
mkdir ai-reconcilation-analyst
cd ai-reconcilation-analyst
git init
git branch -M main

# Step 1 — Create Dockerfile for scaffolding ONLY
# (temporary — used only to run rails new)
cat > Dockerfile.scaffold << 'EOF'
FROM ruby:3.2-slim
RUN apt-get update -qq && apt-get install -y \
  build-essential nodejs npm
WORKDIR /app
RUN gem install rails
EOF

# Step 2 — Run rails new inside Docker container
docker build -f Dockerfile.scaffold -t rails-scaffold .
docker run --rm -v $(pwd):/app rails-scaffold \
  rails new . --database=sqlite3 --skip-test

# Step 3 — Now Gemfile exists locally. Add our gems via Docker
cat > Dockerfile.dev << 'EOF'
FROM ruby:3.2-slim
RUN apt-get update -qq && apt-get install -y \
  build-essential libsqlite3-dev curl nodejs npm
WORKDIR /app
COPY Gemfile Gemfile.lock ./ # Rails new created these
RUN bundle install
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
EOF

# Step 4 — Build dev image and add gems inside Docker
docker build -f Dockerfile.dev -t reconciliation-app:dev .
docker run --rm -v $(pwd):/app reconciliation-app:dev \
  bundle add tailwindcss-rails httparty dotenv-rails

# Step 5 — Run tailwind install inside Docker
docker run --rm -v $(pwd):/app reconciliation-app:dev \
  rails tailwindcss:install

# Step 6 — Clean up scaffold Dockerfile (not needed anymore)
rm Dockerfile.scaffold
mv Dockerfile.dev Dockerfile

# Step 7 — Verify everything works
docker build -t reconciliation-app:v0.1.0-scaffold .
docker run --rm -p 3000:3000 reconciliation-app:v0.1.0-scaffold
# Visit http://localhost:3000 — Rails runs inside Docker

# Step 8 — Git commit (now all files exist locally)
git add .
git commit -m "chore: rails new with tailwind (Docker-first)"


2nd -

# Step 1 — Create empty project folder
mkdir ai-reconcilation-analyst
cd ai-reconcilation-analyst
git init

# Step 2 — Run rails new inside Docker (no Ruby needed locally)
docker run --rm -v $(pwd):/app ruby:3.2-slim \
  bash -c "gem install rails:~7.1 && \
    rails new . --database=sqlite3 --skip-test --skip-javascript"

# Step 3 — Create your Dockerfile (for app + gems)
cat > Dockerfile << 'EOF'
FROM ruby:3.2-slim
RUN apt-get update -qq && apt-get install -y build-essential libsqlite3-dev nodejs npm
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
EOF

# Step 4 — Add gems inside Docker (no local bundle install)
docker build -t app:dev .
docker run --rm -v $(pwd):/app app:dev \
  bundle add tailwindcss-rails httparty dotenv-rails

# Step 5 — Run tailwind setup inside Docker
docker run --rm -v $(pwd):/app app:dev rails tailwindcss:install

# Step 6 — Test it works
docker build -t app:v0.1.0-scaffold .
docker run --rm -p 3000:3000 app:v0.1.0-scaffold &
sleep 3 && curl http://localhost:3000  # Should work

# Step 7 — Commit (all files now exist locally)
git add .
git commit -m "chore: rails new with tailwind (Docker-first)"