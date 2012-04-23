class AddAddressesToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :addresses, :text

  end
end
