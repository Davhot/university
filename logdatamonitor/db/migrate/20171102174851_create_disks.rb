class CreateDisks < ActiveRecord::Migration[5.2]
  def change
    create_table :disks do |t|
      t.string :name
      t.string :filesystem
      t.integer :size
      t.integer :used
      t.string :mounted_on
      t.references :hot_catch_app, index: true, foreign_key: true

      t.timestamps
    end
  end
end
