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
                  :visibility,
                  :reviewed

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
                  :visibility,
                  as: :user

  #validates :address, presence: true

  delegate :city, to: :sell_location, allow_nil: true

  def removed=(value)
    value = to_boolean(value)
    
    if value == nil
      self.visibility = nil
    else
      self.visibility = !value
    end
  end

  def removed
    if visibility == nil
      nil
    else
      !visibility
    end
  end

  private

  def to_boolean(val)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(val)
  end

  #def lat=(val)
  #  val = 0 if not (val = val.to_f)
  #  write_attribute :lat, val
  #end
  #
  #def lng=(val)
  #  val = 0 if not (val = val.to_f)
  #  write_attribute :lng, val
  #end
end
