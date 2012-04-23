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

  before_save :set_routes_caches
  after_save :handle_bus_image

  def self.delegatable_attributes
    %w{delay price card cash start_time end_time}
  end

  def set_routes_caches
    self.encoded_departure_route = departure_route.encoded if departure_route
    self.encoded_return_route    = return_route.encoded    if return_route
    #self.departure_route_addresses = departure_route.addresses
    #self.return_route_addresses = return_route.addresses
  end

  ### Buses Images ###
  ####################

  def handle_bus_image
    if CONFIG[:buses_images_on_save]
      generate_bus_image
      Bus.generate_buses_images_sheet
    else
      Bus.delete_buses_images_sheet
    end
  end

  def self.handle_buses_images_sheet
    all.each(&:generate_bus_image)
    generate_buses_images_sheet
  end


  def generate_bus_image
    path = image_path
    darker_color_1 =  Color.new(color_1).darken(0.3)
    
    convert = ["convert"]
    convert << "-size 24x12"
    convert << "-font 'Courier-Bold'"
    convert << "-pointsize 9"
    convert << "-gravity South"
    convert << "-background '#{color_1}'"
    convert << "-fill '#{color_2}'"
    convert << "-bordercolor '#{darker_color_1}'"
    convert << "-border 1"
    convert << "label:#{name}"
    convert << "'#{path}'"
    convert << "2>&1"

    r = `#{convert.join ' '}`

    raise "Error creating image" if not $?.success?
  end

  def self.delete_buses_images_sheet
    FileUtils.rm CONFIG[:buses_images_sheet_path] if File.exists?(CONFIG[:buses_images_sheet_path])
  end

  def self.generate_buses_images_sheet
    paths = images_paths

    montage = ["montage"]
    montage << "-border 0"
    montage << "-frame 0"
    montage << "-label ''"
    montage << "-tile 1x"
    montage << "-geometry '22x'"
    montage << "'#{paths}'"
    montage << "'#{CONFIG[:buses_images_sheet_path]}'"
    montage << "2>&1"

    r = `#{montage.join ' '}`

    raise "Error creating the montaged image" if not $?.success?
  end

  def self.rebuild_buses_images
    all.each(&:generate_bus_image)
    generate_buses_images_sheet
  end

  def image_path
    Bus.images_paths(id)
  end

  def self.images_paths(id = '*')
    (Rails.root + CONFIG[:bus_image_path]).to_s.sub(':id', id.to_s)
  end

  ### Stuff ###
  #############

  def self.from_names(all_names)
    all_names = all_names.to_s.split('+') unless all_names.is_a? Array
    names        = []
    groups_names = []

    all_names = all_names.reject(&:blank?).map(&:to_s)

    scope = joins(:bus_group).ordered

    if not all_names.empty?
      all_names.each do |name|
        (name['X'].nil? ? names : groups_names) << name
      end

      scope.where("buses.name IN (?) OR bus_groups.name IN (?)", names, groups_names)
    else
      []
    end
  end

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
                       city: {only: [:viewport]}}
  end

  def is_shown?
    is_shown
  end

  # Hackity Hack
  #def include_routes_from(bus)
  #  self.departure_route = bus.departure_route
  #  self.return_route = bus.return_route
  #end
end
