require 'sidekiq'
# Отвечает за отправку логов на главное приложение
class HardWorker
  include Sidekiq::Worker
  def perform(body_log, url, try_count)
    if try_count > 15
      File.open("log/hot_catch_log_response_errors", 'a'){ |file| file.write body_log.encode('UTF-8', {
        :invalid => :replace,
        :undef   => :replace,
        :replace => '?'
      }) }
    else
      sender = HotCatch::MakeHttpsRequest.new(url, try_count + 1)
      sender.send_log(body_log)
      sender = nil
    end
  end

  def cancelled?
    Sidekiq.redis {|c| c.exists("cancelled-#{jid}") }
  end

  def self.cancel!(jid)
    Sidekiq.redis {|c| c.setex("cancelled-#{jid}", 86400, 1) }
  end
end
