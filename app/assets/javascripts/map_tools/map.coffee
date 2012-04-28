class window.Map
  constructor: (element, viewport)->
    @e = element
    @viewport = viewport
    @g = google.maps

    @make_bounds()
    @calculate_center()
    @build_gmap()

  build_gmap: ->
    @gmap = new @g.Map(@e[0], @map_settings())
    @gmap.fitBounds @bounds if @bounds

  map_settings: ->
    @make_bounds()
    {
      scrollwheel: false,
      zoom: 12,
      center: @center,
      mapTypeId: @g.MapTypeId.ROADMAP,
      backgroundColor: if window.CONFIG then CONFIG.map_background_color else null
    }

  make_bounds: ->
    if @viewport
      @sw = new @g.LatLng @viewport.southwest.lat, @viewport.southwest.lng
      @ne = new @g.LatLng @viewport.northeast.lat, @viewport.northeast.lng
      @bounds = new @g.LatLngBounds(@sw, @ne)
    else
      @bounds = false

  calculate_center: ->
    if @bounds
      @center = @bounds.getCenter()
    else
      @center = new @g.LatLng(0,0)

  get_bounds: ->
    bounds = @gmap.getBounds()
    sw = bounds.getSouthWest()
    ne = bounds.getNorthEast()
    
    {
      southwest: {
        lat: sw.lat(),
        lng: sw.lng()
      },
      northeast: {
        lat: ne.lat(),
        lng: ne.lng()
      }
    }