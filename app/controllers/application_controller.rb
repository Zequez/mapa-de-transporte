class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :city_url

  before_filter :set_locale

  def set_locale
    I18n.locale = :es
  end

  def city_url(city = false)
    if city
      param = "#{city.to_param}/"
    elsif not params[:domain_city]
      param = "#{@city.to_param}/"
    else
      param = ''
    end

    "/#{param}"
  end
end
