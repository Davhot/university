class Network < ApplicationRecord
  belongs_to :hot_catch_app

  # Возвращает массив x и y для построения графика
  # Формат:
  # x: [[легенда оси y1, легенда оси x1], [легенда оси y2, легенда оси x1],
  # [легенда оси y3, легенда оси x2], [легенда оси y4, легенда оси x2], ...]
  # y: [[легенда оси y1, входящий трафик, исходящий, дата], [...], ...]
  def self.get_data_graph(app, step = "minute", from = nil, to = nil)
    x, y = [], []
    name_networks = self.pluck(:name).uniq

    name_networks.each_with_index do |name, index|
      networks = Network.where(hot_catch_app_id: app.id, name: name)
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
