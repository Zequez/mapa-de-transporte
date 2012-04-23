class RemoveAddressesFromBuses < ActiveRecord::Migration
  def change
    remove_column :buses, :addresses
  end
end
