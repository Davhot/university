class CreateSystemMetricSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :system_metric_steps do |t|
      t.string :type # для STI
      t.integer :count, default: 0
      t.float :cpu_average_sum, default: 0
      t.float :cpu_average
      t.float :memory_used
      t.float :memory_used_sum, default: 0
      t.float :swap_used
      t.float :swap_used_sum, default: 0
      t.integer :descriptors_used
      t.integer :descriptors_used_sum, default: 0
      t.datetime :get_time
      t.references :hot_catch_app, index: true, foreign_key: true

      t.timestamps
    end
  end
end
