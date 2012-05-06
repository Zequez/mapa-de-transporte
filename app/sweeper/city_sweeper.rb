class CitySweeper < ActionController::Caching::Sweeper
  observe Bus, BusGroup, City, Domain

  def after_save(record)
    city = record.is_a?(City) ? record : record.city

    if city
      city.domains.each do |domain|
        expire_fragment %r{cities/#{domain.name}}
      end

      expire_fragment %r{cities/#{city.to_param}}
    end
  end
end