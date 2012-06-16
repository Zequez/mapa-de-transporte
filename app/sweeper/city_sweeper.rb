class CitySweeper < ActionController::Caching::Sweeper
  observe Bus, BusGroup, City

  def after_save(record)
    city = record.is_a?(City) ? record : record.city

    if city
      expire_fragment %r{cities/#{city.to_param}}
    end
  end
end