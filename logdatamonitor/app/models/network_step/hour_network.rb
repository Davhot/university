class NetworkStep::HourNetwork < NetworkStep
  self.table_name = "network_steps"

  belongs_to :hot_catch_app
end
