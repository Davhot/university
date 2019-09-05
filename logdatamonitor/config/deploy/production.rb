server '77.37.218.243', user: 'david', roles: %w{app db}, port: 8000

set :branch, ENV['branch'] || 'develop'

set :default_env, {
  'RAILS_ENV': 'production'
}
