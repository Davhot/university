class SystemMetricStep::Day < SystemMetricStep
  self.table_name = "system_metric_steps"

  belongs_to :hot_catch_app
end
