class MDC.Interface.Directions.Slider.Manager extends Utils.Eventable
  # Events
  # - change



  constructor: (@initial_value)->
    @min = MDC.CONFIG.max_walking_distance_min
    @max = MDC.CONFIG.max_walking_distance_max

    @find_elements()

    @build_slider()
    @bind_slider()

    @bind_window()

  find_elements: ->
    @container = $$('buses-directions-slider')
    @rail      = @container.find('.slider-rail')
    @slider_e  = @container.find('.slider')
    @window    = $(window)

  build_slider: (initial_value)->
    @slider = new MDC.Interface.Directions.Slider.Element(@slider_options())

  slider_options: ->
    {
      element: @slider_e,
      value: @initial_value,
      min: @min,
      max: @max,
      min_bound: 0,
      max_bound: @container.width(),
      global_offset: @container.offset().left + 0
    }

  bind_slider: ->
    @slider.add_listener 'change', (value)=> @fire_event('change', value)

  bind_window: ->
    @window.resize =>
      # Some cleanup would be nice, but whatever, is not like I'm going to be constantly resizing the window...
      @build_slider()
      @bind_slider()

  set_min_max: (min, max)->
    @slider.set_min_max(min, max)