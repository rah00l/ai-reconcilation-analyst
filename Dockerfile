FROM ruby:3.2-bookworm

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libsqlite3-dev \
      libpq-dev \
      postgresql-client \
      curl \
      ca-certificates \
      npm \
      nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile ./
COPY Gemfile.lock* ./

RUN bundle install --jobs 4 --retry 3

COPY . .

# CRITICAL: Force Tailwind installation with --force to ensure complete setup
# --force overwrites if exists, || true ignores error if already configured
RUN bundle exec rails tailwindcss:install --force || true

# CRITICAL: Remove old/incomplete assets before precompilation
# This ensures clean compilation with all files
RUN bundle exec rails assets:clobber

# CRITICAL: Precompile assets for production deployment
# This creates all CSS/JS files in public/assets/ with correct manifest
RUN bundle exec rails assets:precompile

EXPOSE 8080

ENV RAILS_ENV=production
ENV PORT=8080

# Run migrations and start server
CMD bash -c "sleep 5 && bundle exec rails db:prepare && bundle exec rails server -b 0.0.0.0 -p ${PORT:-8080}"
