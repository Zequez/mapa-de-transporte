class MapTools.Map
  constructor: (element, viewport, options = {})->
    @e = element
    @viewport = viewport
    @options = options

    @make_bounds()
    @calculate_center()
    @build_gmap()

  build_gmap: ->
    @gmap = new $G.Map(@e[0], @map_settings())
    @gmap.fitBounds @bounds if @bounds
      
 
  map_settings: ->
    @make_bounds()
    _.extend {
      zoom: 12,
      center: @center,
      mapTypeId: $G.MapTypeId.ROADMAP
    }, @options

  make_bounds: ->
    if @viewport
      @sw = new $G.LatLng @viewport.southwest.lat, @viewport.southwest.lng
      @ne = new $G.LatLng @viewport.northeast.lat, @viewport.northeast.lng
      @bounds = new $G.LatLngBounds(@sw, @ne)
    else
      @bounds = false

  calculate_center: ->
    if @bounds
      @center = @bounds.getCenter()
    else
      @center = new $G.LatLng(0,0)

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