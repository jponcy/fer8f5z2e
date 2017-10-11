# config valid only for current version of Capistrano
lock '3.7.2'

set :application, 'Lister'
set :repo_url, 'https://github.com/jponcy/fer8f5z2e.git'
# set :repo_url, 'jonathan@127.0.0.1:/home/jonathan/temp/testTP/git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '$HOME/symfony/Lister'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'
append :linked_files, 'app/config/parameters.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: '/opt/ruby/bin:$PATH' }

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do
  before 'check:linked_files', 'symfony:parameters'

  after :updated, 'php:composer:install'
end
