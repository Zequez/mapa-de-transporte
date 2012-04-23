class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.string :perm, unique: true
      t.float :latitude
      t.float :longitude
      t.integer :zoom_level
    end

    add_index :cities, :perm
  end
end
