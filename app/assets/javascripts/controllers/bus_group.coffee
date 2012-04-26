class window.BusGroup extends BusButton
  constructor: (data, city)->
    @data = data
    @city = city
    super("bus-group-#{@data.id}")

    @build_buses()

  build_buses: ->
    @buses = for bus in @data.visible_buses
      new Bus bus, this

  after_toggle: ->
    for bus in @buses
      if @activated then bus.activate() else bus.deactivate()