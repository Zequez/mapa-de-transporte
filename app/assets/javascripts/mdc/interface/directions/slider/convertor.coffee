class MDC.Interface.Directions.Slider.Convertor
  position: 0
  
  constructor: (@default_value, @min, @max, @default_min_bound, @default_max_bound, @element)->
    @update_bounds()
    @set_min_max(@min, @max)

#  set_default_value: (value)->
#    console.log "Set default value", value
#    @default_value = value
#    @set_value(value)

  set_value: (value)->
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
    @value = parseInt((((@position - @min_bound) / @bound_range) * @range) / 10) * 10 + @min

  set_position: (position)->
    if position < @min_bound
      position = @min_bound
    else if position > @max_bound
      position = @max_bound

    if position != @position
      @position = position
      @recalculate_value()
      @default_value = @value # We set this because we explicitly changed the value
      true
    else
      false

  recalculate_position: ->
    @update_bounds()
    @position = parseInt( ((@value - @min) / @range) * @bound_range + @min_bound )

  update_bounds: ->
    element_width = @element.width()
    @min_bound = @default_min_bound
    @max_bound = @default_max_bound
    @max_bound -= element_width if @max_bound > element_width
    @bound_range = @max_bound - @min_bound
    @default_bound_range = @default_max_bound - @default_min_bound

  set_min_max: (min, max)->
    @min = parseInt( ( min + 10 ) / 10 ) * 10
    @max = parseInt( ( max + 20 ) / 10 ) * 10
    @range = @max - @min

    if not @set_value(@default_value)
      @recalculate_position()