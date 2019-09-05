class HotCatchApp < ApplicationRecord
  has_many :main_hot_catch_logs
  has_many :disks
  has_many :system_metrics
  has_many :system_metric_step_hours, class_name: "SystemMetricStep::Hour"
  has_many :system_metric_step_days, class_name: "SystemMetricStep::Day"
  has_many :networks
  has_many :network_step_hours, class_name: "NetworkStep::HourNetwork"
  has_many :network_step_days, class_name: "NetworkStep::DayNetwork"
  has_one :main_metric

  self.per_page = 10 # пагинация

  validates :name, presence: true, uniqueness: true

  def count_errors
    sum = 0
    self.main_hot_catch_logs
      .where('status in (?)', %w(CLIENT_ERROR SERVER_ERROR WARNING UNKNOWN))
      .map{|x| sum += x.count_log}
    sum
  end

  def network_interfaces
    networks.pluck(:name).uniq
  end
end
