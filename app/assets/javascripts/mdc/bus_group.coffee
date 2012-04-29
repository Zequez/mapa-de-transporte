class MDC.BusGroup
  constructor: (data, city)->
    @data = data
    @city = city

    @build_button()
    @build_buses()

    @bind_button()

  build_button: ->
    @button = new MDC.Interface.BusButton("group-#{@data.id}")

  build_buses: ->
    @buses = for bus in @data.visible_buses
      new MDC.Bus bus, this

  bind_button: ->
    @button.add_listener 'toggled', =>
      if @button.activated
        @activate_buses()
      else
        @deactivate_buses()

  activate_buses: ->
    bus.show() for bus in @buses

  deactivate_buses: ->
    bus.hide() for bus in @buses

  deactivate: ->
    @button.deactivate()

  activate: ->
    @button.activate()