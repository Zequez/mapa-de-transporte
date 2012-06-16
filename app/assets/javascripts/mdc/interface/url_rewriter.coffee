class MDC.Interface.UrlRewriter
  constructor: (buses)->
    if window.history.replaceState
      @set_base_url()
      @buses = buses
      @bind_buses()

  set_base_url: ->
    @base_url = location.pathname.match(/\/[^/]+/)

  bind_buses: ->
    for bus in @buses
      bus.add_listener 'activated deactivated', => @timeout_rewrite_url()

  get_buses_names: ->
    names = []
    for bus in @buses
      if bus.activated
        console.log bus.data
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



