class MDC.Interface.Directions.Manager extends Utils.Eventable
  constructor: ->
    @elements = []
    @directions = []

    @find_elements()
    @setup_template()
    @update_tooltip()

    @create_slider()
    @bind_slider()

  find_elements: ->
    @container   = $$('buses-directions')
    @tooltip     = $$('buses-directions-tooltip')
    @template_e  = $$('bus-direction-template')
    @list        = $$('list-of-directions')
    @tooltip_num = @tooltip.find('.max_walking_distance')

  setup_template: ->
    @template_e.remove()
    @template_e.removeAttr('id')
    @template    = new ElementTemplate(@template_e)

  create_slider: ->
    @slider = new MDC.Interface.Directions.Slider.Manager(MDC.SETTINGS.read["max_walking_distance"])

  bind_slider: ->
    @slider.add_listener 'change', (value)=>
      MDC.SETTINGS.set('max_walking_distance', value)
      @update_tooltip()
      @fire_event('options_updated')
  
  # Called from PathFinder
  set_directions: (directions, min_distance, max_distance)->
    @directions = directions
    if min_distance and max_distance
      @slider.set_min_max(min_distance, max_distance)
    @create_elements()

  create_elements: ->
    element.remove() for element in @elements

    @elements = []

    for direction in @directions
      element = new DirectionsElement(direction, @template, @list)
      direction.set_interface_element element
      @elements.push element

    if @directions.length == 0
      @show_tooltip()
    else
      @hide_tooltip()

  update_tooltip: ->
    @tooltip_num.text MDC.SETTINGS.read["max_walking_distance"]

  show_tooltip: ->
    @tooltip.show()

  hide_tooltip: ->
    @tooltip.hide()

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
    