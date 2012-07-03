class SellLocation < ActiveRecord::Base
  belongs_to :city
  has_many :sell_locations_suggestions, conditions: {reviewed: false}
  #has_many :all_sell_locations_suggestions, where: {reviewed: false}

  accepts_nested_attributes_for :sell_locations_suggestions

  #has_attached_file :picture, :styles => { :thumb => "100x100#", :original => "100%x100%>" }

  scope :visible, where(visibility: true)
  scope :with_suggestion, joins(:sell_locations_suggestions).where("sell_locations_suggestions.id IS NOT NULL").uniq

  def self.first_with_suggestion
    with_suggestion.first
  end

  def clean_address
    address.sub(/\+$/, '')
  end
end
