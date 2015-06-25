lock '3.3.5'

set :application, 'app'
set :repo_url, 'git@bitbucket.org:marcinbiegun/ktorzadzi.git'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :use_sudo, false
set :bundle_binstubs, nil
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  task :restart do
    invoke 'unicorn:stop'

    on roles(:all) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "memcached:flush"
        end
      end
    end

    invoke 'unicorn:start'
  end
end
