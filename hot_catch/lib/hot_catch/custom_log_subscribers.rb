require 'active_record/log_subscriber'

class CustomActiveRecordLogSubscriber < ActiveRecord::LogSubscriber
  # Убрана подсветка и не логируется таблица hot_catch_buf_file
  def sql(event)
    self.class.runtime += event.duration
    return unless logger.debug?

    payload = event.payload

    return if IGNORE_PAYLOAD_NAMES.include?(payload[:name])

    name  = "#{payload[:name]} (#{event.duration.round(1)}ms)"
    sql   = payload[:sql]
    binds = nil

    unless (payload[:binds] || []).empty?
      casted_params = type_casted_binds(payload[:type_casted_binds])
      binds = "  " + payload[:binds].zip(casted_params).map { |attr, value|
        render_bind(attr, value)
      }.inspect
    end

    # name = colorize_payload_name(name, payload[:name])
    # sql  = color(sql, sql_color(sql), true)

    debug "  #{name}  #{sql}#{binds}" unless payload[:sql].to_s =~ /hot_catch_logs|COMMIT|BEGIN|Rendering|Rendered/i
  end
end

# Отписка от уведомлений ActiveRecord::LogSubscriber
notifier = ActiveSupport::Notifications.notifier
subscribers = notifier.listeners_for("sql.active_record")
subscribers.each {|s| ActiveSupport::Notifications.unsubscribe s }

# Подписка на уведомления CustomActiveRecordLogSubscriber
CustomActiveRecordLogSubscriber.attach_to :active_record
# ====================================================================================
require 'action_controller/log_subscriber'

class CustomActionControllerLogSubscriber < ActionController::LogSubscriber
  # Статус записывается в лог файл hot_catch_buf_file
  def process_action(event)
    payload   = event.payload
    additions = ActionController::Base.log_process_action(payload)

    status = payload[:status]
    if status.nil? && payload[:exception].present?
      exception_class_name = payload[:exception].first
      status = ActionDispatch::ExceptionWrapper.status_code_for_exception(exception_class_name)
    end

    File.open('tmp/hot_catch_buf_file', 'a'){ |file| file.puts "!!!#{status}!!!" }

    info do

      message = "Completed #{status} #{Rack::Utils::HTTP_STATUS_CODES[status]} in #{event.duration.round}ms"
      message << " (#{additions.join(" | ")})" unless additions.blank?
      message
    end
  end
end

subscribers = notifier.listeners_for("process_action.action_controller")
subscribers.each {|s| ActiveSupport::Notifications.unsubscribe s }

CustomActionControllerLogSubscriber.attach_to :action_controller
