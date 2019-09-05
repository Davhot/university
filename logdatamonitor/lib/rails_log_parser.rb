require 'active_support/all'

class RailsLogParser
  STATUSES = ["STATUS", "SUCCESS", "REDIRECTION", "CLIENT_ERROR", "SERVER_ERROR", "WARNING", "UNKNOWN"]

  # Метод для сравнения логов
  def strip_str(str)
    str = str.dup
    str.gsub!(/\d+(\.\d+)?ms/, "TIME") # За сколько выполнилось действие
    str.gsub!(/\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\s\+\d{4}/, "DATE") # дата
    str.gsub!(/:0x[\d|\w]+>/, "") # Область памяти объекта (например #<StaticPagesController:0x007f37791686d8>)
    str.gsub!(/(\d{1,3}\.){3}\d{1,3}(:\d*)?/, "IP")
    str = str.split("\n").select{|x| x.present?}.join("\n") # убирает повторяющиеся переводы строки
    str.strip! # лишние символы пропусков в начале и конце
    str
  end

  def get_status(log, status)
    if status.present?
      status = STATUSES[status[0].to_i - 1]
    else
      status = (log =~ /ActionController/) ? STATUSES[3] : STATUSES[-1]
    end
    status
  end

  def get_ip_and_date(str)
    ip_from_log = str.match(/((\d{1,3}\.){3}\d{1,3}(:\d*)?)/).try("[]", 1) || 'localhost'
    date_from_log = str.match(/(\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\s\+\d{4})/).try("[]", 1)
    [ip_from_log, date_from_log]
  end
end
