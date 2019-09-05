class SystemMetricStep < ApplicationRecord
  def set_attributes_system_metric_and_save(metric)
    self.count = self.count + 1

    self.cpu_average_sum = self.cpu_average_sum + metric.cpu_average
    self.cpu_average = self.cpu_average_sum / self.count

    self.memory_used_sum = self.memory_used_sum + metric.memory_used
    self.memory_used = self.memory_used_sum / self.count

    self.swap_used_sum = self.swap_used_sum + metric.swap_used
    self.swap_used = self.swap_used_sum / self.count

    self.descriptors_used_sum = self.descriptors_used_sum + metric.descriptors_used
    self.descriptors_used = self.descriptors_used_sum / self.count

    self.get_time = metric.get_time
    self.hot_catch_app = metric.hot_catch_app
    self.save
  end

  #  Возвращает массив x и y для построения графика
  def self.get_data_graph(app, step = "minute", from = nil, to = nil)
    all_metrics = self.where(hot_catch_app_id: app.id)
    all_metrics = all_metrics.where("get_time >= ?", I18n.l(from, format: :to_nginx)) if from
    all_metrics = all_metrics.where("get_time <= ?", I18n.l(to, format: :to_nginx)) if to
    all_metrics = all_metrics.order(:get_time)

    x = ["x_main_metric"]
    y = [["процессор"], ["использование памяти"],
      ["файл подкачки"], ["используемые дескрипторы"]]

    all_metrics.each do |metric|
      x << I18n.l(metric.get_time, format: "c3_date.#{step}".to_sym)
      y[0] << metric.cpu_average
      y[1] << metric.memory_used * (2 ** 10)
      y[2] << metric.swap_used * (2 ** 10)
      y[3] << metric.descriptors_used
    end

    [x, y]
  end
end
