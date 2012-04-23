class AddAddressesToBuses < ActiveRecord::Migration
  def change
    add_column :buses, :addresses, :text
  end
end
