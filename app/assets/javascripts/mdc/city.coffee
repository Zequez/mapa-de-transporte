class MDC.City
  buses: []

  constructor: (data)->
    #@data = data # (Don't save all the data in a variable, better for obfuscation...)
    @find_element()

    @build_toggleables()
    @build_map(data)
    @build_help_bar()
    @build_url_helper()
    @build_bus_info()
    @build_sell_locations_manager(data)

    @build_address_fetcher(data)

    @build_buses_manager(data)
    @build_directions_manager()
    @build_adsense()



  find_element: ->
    @element = @e = $$('map')

  build_toggleables: ->
    @social_toggle = new MDC.Interface.Toggleable($$("social"), "show_social")
    @social_toggle = new MDC.Interface.Toggleable($$("toolbar-google-adsense"), "show_adsense")

  build_map: (data)->
    @map = new MapTools.Map(@element, data["viewport"])
    @gmap = @map.gmap

  build_url_helper: ->
    @url_helper = new MDC.Interface.UrlHelper(@buses_manager, @sell_locations_manager)

  build_help_bar: ->
    @help_bar = new MDC.Interface.HelpBar

  build_buses_manager: (data)->
    @buses_manager = new MDC.Buses.Manager(data["bus_groups"], @url_helper, @gmap)
    @buses = @buses_manager.buses

  build_directions_manager: ->
    @directions_manager = new MDC.Directions.Manager(this, @buses_manager, @url_helper)

  build_sell_locations_manager: (data)->
    @sell_locations_manager = new MDC.SellLocations.Manager(data["visible_sell_locations"], @url_helper, @gmap)

  build_address_fetcher: (data)->
    @address_fetcher = new MDC.AddressFetcher(data)

  build_bus_info: ->
    @bus_info = new MDC.Interface.BusInfo()

  build_adsense: ->
    @adsense = new MDC.Adsense(@gmap)