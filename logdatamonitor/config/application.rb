require_relative 'boot'

require 'rails/all'
require './lib/form_builder.rb'

require './lib/rails_log_parser'
require './lib/parse_nginx'
require './lib/format'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Logdatamonitor
  class Application < Rails::Application
    config.i18n.default_locale = :ru
    config.time_zone = 'Moscow'
  end
end
