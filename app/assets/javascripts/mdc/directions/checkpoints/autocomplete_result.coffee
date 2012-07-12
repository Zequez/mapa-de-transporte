class MDC.Directions.Checkpoints.AutocompleteResult extends Utils.Eventable
  constructor: (@option, @content, @hard)->
    @build_element()
    @bind_element()

  update: (@content, @hard)->
    @element.html @content

  build_element: ->
    @element = $("<li>#{@content}</li>")
    @bind_element()

  bind_element: ->
    @element.mousedown (e)=>
      @fire_event("click")
      e.preventDefault()

  append_to: (element)->
    @element.appendTo element

  highlight: ->
    @element.addClass "active"

  unhighlight: ->
    @element.removeClass "active"

  destroy: ->
    @element.remove()
    @element.unbind()
    @delete_events()




