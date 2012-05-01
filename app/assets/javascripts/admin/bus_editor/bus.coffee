class BusEditor.Bus
  constructor: (data)->
    @data = data
    @build_city()
    @build_routes()
    @bind_routes()

  find_element: ->
    

  build_city: ->
    @city = new BusEditor.City(@data.city)

  build_routes: ->
    @departure_route = new BusEditor.Route(@city, @data.departure_route, "departure_route", "red")
    @return_route    = new BusEditor.Route(@city, @data.return_route,    "return_route", "blue")
    @return_route.stop_edit()
   

  bind_routes: ->
    @departure_route.add_listener 'change_tab', =>
      @departure_route.stop_edit()
      @return_route.edit()

    @return_route.add_listener 'change_tab', =>
      @return_route.stop_edit()
      @departure_route.edit()