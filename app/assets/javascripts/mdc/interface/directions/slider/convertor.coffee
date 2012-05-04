class MDC.Interface.Directions.Slider.Convertor
  constructor: (@default_value, @min, @max, @position, @default_min_bound, @default_max_bound, @element)->


  set_default_value: (value)->
    @default_value = value
    @set_value(value)

  set_value: (value)->
    console.log value

    if value < @min
      value = @min
    else if value > @max
      value = @max

    if value != @value
      @value = value
      @recalculate_position()
      true
    else
      false

  recalculate_value: ->
    @value = parseInt((((@position - @min_bound) / @bound_range) * @range) / 10) * 10

  set_position: (position)->
    if position < @min_bound
      position = @min_bound
    else if position > @max_bound
      position = @max_bound


    if position != @position
      @position = position
      @recalculate_value()
      true
    else
      false

  recalculate_position: ->
    @position = parseInt( ((@value - @min) / @range) * @bound_range + @min_bound )

  set_bounds: (min_bound, max_bound)->
    @default_min_bound = min_bound
    @default_max_bound = max_bound
    @update_bounds()

  update_bounds: ->
    element_width = @element.width()
    @min_bound = @default_min_bound
    @max_bound = @default_max_bound
    @max_bound -= element_width if @max_bound > element_width
    @bound_range = @max_bound - @min_bound
    @recalculate_position()

  set_min_max: (min, max)->
    @min = parseInt( min / 10 ) * 10
    @max = parseInt( (max + 9.99) / 10 ) * 10
    @range = @max - @min

    @set_value(@default_value)