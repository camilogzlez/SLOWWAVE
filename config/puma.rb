max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Bind Puma to the correct address and port for Fly.io
bind "tcp://0.0.0.0:3000"

# Set the environment
environment ENV.fetch("RAILS_ENV") { "development" }

plugin :tmp_restart
