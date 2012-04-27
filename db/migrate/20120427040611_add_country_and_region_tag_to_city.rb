class AddCountryAndRegionTagToCity < ActiveRecord::Migration
  def change
    add_column :cities, :country, :string, default: "Argentina"

    add_column :cities, :region_tag, :string, default: "AR"

  end
end
