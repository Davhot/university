# rails generate testgem:install

require 'rails/generators'

module HotCatch
  class UninstallGenerator < Rails::Generators::Base
    # include Rails::Generators::Migration

    def remove_rack_logger
      remove_file "config/hot_catch_logger.rb"
    end

    def unchange_files
      gsub_file "config/application.rb", /require_relative 'hot_catch_logger'/, ""
      gsub_file "config/application.rb", /config.*Logger/, ""

      gsub_file "config/environments/development.rb", /.*\s.*hot_catch_buf_file'\)\)\s*/, ""
      gsub_file "config/environments/production.rb", /.*\s.*hot_catch_buf_file'\)\)\s*/, ""
    end

    def remove_log_files
      remove_file "tmp/hot_catch_buf_file"
    end

    def remove_hot_catch_config
      remove_file "config/hot_catch_config.json"
    end

    def remove_initialize_file_for_sender_logs
      remove_file "config/initializers/hot_catch_sender_logs.rb"
    end

    # def remove_sidekiq_job
    #   remove_file "app/workers/hard_worker.rb"
    #   Dir.delete("app/workers")
    # end

  end
end
