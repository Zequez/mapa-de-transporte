class BusPopupHelper
  call_this_on_mouse_move: ->

  constructor: ->
    @mouse_x = 0
    @mouse_y = 0
    @current_z_index = 0

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

  z_index: ->
    @current_z_index++

helper = null

class window.BusPopup
  constructor: (value)->
    helper     = new BusPopupHelper if not helper
    @value     = value
    @container = helper.container
    @element   = helper.new_element(value)
    @visible   = true

  update_location: ->
    if @visible
      @element.css {left: helper.mouse_x, top: helper.mouse_y, zIndex: helper.z_index()}

  show: ->
    @element.show()
    @visible = true
    helper.call_this_on_mouse_move = => @update_location()

  hide: ->
    @element.hide()
    @visible = false

  