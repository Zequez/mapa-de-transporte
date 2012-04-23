class window.AdminRoute extends Eventable
  constructor: (map, data, element_name, color)->
    @map  = map
    @color = color
    @data = data
    @name = element_name
    @find_elements()
    @bind_elements()
    @build_route()

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
    @route = new BusRouteInputsHandler(@map, @e, {strokeColor: @color})

  edit: ->
    @show_tab()
    @route.start_editing()

  stop_edit: ->
    @hide_tab()
    @route.stop_editing()

  hide_tab: ->
    @e.hide()

  show_tab: ->
    @e.show()

