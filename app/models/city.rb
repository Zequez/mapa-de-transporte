require 'json'
require 'base64'

class City < ActiveRecord::Base
  has_many :buses
  has_many :bus_groups, inverse_of: :city
  has_many :domains
  has_many :feedbacks
  has_many :sell_locations, order: "address ASC"

  accepts_nested_attributes_for :sell_locations, allow_destroy: true

  validates :name, presence: true, uniqueness: true
  validates :perm, presence: true, uniqueness: true

  before_validation :set_perm

  serialize :viewport

  scope :for_show, includes(bus_groups: [:buses])#: [:departure_route, :return_route]])
  scope :ordered, order("name ASC")
  scope :visible, where(visible: true)

  scope :domain, lambda{|domain|}

  def visible_sell_locations
    @visible_sell_locations ||= sell_locations.visible.all
  end

  def set_perm
    self.perm = name.to_slug.normalize.to_s
  end

  def to_param
    self.perm
  end

  def self.from_param(id_or_perm)
    if id_or_perm =~ /[0-9]+/
      find_by_id(id_or_perm)
    else
      find_by_perm(id_or_perm)
    end
  end

  def self.get_by_domain(domain)
    city_id = Domain.registered?(domain)
    find_by_id(city_id) if city_id
  end

  def self.get_by_user_location(name)
    find_by_name(name) if not name.blank?
  end

  def self.get_from_geolocation(ip)
    first
  end

  def json_viewport
    viewport.to_json
  end

  def json_viewport=(json_viewport)
    begin
      self.viewport = JSON.parse json_viewport
    rescue
      
    end
  end

  #def json_sell_locations
  #  sell_locations.to_json(only: [:id, :lat, :lng, :name, :address, :info, :card_selling, :card_reloading, :ticket_selling])
  #end

  #def json_sell_locations=(json_sell_locations)
  #  begin
  #    assign_attributes :sell_locations, JSON.parse(json_sell_locations)
  #  end
  #end

  def set_shown_buses(buses)
    buses = Bus.ids_from_perms buses

    new_buses_array = []
    bus_groups.each do |bus_group|
      bus_group.visible_buses.each do |bus|
        i = buses.index(bus.id)
        if i
          bus.is_shown = true
          #bus.include_routes_from(buses[i])
          new_buses_array << bus
        else
          bus.is_shown = false
        end
      end
    end

    new_buses_array
  end
  
  def to_map_json
    to_json(only: [:viewport, :name, :country, :region_tag],
            include: {
              bus_groups: {
                only: [:id, :name],
                include: {
                  visible_buses: { only: [:id, :name, :perm, :division, :division_name, :encoded_departure_route, :encoded_return_route, :is_shown] }
                }
              },
              visible_sell_locations: {
                only: [:id, :lat, :lng, :name, :address, :info, :card_selling, :card_reloading, :ticket_selling]
              }
            }).html_safe
  end

  def to_sell_locations_editor_json
    to_json(only: [:viewport, :name, :country, :region_tag],
            include: {
              sell_locations: {
                only: [:id,
                       :lat,
                       :lng,
                       :address,
                       :name,
                       :info,
                       :card_selling,
                       :card_reloading,
                       :ticket_selling,
                       :visibility,
                       :inexact,
                       :manual_position]
              }
            }).html_safe
  end

  ### Crappy encryption ###
  #########################

  def to_qps(domain = nil)
    MyEncryptor.encode to_map_json
  end

  def from_qps(encoded, domain = nil)
    MyEncryptor.decode encoded
  end

  # This is for the view to be able to render the city like a bus.

  Bus.delegatable_attributes.each do |method|
    define_method "#{method}!" do
      read_attribute :"bus_#{method}"
    end
  end
end
