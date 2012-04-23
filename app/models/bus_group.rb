class BusGroup < ActiveRecord::Base
  has_many :buses, inverse_of: :bus_group, order: "name ASC"
  belongs_to :city, inverse_of: :bus_groups

  #def self.load_from_buses(buses)
  #  groups = []
  #
  #  buses.each do |bus|
  #    groups << bus.bus_group if groups.last != bus.bus_group
  #    groups.last.buses_cache << bus
  #  end
  #
  #  #grouped.each_pair do |group, buses|
  #  #  group.readonly
  #  #  group.buses = []
  #  #  group.buses = buses
  #  #end
  #
  #  groups
  #end

  def buses_batches(*args, &block)
    buses.in_groups_of *args, &block
  end

  def json_data
    to_json only: [:id, :name]
  end
end
