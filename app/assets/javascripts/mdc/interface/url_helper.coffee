class MDC.Interface.UrlHelper
  map_url: {
    origin: "origen"
    destination: "destino"
    sell_locations: "puntos-de-carga"
    ticket_locations: "puntos-de-venta"
    buses: "colectivos"
    city: ""
  }

  url_map: {}



  constructor: ->
    @generate_url_map()
    @read_url()
    @parse_params()
    @last_url = null
    
    if window.history.replaceState
      @rewrite_enabled = true
    else
      @rewrite_enabled = false

  generate_url_map: ->
    # We have to do it like this because of ClosureCompiler
    for i, path of @map_url
      @url_map[path] = i

  read_url: ->
    @sections = location.pathname.split("/")

    if @sections[@sections.length-1] == ""
      @sections.pop()
    
    @params   = {}

    for section, i in @sections by 2
      @params[@url_map[section]] = @sections[i+1] || true

    @base_url = "/#{@params["city"]}/"

  parse_params: ->
    if @params.ticket_locations
      @params.sell_locations = true

  set_url: (url)->
    if @rewrite_enabled
      if url != @last_url
        window.history.replaceState(false, false, url)
        @last_url = url

  make_url: (value)->
    "#{@base_url}#{value}"

  directions_city_url: (origin, destination)->
    url = []
    
    if origin
      url.push @map_url.origin
      url.push origin

    if destination
      url.push @map_url.destination
      url.push destination

    @make_url url.join("/")

  set_directions_city_url: (origin, destination)->
    @set_url @directions_city_url(origin, destination)

  buses_city_url: (buses_perms)->
    @make_url [@map_url.buses, buses_perms.join("+")].join("/")

  set_buses_city_url: (buses_perms)->
    @set_url @buses_city_url(buses_perms)

  sell_locations_city_url: ->
    @make_url @map_url.sell_locations

  set_sell_locations_city_url: ->
    @set_url @sell_locations()

  ticket_locations_city_url: ->
    @make_url @map_url.ticket_locations

  set_ticket_locations_city_url: ->
    @set_url @ticket_locations()
    