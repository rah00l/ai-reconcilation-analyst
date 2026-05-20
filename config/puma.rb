# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers that describe:
#
# The minimum number of threads to use to answer requests.
# The maximum number of threads to use to answer requests.
#
# Generally set to be the number of cores available in a production environment.
# Defaults provided below are appropriate for small to medium sized deployments.
# Larger deployments should consider using more threads and setting RUBY_YJIT_ENABLE=1
#
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `worker_processes` number (usually matches the number of `processors`).
# More workers means more concurrency, but uses more memory.
# For Railway, this should be 1-2 for small apps.
#
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Preload the application before forking worker processes.
# This trades a bit of memory overhead for ~40% faster worker spawn times.
# The default value of `preload_app!` is `false`.
#
preload_app! if ENV.fetch("WEB_CONCURRENCY") { 2 }.to_i > 1

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
port ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch("RAILS_ENV") { "development" }

# Bind to all network interfaces so Railway can reach it
bind "tcp://0.0.0.0:#{ENV.fetch('PORT', 3000)}"

# Specifies an `app` object to run the puma server into the app object instead of
# creating one. This is useful when combining this configuration with other options
# that provide an `app` object.
#
# app Puma::SslWrap.new(
#   Rack::File.new("public"),
#   key_path: "path/to/key.pem",
#   cert_path: "path/to/cert.pem"
# )

# Instead of `preload_app!`, use `fork_worker_processes` to fork off workers
# after the app loads. This option is useful if you plan to use this option
# with other Puma plugins, such as the Datadog plugin. The tradeoff is that
# the app is loaded by each worker process.
#
# fork_worker_processes 2

# Use the `Low Level` socket listening API to improve Puma's options
# then add custom error handlers. In addition to reporting score,
# it also reports the request count.
#
# The default is "webrick".
#
listen_options = { backlog: 1024 }
listen "tcp://0.0.0.0:#{ENV.fetch('PORT', 3000)}", listen_options
listen "unix:///tmp/puma.sock", listen_options

# == Logging ==
#
# Specify an `access_log` file path that Puma will write to.  By default
# Puma will log to STDOUT.
# In production, use STDOUT to let Railway capture logs
#
require "logger"
log_writer = Puma::LogWriter.new(STDOUT)
log_writer.info("Puma starting in #{ENV.fetch('RAILS_ENV', 'development')} mode")

# == SSL Binding ==
#
# ssl_bind '127.0.0.1', '9876', {
#   key: '/path/to/key.pem',
#   cert: '/path/to/cert.pem'
# }

# == State management ==
#
# Save the pid of the server (PID) on startup.
#
pidfile ENV.fetch("PIDFILE") { "tmp/pids/puma.pid" }

# == State persistence ==
#
# Save the state of Puma when a graceful restart is triggered.
# This allows Puma to restore previous worker state on subsequent restarts.
#
# disable_default_trap_handlers: true
# state_path "#{Dir.home}/.puma.state"
