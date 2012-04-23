class ConvertBusesCardAndCashToInteger < ActiveRecord::Migration
  def up
    remove_column :buses, :card
    remove_column :buses, :cash
    remove_column :bus_groups, :bus_card
    remove_column :bus_groups, :bus_cash
    remove_column :cities, :bus_card
    remove_column :cities, :bus_cash

    add_column :buses, :card, :integer
    add_column :buses, :cash, :integer
    add_column :bus_groups, :bus_card, :integer
    add_column :bus_groups, :bus_cash, :integer
    add_column :cities, :bus_card, :integer
    add_column :cities, :bus_cash, :integer

    add_column :cities, :show_bus_card, :boolean, default: true, null: false
    add_column :cities, :show_bus_cash, :boolean, default: true, null: false
  end
end
