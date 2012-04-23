class AddEncodedRoutesToBuses < ActiveRecord::Migration
  def change
    add_column :buses, :encoded_departure_route, :string
    add_column :buses, :encoded_return_route, :string
  end
end
