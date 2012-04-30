class CitiesController < InheritedResources::Base
  actions :index, :show
  
  #before_filter :redirect_to_user_city, only: :index

  #def index
  #  if params[:redirect] and user_city
  #
  #  else
  #    index!
  #  end
  #end

  def show
    @buses = resource.set_shown_buses(params[:buses])
    @bus = (@buses.size == 1) ? @buses[0] : nil

    show!
  end

  def show_data
    resource
    render 'show.qps', layout: false
  end

  private

  #def redirect_to_user_city
  #  if params[:redirect] and user_city
  #    return redirect_to city_url(user_city)
  #  end
  #end

  def resource
    @city ||= begin
      city = ( from_param_city if params[:id] ) || domain_city
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
