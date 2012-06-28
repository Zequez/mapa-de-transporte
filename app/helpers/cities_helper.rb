module CitiesHelper
  def sell_points_in_url?
    Rails.logger.warn "CitiesHelper#sell_points_in_url? deprecated, use CitiesHelper#sell_locations_in_url?"
    sell_locations_in_url?
  end
  
  def sell_locations_in_url?
    # TODO: Do a better implementation
    params[:sell_locations]
  end
  
  def ticket_locations_in_url?
    # TODO: Do a better implementation
    params[:ticket_locations]
  end
end
