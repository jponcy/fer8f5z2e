require 'erb'

namespace :symfony do
  def symfony(command, *parameters)
    # params = [parameters].flatten
    # linea = [:php, 'app/console', command, *params]
    # execute(*linea)
    execute :php, 'app/console', command, *parameters
  end

  def remote_file_exists?(full_path)
    capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip == 'true'
  end

  desc '(re)start the symfony embeded server'
  task :embeded_server do
    on roles(:web) do
      within release_path do
        host = '127.0.0.1:8099'
        error = '> /dev/null 2>&1 &'

        %w[stop start].each do |command|
          symfony "server:#{command}", host, error
          sleep 1
        end

        SSHKit.config.output.info "Server should be available on: #{host}"
      end
    end
  end

  desc 'Regen DB with fixtures'
  task :init_database do
    on roles(:db) do
      within release_path do
        symfony 'doctrine:database:drop', '--force', '-q'
        symfony 'doctrine:database:create', '-n'
        symfony 'doctrine:schema:create'
        symfony 'doctrine:fixture:load', '-n'
      end
    end
  end

  desc 'Sets ACL rights.'
  task :rights do
    on roles(:web) do
      within release_path do
        http_user = capture("ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\\  -f1")

        sudo :setfacl, '-R', '-m', "u:'#{http_user}':rwX -m u:`whoami`:rwX app/cache app/logs"
        sudo :setfacl, "-dR -m u:'#{http_user}':rwX -m u:`whoami`:rwX app/cache app/logs"
      end
    end
  end

  desc 'Clears the production caches.'
  task :cache_prod do
    on roles(:web) do
      within release_path do
        symfony 'cache:clear', '-e', 'prod'
      end
    end
  end

  desc 'Initialize parameters file if not exists'
  task :parameters, :mode do |_, args|
    on roles(:web) do
      within shared_path do
        path = fetch(:deploy_to) + '/shared/app/config/parameters.yml'
        forced = (args[:mode] || false) == 'force'

        if !remote_file_exists?(path) || forced
          dist_path = File.expand_path '../app/config/parameters.yml.dist'
          dist = File.read dist_path
          params = dist.scan(/^\s+\b(\w+)\s*:\s*(.+?)\s*$/)

          raise 'No parameter into ' + dist_path if params.size <= 0

          # Ask to user to check all values -- one by one.
          param_values = params.map do |key, default|
            set :temp, ask(key, default)
            value = fetch(:temp)
            "    #{key}: #{value}"
          end

          # Finalize content.
          content = "parameters:\n" + param_values.join("\n") + "\n\n"

          # Upload.
          upload! StringIO.new(content), '/tmp/parameters.yml'
          execute :mv, '/tmp/parameters.yml', path
        end
      end
    end
  end
end
