class Route < ActiveRecord::Base
  belongs_to :departure_bus, class_name: 'Bus'
  belongs_to :return_bus,    class_name: 'Bus'

  has_many :checkpoints, order: "number ASC"

  scope :include_buses, includes(:departure_bus, :return_bus)

  accepts_nested_attributes_for :checkpoints, allow_destroy: true

  def bus
    (departure_bus if departure_bus_id) || (return_bus if return_bus_id)
  end

  def json_checkpoints_attributes
    checkpoints.to_json(only: [:id, :latitude, :longitude, :number])
  end

  def json_checkpoints_attributes=(json)
    self.checkpoints_attributes = ActiveSupport::JSON.decode(json)
  end
end
