class AddBusValuesToGroupsAndCities < ActiveRecord::Migration
  def change
    add_column :cities, :bus_price, :integer
    add_column :cities, :bus_delay, :integer
    add_column :cities, :bus_start_time, :integer
    add_column :cities, :bus_end_time, :integer
    add_column :cities, :bus_card, :boolean
    add_column :cities, :bus_cash, :boolean
    
    add_column :bus_groups, :bus_price, :integer
    add_column :bus_groups, :bus_delay, :integer
    add_column :bus_groups, :bus_start_time, :integer
    add_column :bus_groups, :bus_end_time, :integer
    add_column :bus_groups, :bus_card, :boolean
    add_column :bus_groups, :bus_cash, :boolean
  end
end
