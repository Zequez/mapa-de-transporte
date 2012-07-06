class MDC.Directions.Controls.Builder
  constructor: ->
    @find_elements()
    @create_toggle()
    @create_slider()
    @bind_slider()

  find_elements: ->
    @container = $$("buses-directions")

  create_toggle: ->
    @toggle = new MDC.Interface.Toggleable(@container, "show_directions")

  create_slider: ->
    @slider = new MDC.Directions.Controls.Slider.Manager(MDC.SETTINGS.read["max_walking_distance"])

  bind_slider: ->
    @slider.add_listener 'change', (value)=>
      MDC.SETTINGS.set('max_walking_distance', value)
    
    