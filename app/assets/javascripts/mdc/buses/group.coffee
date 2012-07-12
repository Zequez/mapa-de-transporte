class MDC.Buses.Group extends Utils.Eventable
  constructor: (data, @gmap)->
    #@data = data # To obfuscation

    @build_button(data)
    @build_buses(data)

    @bind_button()

  build_button: (data)->
    @button = new MDC.Buses.BusButton("group-#{data["id"]}")

  build_buses: (data)->
    @buses = for bus in data["visible_buses"]
      new MDC.Buses.Bus bus, this, @gmap

  bind_button: ->
    @button.add_listener 'activated', =>
      @fire_event('button_activated', @buses)
      @button.activate()

    @button.add_listener 'deactivated', =>
      @fire_event('button_deactivated', @buses)
      @button.deactivate()

    @button.add_listener 'mouseover', =>
      @fire_event "button_hover", @buses
      
    @button.add_listener 'mouseout', =>
      @fire_event "button_out", @buses

  deactivate: ->
    @button.deactivate()

  activate: ->
    @button.activate()
