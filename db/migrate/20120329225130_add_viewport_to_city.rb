class AddViewportToCity < ActiveRecord::Migration
  def change
    add_column :cities, :viewport, :string
    remove_column :cities, :longitude
    remove_column :cities, :latitude
    remove_column :cities, :zoom_level
  end
end
