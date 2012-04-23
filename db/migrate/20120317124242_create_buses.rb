class CreateBuses < ActiveRecord::Migration
  def change
    create_table :buses do |t|
      t.string :name, unique: true
      t.string :color_1
      t.string :color_2
      t.integer :karma
      t.string :encoded_route
      t.integer :city_id
      t.integer :bus_group_id
      t.datetime :updated_at
    end

    add_index :buses, [:name, :city_id, :bus_group_id]
  end
end
