class ChangeCpuAverageMinuteToCpuAverage < ActiveRecord::Migration[5.2]
  def change
    rename_column :system_metrics, :cpu_average_minute, :cpu_average
  end
end
