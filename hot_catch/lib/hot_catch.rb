module HotCatch
  require 'hot_catch/hard_worker'
  require 'hot_catch/nginx_system_worker'
  require 'hot_catch/custom_log_subscribers.rb'
  require 'hot_catch/receive_nginx_logs.rb'
  require 'hot_catch/get_system_metrics'

  require 'uri'
  require 'net/https'
  require 'json'

  # ======================================================================
  # Для использования нужно:
  # 1. Править файл hot_catch_config.json для указания url нужного сервера
  # 2. sender_logs = HotCatch::MakeHttpsRequest.new
  # 3. Сформировать сообщение на примере:
  # ====================================
    # body_log = {main_hot_catch_log: {
    #   "log_data":"some message",
    #   "name_app":"my_app",
    #   "from_log":"Rails"}
    # }
  # ====================================
  # 4. sender_logs.send_log(body_log)
  # 5. Ошибки доступны в файле hot_catch_log_response_errors
  # ======================================================================

  # Отвечает за отправку логов на главное приложение
  class MakeHttpsRequest
    def initialize(url = nil, try_count = 0)
      @try_count = try_count
      @url = url
      unless @url
        File.open("config/hot_catch_config.json"){ |file| @url = JSON.parse(file.read)["url"] }
        @url += "/main_hot_catch_logs"
      end
    end

    def rails_g_log(log_data, status)
      body_log = {main_hot_catch_log:
        {
          "log_data":log_data,
          "name_app":Rails.application.class.parent_name,
          "from_log":"Rails",
          "status":status
        }
      }
      HardWorker.perform_async(body_log, @url, @try_count)
    end

    def nginx_g_log(log_data)
      body_log = {main_hot_catch_log:
        {
          "log_data":log_data,
          "name_app":Rails.application.class.parent_name,
          "from_log":"Nginx"
        }
      }
      HardWorker.perform_async(body_log, @url, @try_count)
    end

    def system_g_log(log_data)
      body_log = {main_hot_catch_log:
        {
          "log_data":log_data,
          "name_app":Rails.application.class.parent_name,
          "from_log":"System"
        }
      }
      HardWorker.perform_async(body_log, @url, @try_count)
    end

    def send_log(body_log)
      response = call(@url, body_log)
      # если на запрос пришёл ответ, то пришло уведомление об ошибке, которое логируется
      # Кроме того данное сообщение помещается в очередь и отправляется через какое-то время
      unless response.to_s.empty?
        str = "\n" + (?-*20) + "\n#{Time.now}\nlogs:\n#{body_log.to_s}\nresponse\n:#{response}\n" + (?-*20) + "\n"
        File.open("log/hot_catch_log_response_errors", 'a'){ |file| file.write str.encode('UTF-8', {
          :invalid => :replace,
          :undef   => :replace,
          :replace => '?'
        }) }
      end
    end

    private

    def call(url, hash_json)
      uri = URI.parse(url)
      req = Net::HTTP::Post.new(uri.to_s)
      req.body = hash_json.to_json
      req['Content-Type'] = 'application/json'
      response = https(uri).request(req)
      JSON.parse(response.body).inspect if response.body.present?
    end

    def https(uri)
      Net::HTTP.new(uri.host, uri.port).tap do |http|
        if uri.to_s =~ /^https/
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end
    end
  end
end
