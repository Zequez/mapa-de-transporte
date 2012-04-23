class RemoveDomainFromCities < ActiveRecord::Migration
  def up
    remove_column :cities, :domain
  end

  def down
  end
end
