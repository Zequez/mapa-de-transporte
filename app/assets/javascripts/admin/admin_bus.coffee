class window.AdminBus
  constructor: (data)->
    @data = data
    @build_map()
    @build_routes()
    @bind_routes()

  find_element: ->

  build_map: ->
    @map = new Map($$('map'), @data.city.viewport)

  build_routes: ->
    @departure_route = new AdminRoute(@map, @data.departure_route, "departure_route", "red")
    @return_route    = new AdminRoute(@map, @data.return_route,    "return_route", "blue")
    @return_route.stop_edit()

  bind_routes: ->
    @departure_route.add_listener 'change_tab', =>
      @departure_route.stop_edit()
      @return_route.edit()

    @return_route.add_listener 'change_tab', =>
      @return_route.stop_edit()
      @departure_route.edit()
