# config valid only for current version of Capistrano
lock '3.7.2'

set :application, 'Lister'
set :repo_url, 'https://github.com/jponcy/fer8f5z2e.git'
set :keep_releases, 3

# Default deploy area into user directory.
set :deploy_to, '$HOME/symfony/Lister'

# Share.
append :linked_files, 'app/config/parameters.yml'

# Tasks to do to deploy for all stages.
namespace :deploy do
  before 'check:linked_files', 'symfony:parameters'

  after :updated, 'php:composer:install'
end
