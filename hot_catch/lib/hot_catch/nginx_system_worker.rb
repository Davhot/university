require 'sidekiq'
# Отвечает за сбор и отправку логов Nginx и системы
class NginxSystemWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false
  def perform
    logs = get_system_metrics()
    sender = HotCatch::MakeHttpsRequest.new
    sender.system_g_log(logs)

    nginx_logs = ReceiveNginxLogs.new
    logs = nginx_logs.get_last_logs
    sender = HotCatch::MakeHttpsRequest.new
    sender.nginx_g_log(logs)
  end
end
