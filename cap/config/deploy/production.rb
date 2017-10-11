server '127.0.0.1:2222', user: 'dev', roles: %w[app db web], ssh_options: {
  port: 2222,
  keys: %w[/home/jonathan/.ssh/id_rsa],
  forward_agent: false,
  auth_methods: %w[publickey password]
}

# Specific tasks to do to deploy production.
namespace :deploy do
  after :updating, 'symfony:create_db_manually'

  after :updated, 'symfony:rights'
  after :updated, 'symfony:cache_prod'
  after :updated, 'php:apache:config'
end
