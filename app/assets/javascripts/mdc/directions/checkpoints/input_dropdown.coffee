class MDC.Directions.Checkpoints.InputDropdown extends Utils.Eventable
  constructor: (@element, @autocomplete)->
    @visible    = false
    @results    = []
    @active     = null
    @last_query = ""

  command: (keycode)->
    if @results.length > 0
      if keycode == 40 # Down
        @move_down()
        return true
      else if keycode == 38 # Up
        @move_up()
        return true
      else if keycode == 13 or keycode == 9 # Enter / Tab
        return @select()
    return false

  match: (value)->
    if value != @last_query
      if @last_query and (value.length > @last_query.length)
        @results = @autocomplete.query value, @results
      else
        @empty()
        @results = @autocomplete.query value
        @fill()

      @last_query = value

  fill: ->
    for result in @results
      @bind_result(result)
      result.append_to @element

  bind_result: (result)->
    result.add_listener "click", =>
      @active = result
      @select()

  move_down: -> @move(1)
  move_up:   -> @move(-1)
  move: (up_down)->
    if @active
      @active.unhighlight()

    index = @results.indexOf(@active) # Returns -1 if not found

    index    += up_down
    max_index = @results.length-1

    if index != -1
      if index > max_index
        index = -1
      else if index == -2
        index = max_index

    @active = @results[index]

    if @active
      @active.highlight()

  select: ->
    if @active
      @fire_event "select", @active.option
      true
    else
      false

  hide: ->
    @element.hide()
    @visible = false

  show: ->
    @element.show()
    @visible = true

  empty: ->
    @active = null
    @element.empty()
    @last_query = ""
    result.destroy() for result in @results
