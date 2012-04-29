class MDC.Interface.Directions extends Utils.Eventable
  constructor: ->
    @elements = []
    @directions = []
    @max_directions = 0

    @find_elements()
    @setup_template()

    @create_alternatives_control()

  find_elements: ->
    @container   = $$('buses-directions')
    @tooltip     = $$('buses-directions-tooltip')
    @template_e  = $$('bus-direction-template')
    @list        = $$('list-of-directions')

  setup_template: ->
    @template_e.remove()
    @template_e.removeAttr('id')
    @template    = new ElementTemplate(@template_e)

  create_alternatives_control: ->
    @alternatives_control = new AlternativesControl
    @inherit_listener @alternatives_control, 'options_updated'

  # Called from PathFinder
  set_directions: (directions, max_directions)->
    @directions = directions
    @max_directions = max_directions
    @create_elements()

  create_elements: ->
    element.remove() for element in @elements

    @elements = []

    for direction in @directions
      element = new DirectionsElement(direction, @template, @list)
      direction.set_interface_element element
      @elements.push element

    @alternatives_control.show @directions.length, @max_directions

    if @directions.length == 0
      @show_tooltip()
    else
      @hide_tooltip()

  show_tooltip: ->
    @tooltip.show()

  hide_tooltip: ->
    @tooltip.hide()

# TODO: Separate all of below in the MDC.Interface.Directions module.

class AlternativesControl extends Utils.Eventable
  constructor: ->
    @max_routes = MDC.SETTINGS.read.max_routes_suggestions || 1
    @find_elements()
    @bind_elements()

  find_elements: ->
    @container = $$('add-remove-buses-directions')
    @plus = @container.find('.plus')
    @minus = @container.find('.minus')

  bind_elements: ->
    @plus.click =>
      MDC.SETTINGS.set('max_routes_suggestions', ++@max_routes)
      @fire_event('options_updated')
      
    @minus.click =>
      MDC.SETTINGS.set('max_routes_suggestions', --@max_routes)
      @fire_event('options_updated')

     
  show: (ammount, maximum)->
    if ammount == 0
      @container.hide()
    else
      @container.show()

      minus = plus = false
      
      if ammount == 1
        @minus.hide()
      else
        @minus.show()
        minus = true

      if ammount >= maximum
        @plus.hide()
      else
        @plus.show()
        minus = true

      if plus != minus
        @container.addClass 'solo'
      else
        @container.removeClass 'solo'


class ElementTemplate
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


class DirectionsElement extends Utils.Eventable
  # Events
  # - mouseover
  # - mouseout
  
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
                                parseInt(@direction.real_route_distance / 100) / 10) # We get the distance in meters

  bind_element_events: ->
    @element.mouseover => @fire_event('mouseover')
    @element.mouseout => @fire_event('mouseout')

  attach_element: ->
    @parent.append @element

  remove: ->
    @element.remove()
    @delete_events()
    

