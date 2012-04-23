class MakeCitizableStuff < ActiveRecord::Migration
  def up
    add_column :bus_groups, :city_id, :integer
    change_column :bus_groups, :name, :string, unique: false
    change_column :buses, :name, :string, unique: false
  end
end
