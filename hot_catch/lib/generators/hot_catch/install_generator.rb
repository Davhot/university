# rails generate testgem:install

require 'rails/generators'

module HotCatch
  class InstallGenerator < Rails::Generators::Base
     # Включение всех файлов из указанной папки относительно __FILE__ (то есть текущего файла)
    source_root File.expand_path('../../../hot_catch', __FILE__)
    # include Rails::Generators::Migration

    def add_rack_logger
      copy_file "hot_catch_logger.rb", "config/hot_catch_logger.rb"
    end

    def change_files
      insert_into_file "config/application.rb", "\nrequire_relative 'hot_catch_logger'\n",
        :before => "module"

      application "config.middleware.insert_before Rails::Rack::Logger, Rails::Rack::HotCatchLogger\n" +
                  "config.middleware.delete Rails::Rack::Logger"

      insert_string = "\n  require 'hot_catch/custom_log_subscribers.rb'" +
                      "\n  config.logger = ActiveSupport::TaggedLogging" +
                      ".new(ActiveSupport::Logger.new('tmp/hot_catch_buf_file'))\n"

      insert_into_file "config/environments/development.rb", insert_string,
        :after => "Rails.application.configure do"
      insert_into_file "config/environments/production.rb",  insert_string,
        :after => "Rails.application.configure do"
    end

    def add_hot_catch_config
      create_file "config/hot_catch_config.json" do
        "/* http://[url] */
{\"url\":\"[your_server_url]\"}"
      end
    end

    def add_initialize_file_for_sender_logs
      create_file "config/initializers/hot_catch_sender_logs.rb" do
        "require 'sidekiq-cron'\n" +
        "Rails.application.config.sender_logs = HotCatch::MakeHttpsRequest.new\n" +
        "Sidekiq::Cron::Job.create(name: 'NginxSystemWorker - every 1min', cron: " +
        "if Sidekiq.server?\n" +
        " '*/1 * * * *', class: 'NginxSystemWorker')\n" +
        "end\n"
      end
    end

    # def add_sidekiq_job
    #   empty_directory "app/workers"
    #   copy_file "hard_worker.rb", "app/workers/hard_worker.rb"
    # end
  end
end
