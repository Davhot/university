class CreateMainMetrics < ActiveRecord::Migration[5.2]
  def change
    create_table :main_metrics do |t|
      t.integer :memory_size
      t.integer :swap_size
      t.integer :descriptors_max
      t.string :architecture
      t.string :os
      t.string :os_version
      t.string :host_name
      t.references :hot_catch_app, index: true, foreign_key: true

      t.timestamps
    end
  end
end
