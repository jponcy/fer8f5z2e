# Change deploy area.
set :deploy_to, '$HOME/temp/testTP/staging'

server '127.0.0.1', user: 'jonathan', roles: %w[app db web]

# Specific tasks to do to deploy staging.
namespace :deploy do
  after :updated, :'symfony:init_database'
  after :updated, :'symfony:embeded_server'
end
