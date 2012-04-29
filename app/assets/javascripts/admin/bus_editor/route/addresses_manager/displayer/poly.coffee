class BusEditor.Route.AddressesManager.Displayer.Poly extends BusEditor.Route.AddressesManager.Displayer.Base
  constructor: (gmap, @results, highlighted)->
    super(gmap, highlighted)

  build_element: ->
    @element = new $G.Polyline @default_options()

  options: ->
    _.extend super, {
      path: @create_path(),
      strokeColor: 'green',
      strokeOpacity: 0.75,
      strokeWeight: 1
    }

  highlighted_options: ->
    _.extend @options(), {
      strokeOpacity: 1,
      strokeWeight: 2
    }

  create_path: ->
    p0 = [@results[0].lat(), @results[0].lng()]
    p1 = [@results[1].lat(), @results[1].lng()]

    segment = new Segment(p0, p1, @results[0], @results[1])

    [$LatLng(segment.interpolate(-5)), $LatLng(segment.interpolate(6))]
