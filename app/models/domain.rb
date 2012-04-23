class Domain < ActiveRecord::Base
  belongs_to :city

  def self.registered?(name)
    #Rails.cache.delete "Domain.registered?"

    Rails.cache.fetch("Domain.registered?"){
      domains = {}
      Domain.all.each do |d|
        domains[d.name] = d.city_id
      end
      domains
    }[name]
  end
  after_save { Rails.cache.delete "Domain.exists?" }
end
