module CitiesHelper
  def sell_points_in_url?
    # TODO: Do a better implementation
    params[:buses] == 'puntos-de-carga'
  end
end
