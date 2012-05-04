class MDC.Interface.Directions.Slider.Element extends Utils.Eventable
  # Events
  # - change

  dragging: false
  dragging_position: 0

  constructor: (@options)->
    @o = @options

    @element = @o.element
    @find_elements()
    @bind_element()

    @build_convertor()

    @global_offset = @o.global_offset

    @update_value()
    @change_element_position() # After we build the convertor we have the position for the element.

  rebuild: (options)->
    @o = @options = _.extend @options, options

    @global_offset = @o.global_offset

    @build_convertor()

    @update_value()
    @change_element_position()

  build_convertor: ->
    @convertor = new MDC.Interface.Directions.Slider.Convertor(@o.value, @o.min, @o.max, @o.min_bound, @o.max_bound, @element)

  find_elements: ->
    @window = $(window)
    @value_element = @element.find('.slider-number')

  bind_element: ->
    @element.mousedown (e)=> @start_dragging(e)

  start_dragging: (e)->
    @dragging = true
    @dragging_position = e.offsetX || e.pageX - @element.offset().left
    @window.one 'mouseup', => @stop_dragging()
    @window.mousemove (e)=>
      @dragging_move(e)
      if not @dragging
        @window.unbind(e)
      return
    return

  dragging_move: (e)->
    value = e.pageX - @global_offset - @dragging_position
    if @set_element_position(value)
      @fire_event('change', @convertor.value)

  stop_dragging: ->
    @dragging = false
    return

  # POSITION

  set_element_position: (value)->
    last_value = @convertor.value
    @change_element_position(value)

    # We check if the value changed, so we can save like 9 out of 10 calls.
    if @convertor.value != last_value
      @update_value()
      true
    else
      false

  change_element_position: (position)->
    @convertor.update_bounds()

    if (not position and position != 0)
      @convertor.recalculate_position()
      @update_element_position()
    else
      @convertor.update_bounds()
      if @convertor.set_position(position)
        @update_element_position()

  update_element_position: ->
#    console.log "Convertor position", @convertor.position
    @element.css left: @convertor.position



  # VALUE

  set_value: (value)->
    @change_value(value)
    @update_element_position()

  change_value: (value)->
    if (not value and value != 0) or  @convertor.set_value(value)
      @update_value()
      true
    else
      false

  update_value: ->
    last_length = @value_element.text().length
    @value_element.text @convertor.value
#    if last_length != @convertor.value.length
#      @convertor.recalculate_position()
#      @update_element_position()

  # MIN MAX

  set_min_max: (min, max)->
#    @convertor.set_min_max(min, max)
#    @update_value()
#    @update_element_position()

  