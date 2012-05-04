


class MDC.Interface.Directions.Slider.Element extends Utils.Eventable
  # Events
  # - change

  dragging: false
  dragging_position: 0

  default_value: 0
  inited: false

  constructor: (@element, @default_value)->
    @build_convertor()
    @find_elements()
    @bind_element()

  init: ->
    if !@inited
      @inited = true
      @set_value(@default_value, true)

  build_convertor: ->
    @convertor = new MDC.Interface.Directions.Slider.Convertor(@default_value, 0, 0, 0, 0, 0, @element)

  find_elements: ->
    @window = $(window)
    @value_element = @element.find('.slider-number')

  bind_element: ->
    @element.mousedown (e)=> @start_dragging(e)

  start_dragging: (e)->
    @dragging = true
    @dragging_position = e.offsetX
    @window.one 'mouseup', => @stop_dragging()
    @window.mousemove (e)=>
      @dragging_move(e)
      if not @dragging
        @window.unbind(e)
      return
    return

  dragging_move: (e)->
    value = e.pageX - @global_offset - @dragging_position
    @set_element_position(value)

  stop_dragging: ->
    @dragging = false
    return

  set_element_position: (value)->
    @change_element_position(value)
    if @change_value(null, true)
      @fire_event('change', @convertor.value)

  change_element_position: (position)->
    @convertor.update_bounds()

    if (not position and position != 0) or @convertor.set_position(position)
      @update_element_position()

  update_element_position: ->
    @element.css left: @convertor.position

  set_value: (value)->
    @change_value(value)
    @change_element_position()

  change_value: (value, set_default_value)->
    if (not value and value != 0) or
    (if set_default_value then @convertor.set_default_value(value) else @convertor.set_value(value))
      @update_value()
      true
    else
      false

  update_value: ->
    last_length = @value_element.text().length
    @value_element.text @convertor.value
    if last_length != @convertor.value
      @convertor.update_bounds()

      @update_element_position()

  set_global_offset: (global_offset)->
    @global_offset = global_offset

  set_bounds: (min_bound, max_bound)->
    @convertor.set_bounds(min_bound, max_bound)

  set_min_max: (min, max)->
    if @convertor.set_min_max(min, max)
      @update_value()