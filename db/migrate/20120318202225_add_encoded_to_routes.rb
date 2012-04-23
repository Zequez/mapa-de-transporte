class AddEncodedToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :encoded, :string
    remove_column :buses, :encoded_route
  end
end
