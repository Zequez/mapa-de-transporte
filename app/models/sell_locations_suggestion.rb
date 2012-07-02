class SellLocationsSuggestion < ActiveRecord::Base
  belongs_to :sell_location

  attr_accessible :lat,
                  :lng,
                  :sell_location_id,
                  :user_name,
                  :user_email,
                  :address,
                  :name,
                  :info,
                  :card_selling,
                  :card_reloading,
                  :ticket_selling,
                  :removed,
                  :visibility

  validates :address, presence: true

  delegate :city, to: :sell_location, allow_nil: true

  def removed=(value)
    self.visibility = !value
  end

  def removed
    !visibility
  end

  def lat=(val)
    val = 0 if not (val = val.to_f)
    write_attribute :lat, val
  end

  def lng=(val)
    val = 0 if not (val = val.to_f)
    write_attribute :lng, val
  end
end
