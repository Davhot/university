require 'active_support/core_ext/time/conversions'
require 'active_support/core_ext/object/blank'
require 'active_support/log_subscriber'
require 'action_dispatch/http/request'
require 'rack/body_proxy'
# require 'rack/utils'

module Rails
  module Rack
    # Sets log tags, logs the request, calls the app, and flushes the logs.
    #
    # Log tags (+taggers+) can be an Array containing: methods that the +request+
    # object responds to, objects that respond to +to_s+ or Proc objects that accept
    # an instance of the +request+ object.
    class HotCatchLogger < ActiveSupport::LogSubscriber
      def initialize(app, taggers = nil)
        @app          = app
        @taggers      = taggers || []
      end

      def call(env)
        request = ActionDispatch::Request.new(env)

        if logger.respond_to?(:tagged)
          logger.tagged(compute_tags(request)) { call_app(request, env) }
        else
          call_app(request, env)
        end
      end

    protected

      def call_app(request, env)
        instrumenter = ActiveSupport::Notifications.instrumenter
        instrumenter.start 'request.action_dispatch', request: request
        logger.info { started_request_message(request) }
        resp = @app.call(env)
        resp[2] = ::Rack::BodyProxy.new(resp[2]) { finish(request) }
        resp
      rescue Exception
        finish(request)
        raise
      ensure
        ActiveSupport::LogSubscriber.flush_all!
      end

      # Started GET "/session/new" for 127.0.0.1 at 2012-09-26 14:51:42 -0700
      def started_request_message(request)
        'Started %s "%s" for %s at %s' % [
          request.request_method,
          request.filtered_path,
          request.ip,
          Time.now.to_default_s ]
      end

      def compute_tags(request)
        @taggers.collect do |tag|
          case tag
          when Proc
            tag.call(request)
          when Symbol
            request.send(tag)
          else
            tag
          end
        end
      end

      private

      def finish(request)
        # Считали данные из основного лог-файла
        log = ""
        File.open('tmp/hot_catch_buf_file'){ |file| log = file.read}
        File.open('tmp/hot_catch_buf_file', 'w'){ |file| file.print "" }

        # получаем статус из лога
        status = log.match(/!!!(\d{3})!!!/)
        status = status[1] if status
        log.gsub!(/!!!(\d{3})!!!\s/, "")
        # отправляем логи
        Rails.application.config.sender_logs.rails_g_log(log, status) unless log.strip =~ /assets/

        instrumenter = ActiveSupport::Notifications.instrumenter
        instrumenter.finish 'request.action_dispatch', request: request
      end

      def logger
        Rails.logger
      end
    end
  end
end
