class SellLocation < ActiveRecord::Base
  belongs_to :city

  #has_attached_file :picture, :styles => { :thumb => "100x100#", :original => "100%x100%>" }

  scope :visible, where(visibility: true)

  def clean_address
    address.sub(/\+$/, '')
  end
end
