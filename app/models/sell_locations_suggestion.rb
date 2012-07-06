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
                  :comment,
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
                  :comment,
                  as: :user

  #validates :address, presence: true
  validates :user_email, presence: true,
                         format: { with: /[^ ]+@[^ ]+\.[^ ]+/ },
                         length: { maximum: 200 }

  delegate :city, to: :sell_location, allow_nil: true

  after_validation :remove_other_errors_if_blank_error

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

  def remove_other_errors_if_blank_error
    if errors.count > 0
      errors.messages.each_pair do |key, messages|
        if messages.index { |k| k =~ /blanco|blank/ }
          L.l errors.messages
          errors.messages[key].delete_if {|k| ! (k =~ /blanco|blank/)}
        end
      end
    end
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
