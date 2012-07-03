# Events
# - select
# - hover

class SellLocationsReviews.Suggestion extends Utils.Eventable
  constructor: (@form_element, @gmap)->
    @build_form()
    @bind_form()
    @build_marker()
    @hidden = false

  build_form: ->
    @form = new SellLocationsReviews.SuggestionForm(@form_element)

  bind_form: ->
    @form.add_listener 'close', =>
      @form.hide()
      @marker.hide() if @marker

    @form.add_listener 'select', (name, value)=>
      @fire_event('select', name, value)

    @inherit_listener @form, 'hover'

    @form.add_listener 'toggle', =>
      if @hidden
        @show()
      else
        @hide()

  hide: ->
    @hidden = true
    @form.hide()
    @marker.hide() if @marker

  show: ->
    @hidden = false
    @form.show()
    @marker.show() if @marker

  build_marker: ->
    position = @form.get_position()
    if position
      @marker = new SellLocationsReviews.Marker(@gmap, position)
      @marker.draggable false
    else
      @marker = null

  unhighlight: ->
    @marker.unhighlight() if @marker

  highlight: ->
    @marker.highlight() if @marker
  