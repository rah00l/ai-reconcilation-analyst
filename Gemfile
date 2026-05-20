source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ============================================================================
# CORE RAILS & SERVER
# ============================================================================

gem "rails", "~> 7.2.3", ">= 7.2.3.1"
gem "puma", ">= 5.0"
gem "bootsnap", require: false

# ============================================================================
# DATABASE
# ============================================================================

gem 'pg', '~> 1.5'

# ============================================================================
# FRONTEND & ASSETS
# ============================================================================

gem "sprockets-rails"
gem "tailwindcss-rails", "~> 4.4"
gem "jbuilder"

# ============================================================================
# API & HTTP COMMUNICATION
# ============================================================================

# HTTP client for calling external APIs (AI Analyst Engine)
# Used in EngineClient to make requests to Sinatra engine
gem "httparty", "~> 0.24.2"

# ============================================================================
# CONFIGURATION & UTILITIES
# ============================================================================

# Environment variable management from .env files
# Loads ENV variables in development from .env file
gem "dotenv-rails", "~> 3.2"

# Timezone support for Windows and JRuby
gem "tzinfo-data", platforms: %i[ windows jruby ]

# ============================================================================
# DEVELOPMENT & TESTING
# ============================================================================

group :development, :test do
  # Debugging support for Rails console
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Security vulnerability scanner
  gem "brakeman", require: false

  # Ruby code style checker (Rails-specific omakase preset)
  gem "rubocop-rails-omakase", require: false
end

# ============================================================================
# DEVELOPMENT ONLY
# ============================================================================

group :development do
  # Interactive Rails console enhancements
  gem "web-console"
end

# ============================================================================
# PRODUCTION-SPECIFIC (Uncomment when deploying)
# ============================================================================

# Uncomment for production deployment:
# gem "redis", ">= 4.0.1"  # For caching and Action Cable in production
# gem "kredis"            # High-level Redis data structures
# gem "bcrypt", "~> 3.1.7"  # Password encryption
