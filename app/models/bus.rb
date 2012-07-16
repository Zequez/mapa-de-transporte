class Bus < ActiveRecord::Base
  belongs_to :city
  belongs_to :bus_group, inverse_of: :buses

  has_one :departure_route, class_name: "Route", foreign_key: :departure_bus_id
  has_one :return_route, class_name: "Route", foreign_key: :return_bus_id

  attr_accessor :is_shown # Hacky hack for the view actually.

  accepts_nested_attributes_for :departure_route, :return_route

  scope :visible, where(visible: true)
  scope :ordered, order("bus_groups.name ASC, buses.name ASC")
  scope :for_admin_index, includes(:bus_group, :city)
  scope :from_buses_names, lambda{|buses, groups|
    joins(:bus_group)
    .ordered
    .where("buses.perm IN (?) OR bus_groups.name IN (?)", buses, groups)
  }
  scope :select_ids, select('buses.id')

  before_validation :uppercase_name
  before_save :create_perm
  before_save :set_routes_caches
  after_save :handle_sprite_generation

  validates :name,
            presence: true,
            format: { with: /[0-9]{3}/ }


  def uppercase_name
    self.name = name.upcase
  end

  def create_perm
    self.perm = "#{name}#{division.sub('?', 'q').sub('+', 'm')}"
  end

  # These will be delegated to groups and to city
  def self.delegatable_attributes
    %w{delay price card cash start_time end_time}
  end

  def set_routes_caches
    self.encoded_departure_route = departure_route.encoded if departure_route
    self.encoded_return_route    = return_route.encoded    if return_route
    #self.departure_route_addresses = departure_route.addresses
    #self.return_route_addresses = return_route.addresses
  end

  include BusesImages::BusInclude

  ### From names search ###
  #########################

  def self.from_names(all_names)
    names, groups_names = parse_names all_names

    if names.size > 0 or groups_names.size > 0
      from_buses_names(names, groups_names)
    end
  end

  def self.ids_from_perms(all_names)
    names, groups_names = parse_names all_names

    if names.size > 0 or groups_names.size > 0
      query_result = ActiveRecord::Base.connection.execute from_buses_names(names, groups_names).select_ids.to_sql
      query_result.to_a.map{|b|b['id'].to_i}
    else
      []
    end
  end

  def self.parse_names(all_names)

    all_names = all_names.to_s.split('+') unless all_names.is_a? Array
    all_names.delete_if(&:blank?)

    names = []
    groups_names = []

    all_names.each do |name|
      (name['X'].nil? ? names : groups_names) << name
    end

    [names, groups_names]
  end

  ### Buildup of new buses ###
  ############################

  def self.for_new
    bus                 = new
    bus.city            = City.first
    #bus.return_route    = Route.new name: "Departure"
    #bus.return_route    = Route.new name: "Return"
    bus
  end

  def build_routes
    build_departure_route if !departure_route
    build_return_route if !return_route
  end

  #def self.for_index(all_names)
  #  return self if all_names.blank?
  #  from_names(all_names)
  #end

  # Kind of delegation
  delegatable_attributes.each do |method|
    define_method "#{method}!" do
      # We load city through bus_group because the buses are loaded in bus_groups when displaying them
      # via includes, and BusGroup have inverse_of for City.
      send(method).blank! || bus_group.send(:"bus_#{method}") || bus_group.city.send(:"bus_#{method}")
    end
  end

  def to_editor_json
    to_json only: [],
            include: {departure_route: {only: []},
                       return_route: {only: []},
                       city: {only: [:viewport, :name, :country, :region_tag]}}
  end

  def is_shown?
    is_shown
  end

  def variation
    raise "Bus#variation DEPRECATED! Use Bus#Division"
    @variation ||= name[3] if name
  end

  def cropped_name
    name[0...3]
  end

  # Hackity Hack
  #def include_routes_from(bus)
  #  self.departure_route = bus.departure_route
  #  self.return_route = bus.return_route
  #end

  def circular_route?
    departure_route.blank? or return_route.blank?
  end

  def route
    if departure_route.blank?
      if return_route.blank?
        nil
      else
        return_route
      end
    else
      departure_route
    end
  end
end
