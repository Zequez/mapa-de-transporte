class AdminCity
  constructor: ->
    @find_elements()
    @build_map()
    @bind_map()

  find_elements: ->
    @e = @element = $$('map')
    @viewport_element = $$('city_json_viewport')
    try
      @viewport = JSON.parse @viewport_element.val()
    catch e
      @viewport = false

  build_map: ->
    @map = new Map(@e, @viewport)

  bind_map: ->
    google.maps.event.addListener @map.gmap, 'bounds_changed', =>
      @set_viewport @map.get_bounds()


  set_viewport: (viewport)->
    @viewport_element.val JSON.stringify(viewport)