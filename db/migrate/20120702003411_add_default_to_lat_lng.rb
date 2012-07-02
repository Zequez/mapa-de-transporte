class AddDefaultToLatLng < ActiveRecord::Migration
  def change
    change_column :sell_locations, :lat, :float, null: false, default: 0
    change_column :sell_locations, :lng, :float, null: false, default: 0
    change_column :sell_locations_suggestions, :lat, :float, null: false, default: 0
    change_column :sell_locations_suggestions, :lng, :float, null: false, default: 0
  end
end
