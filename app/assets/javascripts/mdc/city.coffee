class MDC.City
  buses: []

  constructor: (data)->
    #@data = data # (Don't save all the data in a variable, better for obfuscation...)
    @find_element()

    @build_toggleables()
    @build_map(data)
    @build_help_bar()
    @build_url_rewriter()
    @build_bus_info()
    @build_sell_locations_manager(data)

    @build_buses_manager(data)
    @build_directions_manager()
    @build_adsense()



  find_element: ->
    @element = @e = $$('map')

  build_toggleables: ->
    @social_toggle = new MDC.Interface.Toggleable($$("follow-us"), "show_social")
    @social_toggle = new MDC.Interface.Toggleable($$("toolbar-google-adsense"), "show_adsense")


  build_map: (data)->
    @map = new MapTools.Map(@element, data["viewport"])
    @gmap = @map.gmap

  build_url_rewriter: ->
    @url_rewriter = new MDC.Interface.UrlRewriter(@buses_manager, @sell_locations_manager)

  build_help_bar: ->
    @help_bar = new MDC.Interface.HelpBar

  build_buses_manager: (data)->
    @buses_manager = new MDC.Buses.Manager(data["bus_groups"], @url_rewriter, @gmap)
    @buses = @buses_manager.buses

  build_bus_groups: (data)->
    @bus_groups = for bus_group in data["bus_groups"]
      bus_group = new MDC.Buses.Group bus_group, this, @gmap
      @buses = @buses.concat bus_group.buses
      bus_group


  build_directions_manager: ->
    @directions_manager = new MDC.Directions.Manager(@map, @buses_manager, @buses)

  build_sell_locations_manager: (data)->
    @sell_locations_manager = new MDC.SellLocations.Manager(data["visible_sell_locations"], @url_rewriter, @gmap)

  build_bus_info: ->
    @bus_info = new MDC.Interface.BusInfo()

  build_adsense: ->
    @adsense = new MDC.Adsense(@gmap)