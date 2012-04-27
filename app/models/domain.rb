class Domain < ActiveRecord::Base
  belongs_to :city

  after_save { Rails.cache.delete "Domain.registered?" }

  def self.registered?(name)
    Rails.cache.fetch("Domain.registered?"){
      domains = {}
      Domain.all.each do |d|
        domains[d.name] = d.city_id
      end
      domains
    }[name]
  end

end
