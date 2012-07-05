class MDC.Directions.DirectionsListing
  constructor: ->
    @find_elements()
    @bind_settings()
    @set_tooltip_number()

  find_elements: ->
    @container   = $$('buses-directions')
    @tooltip     = $$('buses-directions-tooltip')
    @tooltip_no_buses = $$('buses-directions-tooltip-no-buses')
    @tooltip_num = @container.find('.max_walking_distance')
    @list        = $$('list-of-directions')

  bind_settings: ->
    MDC.SETTINGS.add_listener 'change_max_walking_distance', =>
      @set_tooltip_number()

  set_tooltip_number: ->
    @tooltip_num.text MDC.SETTINGS.read['max_walking_distance']

  set_directions: (directions)->
    @list.empty()
    @directions = directions
    for direction in @directions
      direction.append_info_box_to @list
    null

  set_state: (number)->
    if number == -1
      @list.hide()
      @tooltip.show()
      @tooltip_no_buses.hide()
    else if number == 0
      @list.hide()
      @tooltip.hide()
      @tooltip_no_buses.show()
    else if number > 0
      @list.show()
      @tooltip.hide()
      @tooltip_no_buses.hide()
    else

