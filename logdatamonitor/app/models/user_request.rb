class UserRequest < ApplicationRecord
  belongs_to :main_hot_catch_log, required: false

  validates :ip, :request_time, presence: true

  # Все запросы с ошибками по одному приложению
  def self.find_non_success(app)
    self.includes(:main_hot_catch_log, main_hot_catch_log: :hot_catch_app)
      .where(main_hot_catch_logs: {hot_catch_app_id: app.id})
      .where.not(main_hot_catch_logs: {status: 'SUCCESS'})
  end

  # получениe интегральных данных по невалидным запросам в приложении
  # [DATE, COUNT]
  def self.non_success_count_date(app, format_date)
    find_non_success(app).group_by{|x| x.request_time.strftime(format_date)}
      .map{|x| [x[0], x[1].size]}
  end

  def self.get_data_graph(app, step = "minute", from = nil, to = nil)
    data = self
      .includes(:main_hot_catch_log, main_hot_catch_log: :hot_catch_app)
      .where(main_hot_catch_logs: {hot_catch_app_id: app.id})
      .where.not(main_hot_catch_logs: {status: 'SUCCESS'})
    data = data.where("request_time >= ?", I18n.l(from, format: :to_nginx)) if from
    data = data.where("request_time <= ?", I18n.l(to, format: :to_nginx)) if to
    data = data.group_by{|x| I18n.l(x.request_time, format: "datetime.#{step}".to_sym)}
      .map{|x| [x[0], x[1].size]}

    x, y = ["x_rails"], ["Rails"]

    data.each{ |a| x << I18n.l(DateTime.strptime(a[0],
      I18n.t(step, scope: "time.formats.datetime")),
      format: "c3_date.#{step}".to_sym); y << a[1] }
    [x, y]
  end
end
