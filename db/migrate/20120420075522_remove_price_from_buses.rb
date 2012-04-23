class RemovePriceFromBuses < ActiveRecord::Migration
  def up
    remove_column :buses, :price
  end
end
