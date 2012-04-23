class window.Map
  constructor: (element, viewport)->
    @e = element
    @viewport = viewport
    @g = google.maps

    if not @viewport
      @viewport = JSON.parse @e.attr('data-viewport')

    @build_gmap()

  build_gmap: ->
    @gmap = new @g.Map(@e[0], @map_settings())
    @gmap.fitBounds @bounds


  map_settings: ->
    @make_bounds()
    {
      zoom: 12,
      center: @bounds.getCenter(),
      mapTypeId: @g.MapTypeId.ROADMAP,
      backgroundColor: if window.Settings then Settings.map_background_color else null
    }

  make_bounds: ->
    @sw = new @g.LatLng @viewport.southwest.lat, @viewport.southwest.lng
    @ne = new @g.LatLng @viewport.northeast.lat, @viewport.northeast.lng
    @bounds = new @g.LatLngBounds(@sw, @ne)

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