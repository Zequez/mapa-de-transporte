class ConvertRoutesToNonPolymorphic < ActiveRecord::Migration
  def up
    remove_column :routes, :routable_type
    remove_column :routes, :routable_id
    add_column :routes, :departure_bus_id, :integer
    add_column :routes, :return_bus_id, :integer
  end
end
