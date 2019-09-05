class AddUniqueToHotCatchApp < ActiveRecord::Migration[5.2]
  def change
    add_index :hot_catch_apps, :name, unique: true
  end
end
