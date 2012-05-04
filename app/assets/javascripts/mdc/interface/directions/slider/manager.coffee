class MDC.Interface.Directions.Slider.Manager extends Utils.Eventable
  # Events
  # - change

  min: 0
  max: 1000

  constructor: (initial_value)->
    @find_elements()

    @build_slider(initial_value)
    @bind_slider()

    @update_slider_info()

  find_elements: ->
    @container = $$('buses-directions-slider')
    @rail      = @container.find('.slider-rail')
    @slider_e  = @container.find('.slider')
    @window    = $(window)

  build_slider: (initial_value)->
    @slider = new MDC.Interface.Directions.Slider.Element(@slider_e, initial_value)

  bind_slider: ->
    @inherit_listener @slider, 'change'

  update_slider_info: ->
    @slider.set_bounds(0, @container.width())
    @slider.set_global_offset(@container.offset().left + 0)
    @slider.set_min_max(@min, @max)
    @slider.init()

  set_min_max: (min, max)->
    @slider.set_min_max(min, max)