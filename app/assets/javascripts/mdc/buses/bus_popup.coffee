class MDC.Buses.BusPopup
  constructor: (value)->
    @helper    = @get_helper()
    @value     = value
    @container = @helper.container
    @element   = @helper.new_element(value)
    @visible   = true

  update_location: ->
    if @visible
      @element.css {left: @helper.mouse_x, top: @helper.mouse_y}

  show: ->
    @element.show()
    @visible = true
    @helper.call_this_on_mouse_move = => @update_location()

  hide: ->
    @element.hide()
    @visible = false

  get_helper: ->
    MDC.Buses.BusPopup.helper ||= do ->
      new MDC.Buses.BusPopup.Helper

class MDC.Buses.BusPopup.Helper
  call_this_on_mouse_move: ->

  constructor: ->
    @mouse_x = 0
    @mouse_y = 0

    @find_elements()
    @bind_elements()

  find_elements: ->
    @container = $$('map-container')
    @template  = $$('bus-popup-template')
#    @template.remove()
    @template.removeAttr('id')
    @value_element = @template.find('.bus-number')

  bind_elements: ->
    $(window).mousemove (e)=>
      @mouse_x = e.pageX
      @mouse_y = e.pageY
      @call_this_on_mouse_move()

  new_element: (value)->
    @value_element.text value
    e = @template.clone()
    @container.append e
    e