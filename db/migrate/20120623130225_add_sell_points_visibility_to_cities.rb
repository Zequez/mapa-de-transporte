class AddSellPointsVisibilityToCities < ActiveRecord::Migration
  def change
    add_column :cities, :sell_points_visibility, :boolean, default: false, null: false
    add_column :cities, :show_bus_ticket, :boolean, default: false, null: false
  end
end
