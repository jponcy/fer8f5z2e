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
        location = fetch(:deploy_to).sub(/^\$HOME/, home)
        set :location, location

        apache = ERB.new(erb, nil, '-').result(binding)
        set :app, fetch(:application).downcase

        temp_path = '/tmp/apache_config'
        upload! StringIO.new apache, temp_path
        dest_path = "/etc/apache/site-available/#{fetch(:app)}"
        execute :sudo, :mv, temp_path, dest_path
      end
    end
  end
end
