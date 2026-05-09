FROM ruby:3.2-bookworm
RUN apt-get update -qq && \
    apt-get install -y \
      build-essential libsqlite3-dev curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]