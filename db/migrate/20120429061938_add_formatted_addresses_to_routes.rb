class AddFormattedAddressesToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :formatted_addresses, :text

  end
end
