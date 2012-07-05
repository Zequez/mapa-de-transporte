class MDC.Interface.UrlRewriter
  constructor: ->
    if window.history.replaceState
      @enabled = true
      @set_base_url()
#      @bind_buses()
#      @bind_sell_locations()
    else
      @enabled = false

  set_base_url: ->
    @base_url = location.pathname.match(/\/[^/]+/)

  set_url: (value)->
    new_url = "#{@base_url}/#{value}"
    window.history.replaceState(false, false, new_url)

  bind_buses: ->
    for bus in @buses
      bus.add_listener 'activated deactivated', => @timeout_rewrite_url()

  bind_sell_locations: ->
    @sell_locations_manager.add_listener 'activated',   => @rewrite_sell_locations_url()
    @sell_locations_manager.add_listener 'deactivated', => @reset_url()


  get_buses_names: ->
    names = []
    for bus in @buses
      if bus.activated
        names.push bus.data["perm"]
    names.join(MDC.CONFIG.url_buses_join)

  # TODO: I don't know if this is the best approach, but it works, for now.
  timeout_rewrite_url: ->
    clearTimeout @last_timeout if @last_timeout
    @last_timeout = setTimeout (=>@rewrite_url()), 200

  rewrite_url: ->
    buses_names = @get_buses_names()
    new_url = "#{@base_url}/#{buses_names}"
    window.history.replaceState(false, false, new_url)

  rewrite_sell_locations_url: ->
    new_url = "#{@base_url}/puntos-de-carga"
    window.history.replaceState(false, false, new_url)

  reset_url: ->
    window.history.replaceState(false, false, @base_url)



