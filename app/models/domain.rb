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

  def validator
    sum = 0
    name.each_codepoint {|l|sum += l*l}
    sum.to_s
  end

end
