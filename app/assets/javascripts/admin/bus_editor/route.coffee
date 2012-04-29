class BusEditor.Route extends Utils.Eventable
  constructor: (city, data, element_name, color)->
    @city = city
    @map  = @city.map
    @color = color
    @data = data
    @name = element_name
    @find_elements()
    @bind_elements()
    @build_route()

    @build_addresses_manager()

  find_elements: ->
    @e    = $$(@name)
    @tabs = @e.find('legend a')
    @tab  = @tabs.filter(".#{@name}_tab")
    @reverse_insertion = @e.find('.reverse_insertion')

  bind_elements: ->
    _this = this
    _this.tabs.click ->
      if this != _this.tab[0]
        _this.fire_event('change_tab')

    @reverse_insertion.change =>
      @route.reverse_insertion @reverse_insertion.is(':checked')


  build_route: ->
    @route = new BusEditor.Route.InputsHandler(@map, @e, {strokeColor: @color})

  build_addresses_manager: ->
    @addresses_manager = new BusEditor.Route.AddressesManager(@city, @e)

  edit: ->
    @show_tab()
    @route.start_editing()
    @addresses_manager.show()

  stop_edit: ->
    @hide_tab()
    @route.stop_editing()
    @addresses_manager.hide()

  hide_tab: ->
    @e.hide()

  show_tab: ->
    @e.show()