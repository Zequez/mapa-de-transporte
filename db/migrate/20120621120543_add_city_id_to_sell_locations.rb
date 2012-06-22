class AddCityIdToSellLocations < ActiveRecord::Migration
  def change
    add_column :sell_locations, :city_id, :integer

  end
end
