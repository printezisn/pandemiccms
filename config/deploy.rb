# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.19.2'

set :application, 'pandemiccms'
set :repo_url, 'git@github.com:printezisn/pandemiccms.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/myuser/pandemiccms'

set :rbenv_type, :user
set :rbenv_ruby, '3.4.5' # your installed version

set :puma_user, fetch(:user)
set :puma_role, :web
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_systemd_watchdog_sec, 10 # Set to 0 or false to disable watchdog
set :puma_service_unit_env_files, []
set :puma_service_unit_env_vars, []

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/credentials/production.key', 'config/puma.rb'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"
append :linked_dirs, 'log', 'storage', 'db/storage', 'tmp/sockets', 'tmp/pids', 'tmp/cache', 'public/system', 'vendor'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :default_env, { path: '$HOME/.nvm/versions/node/v22.18.0/bin:$PATH' }
