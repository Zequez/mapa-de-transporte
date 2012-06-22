class AddBusTicketToCities < ActiveRecord::Migration
  def change
    add_column :cities, :bus_ticket, :integer
    add_column :bus_groups, :bus_ticket, :integer
    add_column :buses, :ticket, :integer
  end
end
