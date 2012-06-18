class Feedback < ActiveRecord::Base

  belongs_to :city

  def self.last_from_address(address)
    where(address: address).last
  end

  validates :name,
            presence: true,
            format: { with: /[a-z0-9\-_ ]/i },
            length: { maximum: 200 }

  validates :email,
            allow_blank: true,
            format: { with: /[^ ]+@[^ ]+\.[^ ]+/ },
            length: { maximum: 200 }

  validates :message,
            presence: true,
            length: { within: 1..500 }

  validates :city,
            presence: true

  validate :validate_flooding

  def validate_flooding
    last_address = Feedback.last_from_address(address)

    if last_address
      L.l Time.now.to_i
      L.l last_address.seconds_since_created
    end

    if (not last_address) or last_address == self or (Time.now.to_i - 20 >= last_address.seconds_since_created)
      true
    else
      errors.add :address, I18n.t('errors.feedback.anti_flood')
      false
    end
  end

  def seconds_since_created
    created_at.to_time.to_i
  end
end
