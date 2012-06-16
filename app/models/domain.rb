class Domain < ActiveRecord::Base
  belongs_to :city

  scope :no_cities, where('city_id = ?', nil)

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

  def validator
    MyEncryptor.domain_validator(name)
  end

  def self.validators
    (CONFIG[:authorized_domains] || all.map(&:name)).map do |domain_name|
      MyEncryptor.domain_validator(domain_name)
    end
  end
end
