class MDC.Directions.Direction.InfoBox extends Utils.Eventable
  element: null

  constructor: (@walk_distances, @route_distance, @buses_names)->


  construct_element: ->
    @build_element()
    @bind_element()

  build_element: ->
    @element = @get_template().clone(@buses_names, @walk_distances, @route_distance)

  bind_element: ->
    @element.mouseover =>
      @fire_event 'mouseover'
      
    @element.mouseout =>
      @fire_event 'mouseout'

  append_to: (element)->
    @construct_element() if not @element
    element.append @element

  show: ->
    @construct_element() if not @element
    @element.show()

  hide: ->
    @element.hide()

  destroy: ->
    if @element
      @element.remove()
      @element.unbind()

  remove: ->
    if @element
      @element.remove()

  get_template: ->
    MDC.Directions.Direction.InfoBox.template ||= do ->
      new MDC.Directions.Direction.InfoBoxTemplate