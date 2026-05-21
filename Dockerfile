FROM ruby:3.2-bookworm

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libsqlite3-dev \
      libpq-dev \
      postgresql-client \
      curl \
      ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile ./
COPY Gemfile.lock* ./

RUN bundle install --jobs 4 --retry 3

COPY . .

RUN if [ ! -f config/tailwind.config.js ]; then \
      bundle exec rails tailwindcss:install; \
    fi

EXPOSE 8080

ENV RAILS_ENV=production
ENV PORT=8080

# Rails web server - runs migrations on startup
# Listens on port 8080 for Railway health checks
# No rackup command - that's for Sinatra engine (different repo)
CMD bash -c "sleep 5 && bundle exec rails db:prepare && bundle exec rails server -b 0.0.0.0 -p ${PORT:-8080}"
