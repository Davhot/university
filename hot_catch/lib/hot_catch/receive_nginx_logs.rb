require_relative './time'
=begin
  Принцип получения логов (сделано так, чтобы не потерять логи за секунду между интервалами выборок):
  1. Время последнего получения логов хранится в файле tmp/hot_catch_from_time.txt
  2. Сами логи хранятся в файле log/nginx.access.log
  3. Логи берутся от времени последнего получения логов минус одна секунда и до лога
    время которого меньше текущего минус одна секунда
    (интервал смещён для точной передачи всех данных за время t - 1 секунда)
  4. Если нет файла tmp/hot_catch_from_time.txt или он пустой, берутся все логи
    от начала до последнего лога, время которого меньше текущего минус одна секунда.
=end
class ReceiveNginxLogs
  attr_accessor :last_get_logs_time_filename, :input_filename, :format_datetime_logs,
    :regexp_datetime_logs

  SinceDatetimeGetLogsFormat = "%Y-%m-%d %H:%M:%S %z"

  def initialize
    @last_get_logs_time_filename = 'tmp/hot_catch_from_time.txt'
    @input_filename = 'log/nginx.access.log'
    @format_datetime_logs = "%d/%b/%Y:%H:%M:%S %z"
    @regexp_datetime_logs = /\d{2}\/\w+\/\d{4}:\d{2}:\d{2}:\d{2}\s\+\d{4}/
    @delta_get_logs = 1.seconds
    @logs = []
    @since_datetime_get_logs = nil
  end

  def get_last_logs
    read_logs
    cut_logs
    @logs.join("")
  end

  private

  def read_logs
    if File.exist?(@input_filename)
      @logs = File.open(@input_filename, 'r'){|file| file.readlines}
    else
      []
    end
  end

  def cut_logs
    current_time = Time.now
    if @logs.present?
      if get_time.present?
        search_index = search_index_from_logs_since_get_logs
        @logs = search_index ? @logs[search_index..-1] : []
      end
      search_index = search_index_for_delta(current_time)
      @logs = search_index ? @logs[0..search_index] : []
      File.open(@last_get_logs_time_filename, 'w'){|file| file.write current_time.strftime(SinceDatetimeGetLogsFormat)}
    end
  end

  def get_time
    if File.exist?(@last_get_logs_time_filename)
      @since_datetime_get_logs = File.open(@last_get_logs_time_filename, 'r'){|file| file.read }
      # safe_strptime in lib/hot_catch/time.rb
      @since_datetime_get_logs = Time.safe_strptime(@since_datetime_get_logs, SinceDatetimeGetLogsFormat)
    end
    @since_datetime_get_logs
  end

  def search_index_from_logs_since_get_logs
    search_index = nil
    (@logs.size - 1).downto(0) do |index|
      current_log_datetime = Time.strptime(@logs[index].match(@regexp_datetime_logs)[0], @format_datetime_logs)
      if @since_datetime_get_logs <= (current_log_datetime - @delta_get_logs)
        search_index = index
      else
        break
      end
    end
    search_index
  end

  # need for getting logs without cut last node
  # example:
  # IP - - [26/Jan/2019:14:43:25 +0000] "GET / HTTP/1.0"
  # Write part log: "IP - - [26/Jan/2019:14:43:" in 26/Jan/2019:14:43:25.5
  # Write part log: "25 +0000] "GET / HTTP/1.0"" in 26/Jan/2019:14:43:25.7
  # collect data start in 26/Jan/2019:14:43:25.6 between (.5 and .7) and last node cutting into 2 logs
  def search_index_for_delta(current_time)
    @logs.reverse.each_with_index do |log, index|
      t = Time.strptime(log.match(@regexp_datetime_logs)[0], @format_datetime_logs)
      if t < (current_time - @delta_get_logs)
        return (@logs.size - index - 1)
      end
    end
    @logs.size
  end
end
