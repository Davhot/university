class NetworkStep < ApplicationRecord
  belongs_to :hot_catch_app

  def set_attributes_system_metric_and_save(metric)
    self.name = metric.name

    self.bytes_in = self.bytes_in + metric.bytes_in
    self.bytes_out = self.bytes_out + metric.bytes_out
    self.packets_in = self.packets_in + metric.packets_in
    self.packets_out = self.packets_out + metric.packets_out

    self.get_time = metric.get_time
    self.hot_catch_app = metric.hot_catch_app
    self.save
  end

  def self.get_data_graph(app, step = "minute", from = nil, to = nil)
    x, y = [], []
    name_networks = self.pluck(:name).uniq

    name_networks.each_with_index do |name, index|
      networks = self.where(hot_catch_app_id: app.id, name: name)
      networks = networks.where("get_time >= ?", I18n.l(from, format: :to_nginx)) if from
      networks = networks.where("get_time <= ?", I18n.l(to, format: :to_nginx)) if to
      networks = networks.order(:get_time)

      y << ["#{name}: входящий трафик"]
      y << ["#{name}: исходящий трафик"]
      y << ["x_network_#{index + 1}"]
      x << [y[-2][0], y[-1][0]]
      x << [y[-3][0], y[-1][0]]

      networks.each do |network|
        y[-3] << network.bytes_in
        y[-2] << network.bytes_out
        y[-1] << I18n.l(network.get_time, format: "c3_date.#{step}".to_sym)
      end
    end
    [x, y]
  end
end
