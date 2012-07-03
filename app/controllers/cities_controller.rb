class CitiesController < InheritedResources::Base
  actions :show

  #if Rails.env == "production"
    caches_action :show_data, cache_path:  :show_city_qps_cache.to_proc
    #caches_action :show_data, :show
    caches_action :show, cache_path: :show_city_cache.to_proc
  #end
  
  def redirect_to_default
    redirect_to city_path(City.first)
  end

  def show
    @feedback = Feedback.new city: resource
    @buses = resource.set_shown_buses(params[:buses])
    @bus = (@buses.size == 1) ? @buses[0] : nil # Just show the complete bus information if we are displaying just one bus.
    show!
  end

  def show_data
    resource
    render text: @city.to_qps, format: :qps
  end


  # This is tricky because we often don't have an :id
  def show_city_cache
    a = "cities/#{params[:id]}/buses/#{params[:buses]}/sell_locations/#{params[:sell_locations]}"
    #a = {city_domain: (params[:id] || request.host), buses: params[:buses]}
    #a = {id: (params[:id] || request.host), buses: params[:buses]}
    L.l a
    a
  end

  def show_city_qps_cache
    "cities/#{params[:id]}/qps"
  end

  private

  #def redirect_to_user_city
  #  if params[:redirect] and user_city
  #    return redirect_to city_url(user_city)
  #  end
  #end

  def resource
    @city ||= begin
      city = ( from_param_city if params[:id] )
      raise ActiveRecord::RecordNotFound if !city
      city
    end
  end

  def from_param_city
    @city ||= chain.from_param params[:id]
  end

  def domain_city
    @city ||= chain.get_by_domain(request.host)
  end

  def user_city
    @city ||= chain.get_by_user_location('Mar del Plata')
  end

  def chain
    @chain ||= City.for_show
  end
end
