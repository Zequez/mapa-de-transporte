class AddVisibilityInexactAndManualPositionToSellLocations < ActiveRecord::Migration
  def change
    add_column :sell_locations, :visibility, :boolean, default: true, null: false

    add_column :sell_locations, :inexact, :boolean, default: false, null: false

    add_column :sell_locations, :manual_position, :boolean, default: false, null: false

  end
end
