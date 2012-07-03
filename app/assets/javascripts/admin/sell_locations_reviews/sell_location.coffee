class SellLocationsReviews.SellLocation
  constructor: (@gmap)->
    @build_form()
    @build_marker()
    @bind_marker()

  build_form: ->
    @form = new SellLocationsReviews.Form

  build_marker: ->
    @marker = new SellLocationsReviews.Marker(@gmap, @form.get_position())
    @marker.green()

  bind_marker: ->
    @marker.add_listener 'change', (latlng)=>
      @form.set_position(latlng)
      
  get_position: -> @form.get_position()

  set_position: (latlng)-> @form.set_position(latlng)

  update_marker_position: ->
    @marker.set_position @form.get_position()

  set_val: (name, value)->
    @form.set_val(name, value)
    if name == 'lat' or name == 'lng'
      @form.val('manual_position', true)
      @update_marker_position()
