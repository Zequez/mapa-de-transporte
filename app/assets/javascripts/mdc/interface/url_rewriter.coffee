class MDC.Interface.UrlRewriter
  constructor: (buses)->
    if window.history.replaceState
      @buses = buses
      @bind_buses()

  bind_buses: ->
    for bus in @buses
      bus.add_listener 'activated deactivated', => @rewrite_url()

  get_buses_names: ->
    names = []
    for bus in @buses
      if bus.activated
        names.push bus.data.name
    names.join(MDC.CONFIG.url_buses_join)

  rewrite_url: ->
    buses_names = @get_buses_names()
    new_url = location.origin + "/" + buses_names
    window.history.replaceState(false, false, new_url)

