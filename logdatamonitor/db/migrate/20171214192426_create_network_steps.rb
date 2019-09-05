class CreateNetworkSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :network_steps do |t|
      t.string :type # для STI
      t.string :name
      t.float :bytes_in, default: 0
      t.float :bytes_out, default: 0
      t.float :packets_in, default: 0
      t.float :packets_out, default: 0
      t.datetime :get_time
      t.references :hot_catch_app, foreign_key: true

      t.timestamps
    end
  end
end
