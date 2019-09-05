class CreateUserRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :user_requests do |t|
      t.string :ip, null: false
      t.datetime :request_time, null: false
      t.references :main_hot_catch_log, index: true, foreign_key: true

      t.timestamps
    end
  end
end
