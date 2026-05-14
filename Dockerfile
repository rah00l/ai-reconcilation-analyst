FROM ruby:3.2-bookworm

# Set working directory early
WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libsqlite3-dev \
      curl \
      ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy Gemfile first for better caching
COPY Gemfile ./
COPY Gemfile.lock* ./

# Install Ruby gems
RUN bundle install --jobs 4 --retry 3

# Copy application code
COPY . .

# ============================================
# IMPORTANT: Run Rails generators in Docker
# ============================================
# This ensures generated files are in image
# and available for development

# Only run if config doesn't exist (prevents re-running)
RUN if [ ! -f config/tailwind.config.js ]; then \
      bundle exec rails tailwindcss:install; \
    fi

# Expose port
EXPOSE 3000

# Use ENTRYPOINT for consistency
ENTRYPOINT ["bundle", "exec"]

# Default command (can be overridden in docker-compose)
CMD ["rails", "server", "-b", "0.0.0.0"]