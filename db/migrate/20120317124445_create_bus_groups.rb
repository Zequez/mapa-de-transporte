class CreateBusGroups < ActiveRecord::Migration
  def change
    create_table :bus_groups do |t|
      t.string :name, unique: true
    end

    add_index :bus_groups, :name
  end
end
