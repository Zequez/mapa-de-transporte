#class window.PathFilterInterface extends Eventable
#  constructor: ->
#    @find_elements()
#
#  find_elements: ->
#    @circles = $("#filter-circles")
#    @template = @circles.find(".filter-circle")
##    @template.remove()
##    @template.hide()
#
#  create_element: ->
#    new PathFilterIcon(@template.clone(), @circles)
#
#class window.PathFilterIcon extends Eventable
#  constructor: (element, parent)->
#    @parent = parent
#    @element = @e = element
#    @value_element = @element.find('.value')
#    @close_element = @element.find('.close')
#
#    @bind_events()
#
#  set_value: (value)->
#    @value_element.text value
#
#  bind_events: ->
#    @close_element.click => @fire_event('deleted')
#    @element.mouseover   => @fire_event('mouseover')
#    @element.mouseout    => @fire_event('mouseout')
#
#  minimize: ->
#    @element.animate({height: 0, width: 0})
#
#  maximize: ->
#    @element.animate({height: 0, width: 0})
#
#  append: ->
#    @parent.append @element
#    @element.show()
#
#  remove: ->
#    @element.remove()

class window.DirectionsInterface extends Eventable
  constructor: ->
    @find_elements()

  find_elements: ->
#    @container = $$('')

  set_directions: ->
    