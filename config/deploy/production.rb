set :port, 22
set :user, 'app'
set :deploy_via, :remote_cache
set :use_sudo, false

set :branch, 'master'

server 'ktorzadzi.pl',
  roles: [:web, :app, :db],
  port: fetch(:port),
  user: fetch(:user),
  primary: true

set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(publickey),
  user: 'app',
}

set :rails_env, :production
set :conditionally_migrate, true
