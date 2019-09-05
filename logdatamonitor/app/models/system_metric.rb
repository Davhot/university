class SystemMetric < ApplicationRecord
  belongs_to :hot_catch_app

  # validates :cpu_average, presence: true
  # validates :memory_size, presence: true
  # validates :memory_used, presence: true
  # validates :swap_size, presence: true
  # validates :swap_used, presence: true
  # validates :discriptors_max, presence: true
  # validates :descriptors_used, presence: true

  def self.cpu_average_in_percent(cpu_average)
    "#{(cpu_average * 100).round(2)}%"
  end

  #  Возвращает массив x и y для построения графика
  def self.get_data_graph(app, step = "minute", from = nil, to = nil)
    all_metrics = app.system_metrics
    all_metrics = all_metrics.where("get_time >= ?", I18n.l(from, format: :to_nginx)) if from
    all_metrics = all_metrics.where("get_time <= ?", I18n.l(to, format: :to_nginx)) if to
    all_metrics = all_metrics.order(:get_time)

    x = ["x_main_metric"]
    y = [["процессор"], ["использование памяти"],
      ["файл подкачки"], ["используемые дескрипторы"]]
    hash = all_metrics.group_by{|x| I18n.l(x.get_time, format: "datetime.#{step}".to_sym)}
    hash.each do |key, val|
      a = [0, 0, 0, 0]
      for metric in val do
        a[0] += metric.cpu_average.to_f
        a[1] += metric.memory_used.to_i * (2 ** 10)
        a[2] += metric.swap_used * (2 ** 10)
        a[3] += metric.descriptors_used
      end
      a.map!{|x| x /= val.size}
      a[0] = (a[0] * 100).round(2)
      x << I18n.l(DateTime.strptime(key, I18n.t(step, scope: "time.formats.datetime")),
        format: "c3_date.#{step}".to_sym)
      y.each_with_index{|elem, index| elem << a[index]}
    end
    [x, y]
  end

end
