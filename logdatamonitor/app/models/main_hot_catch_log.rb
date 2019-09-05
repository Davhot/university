class MainHotCatchLog < ApplicationRecord
  belongs_to :hot_catch_app
  has_many :user_requests
  attr_accessor :name_app

  self.per_page = 20 # пагинация

  STATUSES = %w( STATUS SUCCESS REDIRECTION CLIENT_ERROR SERVER_ERROR WARNING UNKNOWN )
  FROM = %w( Rails Client Puma Nginx )

  validates :log_data, presence: true, uniqueness: true
  validates :count_log, numericality: {only_integer: true, greater_than: 0}
  validates :from_log, presence: true, inclusion: {in: FROM}
  validates :status, presence: true, inclusion: {in: STATUSES}

  def self.get_nginx_data_graph(app, step = "minute", from = nil, to = nil)
    parser = ParseNginx.new
    parser.parse_all_data("log/apps/#{app.name.downcase}-nginx.access.log")
    data = parser.data

    data = data.select{|x| x[1] >= from } if from
    data = data.select{|x| x[1] <= to } if to

    graphic_stats = data.map{|x| I18n.l(x[1], format: "c3_date.#{step}".to_sym) }
      .group_by{|e| e}.map{|k, v| [k, v.length]}

    # [DATE, COUNT REQUESTS]
    [graphic_stats.map{|x| x[0]}.unshift("x_nginx"),
      graph_data_y = graphic_stats.map{|x| x[1]}.unshift("Nginx")]
  end

  def set_data_and_save
    set_app
    process_log_data
  end

  def set_app_and_process_system_logs(logs)
    set_app
    process_system_logs(logs)
  end

  private

  def set_app
    self.hot_catch_app = HotCatchApp.find_or_create_by(name: name_app)
  end

  def process_system_logs(logs)
    metric = SystemMetric.create(cpu_average: logs["cpu"]["last_minute"],
      memory_used: logs["memory"]["used"], swap_used: logs["memory"]["swap_used"],
      descriptors_used: logs["descriptors"]["current"], get_time: logs["time"],
      hot_catch_app_id: hot_catch_app.id)

    # Накопительные системные логи за час
    last_hour_metric = SystemMetricStep::Hour.order(:get_time).last
    if metric.present? && metric.get_time.present?
      time_from = metric.get_time.change({ min: 0, sec: 0 })
      time_to = metric.get_time.change({ min: 0, sec: 0 }) + 1.hour
      if last_hour_metric.blank? || last_hour_metric.get_time.change({ min: 0, sec: 0 }) >= time_to
        last_hour_metric = SystemMetricStep::Hour.new
      end
      last_hour_metric.set_attributes_system_metric_and_save(metric)
    end

    # Накопительные системные логи за день
    last_day_metric = SystemMetricStep::Day.order(:get_time).last
    if metric.present? && metric.get_time.present?
      time_from = metric.get_time.change({ hour: 0, min: 0, sec: 0 })
      time_to = metric.get_time.change({ hour: 0, min: 0, sec: 0 }) + 1.day
      if last_day_metric.blank? || last_day_metric.get_time.change({ hour: 0, min: 0, sec: 0 }) >= time_to
        last_day_metric = SystemMetricStep::Day.new
      end
      last_day_metric.set_attributes_system_metric_and_save(metric)
    end

    main_metric_attrs = {
      memory_size: logs["memory"]["size"],
      swap_size: logs["memory"]["swap_size"],
      descriptors_max: logs["descriptors"]["max"],
      architecture: logs["system_info"]["architecture"],
      os: logs["system_info"]["os"],
      os_version: logs["system_info"]["os_version"],
      host_name: logs["system_info"]["host_name"]
    }
    if hot_catch_app.main_metric.present?
      hot_catch_app.main_metric.update_attributes(main_metric_attrs)
    else
      main_metric = MainMetric.new(main_metric_attrs)
      main_metric.hot_catch_app = hot_catch_app
      main_metric.save
    end

    # Обновляем/создаём диски
    disks = []
    logs["disk"].each do |k, v|
      disks << Disk.find_or_create_by(name: k)
      if disks[-1].present?
        disks[-1].update_attributes({
          filesystem: v["filesystem"],
          size: v["size"],
          used: v["used"],
          mounted_on: v["mounted_on\n"].try(:strip),
          hot_catch_app_id: hot_catch_app.id})
      end
    end
    # Удаляем ненужные
    for disk_name in hot_catch_app.disks.pluck(:name) - disks.map{|d| d.name} do
      Disk.find_by(name: disk_name, hot_catch_app_id: hot_catch_app.id).destroy
    end

    networks = []
    logs["network"].each do |k, v|
      networks << k
      metric = Network.create(name: k,
        bytes_in: v["bytes_in"],
        bytes_out: v["bytes_out"],
        packets_in: v["packets_in"],
        packets_out: v["packets_out"],
        get_time: logs["time"],
        hot_catch_app_id: hot_catch_app.id)

      # Накопительные системные логи за час
      last_hour_metric = NetworkStep::HourNetwork.where(name: k).order(:get_time).last
      if metric.present? && metric.get_time.present?
        time_from = metric.get_time.change({ min: 0, sec: 0 })
        time_to = metric.get_time.change({ min: 0, sec: 0 }) + 1.hour
        if last_hour_metric.blank? || last_hour_metric.get_time < time_from ||
        last_hour_metric.get_time >= time_to
          last_hour_metric = NetworkStep::HourNetwork.new
        end
        last_hour_metric.set_attributes_system_metric_and_save(metric)
      end

      # Накопительные системные логи за день
      last_day_metric = NetworkStep::DayNetwork.where(name: k).order(:get_time).last
      if metric.present? && metric.get_time.present?
        time_from = metric.get_time.change({ hour: 0, min: 0, sec: 0 })
        time_to = metric.get_time.change({ hour: 0, min: 0, sec: 0 }) + 1.day
        if last_day_metric.blank? || last_day_metric.get_time < time_from ||
        last_day_metric.get_time >= time_to
          last_day_metric = NetworkStep::DayNetwork.new
        end
        last_day_metric.set_attributes_system_metric_and_save(metric)
      end
    end

    for interface in (hot_catch_app.networks.pluck(:name) - networks) do
      Network.where(name: interface, hot_catch_app_id: hot_catch_app.id).delete_all
    end

    o_file = "log/apps/#{hot_catch_app.name.downcase}-system.txt"
    file = File.open(o_file, 'w')

    file.puts
    File.open("log/apps/system.json", 'w'){|file| file.puts logs}

    logs.each do |key, val|
      if key != "time"
        file.puts "#{key}:"
        val.each do |part_key, part_val|
          if %w(network disk).include?(key)
            file.puts "  #{part_key}:"
            part_val.each do |part_key2, part_val2|
              file.puts "    #{part_key2.to_s.strip} #{part_val2.to_s.strip}"
            end
          else
            file.puts "  #{part_key} #{part_val}"
          end
        end
      else
        file.puts "#{key} #{val}"
      end
    end
    file.puts ?= * 70 + "\n"
    file.close

    true
  end

  # Проверка лога на уникальность
  def process_log_data
    if from_log == "Nginx"
      i_file = "log/apps/#{hot_catch_app.name.downcase}-nginx.access.log"
      o_file = "log/apps/#{hot_catch_app.name.downcase}-report.json"
      goaccess_config_path = Rails.root.join('config', 'goaccess.conf')
      File.open(i_file, 'a'){|file| file.write log_data}
      `goaccess -p #{goaccess_config_path} -f #{i_file} -o json > #{o_file}`
      true
    else
      str = self.log_data
      parser = RailsLogParser.new
      # Сводка по времени и ip запросов
      ip, date = parser.get_ip_and_date(str)
      req = UserRequest.create(ip: ip, request_time: date)
      # Берём статус запроса
      self.status = parser.get_status(self.log_data, self.status)
      str2 = parser.strip_str(str)
      # Если есть лог, то count_log += 1
      MainHotCatchLog.where(status: status,
      hot_catch_app_id: hot_catch_app.id).each do |cur_log|
        if parser.strip_str(cur_log.log_data) == str2
          cur_log.user_requests << req if req.present?
          cur_log.update_attribute(:count_log, cur_log.count_log + 1)
          return true
        end
      end
      self.log_data = parser.strip_str(str)
      self.user_requests << req if req.present?
      self.save
    end
  end
end
