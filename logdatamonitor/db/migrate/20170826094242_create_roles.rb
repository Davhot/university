class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :info, null: false
      t.text :full_info, null: false
      t.index :name, unique: true
      t.index :info, unique: true

      t.timestamps null: false
    end
  end
end
