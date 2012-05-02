class ChangeBusesEncodedRoutesToText < ActiveRecord::Migration
  def up
    change_column :buses, :encoded_departure_route, :text
    change_column :buses, :encoded_return_route, :text
    change_column :routes, :encoded, :text
  end

  def down
  end
end
