#
class MDC.SellLocations.Suggestion.Builder extends Utils.Eventable
  constructor: (@data, @gmap)->
    @build_elements()
    @bind_marker()
    @bind_popup()
    @bind_form()
    @bind_ajax()

  build_elements: ->
    @form   = new MDC.SellLocations.Suggestion.Form(@data)
    @marker = new MDC.SellLocations.Suggestion.Marker(@data, @gmap)
    @popup  = new MDC.SellLocations.Suggestion.Popup(@form, @marker.get_element(), @gmap)
    @ajax   = new MDC.SellLocations.Suggestion.Ajax()

  bind_marker: ->
    @marker.add_listener 'change', (latlng)=>
      @form.set_position(latlng)

  bind_popup: ->
    @form.add_listener 'close', => @fire_event('close')

  bind_form: ->
    @form.add_listener 'submit', (data)=>
      @form.disable()
      @ajax.send data

  bind_ajax: ->
    @ajax.add_listener 'stop', (response)=>
      @form.replace_element(response)

  show: ->
    @popup.show()
    @marker.show()

  hide: ->
    @popup.hide()
    @marker.hide()

  destroy: ->
    @form.destroy()
    @popup.destroy()
    @marker.destroy()

  is_the_same: (data)->
    data.id == @data.id