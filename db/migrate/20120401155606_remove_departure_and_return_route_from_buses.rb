class RemoveDepartureAndReturnRouteFromBuses < ActiveRecord::Migration
  def up
    remove_column :buses, :departure_route_id
    remove_column :buses, :return_route_id
  end
end
