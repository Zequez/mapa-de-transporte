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
    @elements = []
    @directions = []

    @find_elements()
    @setup_template()

  find_elements: ->
    @container   = $$('buses-directions')
    @template_e  = $$('bus-direction-template')
    @list        = $$('list-of-directions')

  setup_template: ->
    @template_e.remove()
    @template_e.removeAttr('id')
    @template_e.show()
    @template    = new DirectionsInterfaceElementTemplate(@template_e)

  # Called from PathFinder
  set_directions: (directions)->
    @directions = directions
    @create_elements()

  create_elements: ->
    element.remove() for element in @elements

    @elements = []

    for direction in @directions
      element = new DirectionsInterfaceElement(direction, @template, @list)
      direction.set_interface_element element
      @elements.push element

class DirectionsInterfaceElementTemplate
  constructor: (element)->
    @element       = element
    @bus_name      = @element.find('.bus-name-value')
    @walk_distance = @element.find('.walking-distance-value')
    @bus_distance  = @element.find('.route-distance-value')

  set_values: (bus_name, walk_distance, bus_distance)->
    @bus_name[0].innerHTML = bus_name
    @walk_distance[0].innerHTML = walk_distance
    @bus_distance[0].innerHTML = bus_distance

  create: (bus_name, walk_distance, bus_distance)->
    @set_values(bus_name, walk_distance, bus_distance)
    @element.clone()


class window.DirectionsInterfaceElement extends Eventable
  constructor: (direction, template, parent)->
    @direction = direction
    @template = template
    @parent = parent
    @create_element()

    @bind_element_events()
    @attach_element()

  create_element: ->
    @element = @template.create(@direction.bus_name,
                                @direction.real_walking_distance,
                                parseInt(@direction.real_route_distance / 10) / 100) # We get the distance in meters

  bind_element_events: ->
    @element.mouseover => @fire_event('mouseover')
    @element.mouseout => @fire_event('mouseout')

  attach_element: ->
    @parent.append @element

  remove: ->
    @element.remove()
    @delete_events()
    

