namespace :php do
  namespace :composer do
    desc 'Installs dependencies from composer.'
    task :install do
      on roles(:web) do
        within release_path do
          execute :composer, :install, '--optimize-autoloader'
        end
      end
    end
  end

  namespace :apache do
    desc 'Sets an apache config'
    task :config do
      on roles(:web) do
        template = 'lib/capistrano/templates/apache_config.erb'
        erb = nil

        on(:local) do
          erb = File.read template
        end

        home = "/home/#{capture(:whoami)}"
        location = release_path.sub(/^\$HOME/, home)
        set :location, location

        apache = ERB.new(erb, nil, '-').result(binding)
        app = fetch(:application).downcase
        set :app, app

        within '/etc/apache2/sites-available/' do
          temp_path = '/tmp/apache_config'
          dest_path = "#{app}.conf"

          upload! StringIO.new(apache), temp_path

          execute :chmod, '644', temp_path
          execute :sudo, :mv, temp_path, dest_path
        end

        # TODO: Check our isn't already active.
        # TODO: Disallow all actives.

        # Active our.
        execute :sudo, :a2ensite, app
        execute :sudo, :service, :apache2, :restart
      end
    end
  end
end
