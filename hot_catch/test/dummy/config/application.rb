require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

require "hot_catch"

require_relative 'hot_catch_logger'

module Dummy
  class Application < Rails::Application
    config.middleware.insert_before Rails::Rack::Logger, Rails::Rack::HotCatchLogger

    config.middleware.delete Rails::Rack::Logger
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
