class MDC.Directions.Controls.Builder
  constructor: ->
    @create_slider()
    @bind_slider()

  create_slider: ->
    @slider = new MDC.Directions.Controls.Slider.Manager(MDC.SETTINGS.read["max_walking_distance"])

  bind_slider: ->
    @slider.add_listener 'change', (value)=>
      MDC.SETTINGS.set('max_walking_distance', value)
    
    