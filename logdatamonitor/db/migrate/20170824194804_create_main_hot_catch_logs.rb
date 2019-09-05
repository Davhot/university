class CreateMainHotCatchLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :main_hot_catch_logs do |t|
      t.text :log_data, null: false
      t.integer :count_log, null: false, default: 1
      t.string :from_log, null: false
      t.string :status, null: false
      t.references :hot_catch_app, index: true, foreign_key: true

      t.timestamps

    end
  end
end
