class RemovePriceFromTheTables < ActiveRecord::Migration
  def up
    remove_column :cities, :bus_price
    remove_column :bus_groups, :bus_price
  end

  def down
  end
end
