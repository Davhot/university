# if User.count == 0
#   if (u1 = User.find_by_email('admin@localhost')).nil?
#     u1 = User.create!(password: 'qwerty', password_confirmation: 'qwerty',
#       email: 'admin@localhost')
#   end
#   if (u2 = User.find_by_email('user@localhost')).nil?
#     u2 = User.create!(password: 'qwerty', password_confirmation: 'qwerty',
#       email: 'user@localhost')
#   end
#   r1, r2 = Role.create_main_roles
#   ru1 = RoleUser.create(role: r1, user: u1)
#   ru2 = RoleUser.create(role: r2, user: u2)
# end
#
# SystemMetricStep::Hour.delete_all
# SystemMetricStep::Day.delete_all
#
# for metric in SystemMetric.order(:get_time).all do
#   # Накопительные системные логи за час
#   if metric.present? && metric.get_time.present?
#     time_from = metric.get_time.change({ min: 0, sec: 0 })
#     time_to = metric.get_time.change({ min: 0, sec: 0 }) + 1.hour
#     last = SystemMetricStep::Hour.where("get_time > ?", time_from)
#     last = last.where("get_time <= ?", time_to)
#     last = last.first
#     if last.blank?
#       last = SystemMetricStep::Hour.new
#     end
#     last.set_attributes_system_metric_and_save(metric)
#   end
#
#   if metric.present? && metric.get_time.present?
#     time_from = metric.get_time.change({ hour: 0, min: 0, sec: 0 })
#     time_to = metric.get_time.change({ hour: 0, min: 0, sec: 0 }) + 1.day
#     last = SystemMetricStep::Day.where("get_time > ?", time_from)
#     last = last.where("get_time <= ?", time_to)
#     last = last.first
#     if last.blank?
#       last = SystemMetricStep::Day.new
#     end
#     last.set_attributes_system_metric_and_save(metric)
#   end
# end
#
# NetworkStep::HourNetwork.delete_all
# NetworkStep::DayNetwork.delete_all
#
# for metric in Network.order(:get_time).all do
#   # Накопительные системные логи за час
#   last = NetworkStep::HourNetwork.where(name: metric.name).order(:get_time).last
#   if metric.present? && metric.get_time.present?
#     time_from = metric.get_time.change({ min: 0, sec: 0 })
#     time_to = metric.get_time.change({ min: 0, sec: 0 }) + 1.hour
#     last = NetworkStep::HourNetwork.where("get_time > ?", time_from)
#     last = last.where("get_time <= ?", time_to)
#     last = last.first
#     if last.blank?
#       last = NetworkStep::HourNetwork.new
#     end
#     last.set_attributes_system_metric_and_save(metric)
#   end
#
#   last = NetworkStep::DayNetwork.where(name: metric.name).order(:get_time).last
#   if metric.present? && metric.get_time.present?
#     time_from = metric.get_time.change({ hour: 0, min: 0, sec: 0 })
#     time_to = metric.get_time.change({ hour: 0, min: 0, sec: 0 }) + 1.day
#     last = NetworkStep::DayNetwork.where("get_time > ?", time_from)
#     last = last.where("get_time <= ?", time_to)
#     last = last.first
#     if last.blank?
#       last = NetworkStep::DayNetwork.new
#     end
#     last.set_attributes_system_metric_and_save(metric)
#   end
# end
