class window.RouteAddressDisplayer
  visible: true
  highlighted: false
  
  constructor: (@gmap, @highlighted)->
    @build_element()

  options: ->
    {
      map: @gmap,
      clickable: false
    }

  highlighted_options: ->
    @options()

  default_options: ->
    if @highlighted
      @highlighted_options()
    else
      @options()

  show: ->
    @element.setVisible(true) if !@visible
    @visible = true
  hide: ->
    @element.setVisible(false) if @visible
    @visible = false
  highlight:   ->
    @element.setOptions @highlighted_options() if !@highlighted
    @highlighted = true
  unhighlight: ->
    @element.setOptions @options() if @highlighted
    @highlighted = false



class window.SingleRouteAddress extends RouteAddressDisplayer
  constructor: (gmap, @result, highlighted)->
    super(gmap, highlighted)

  build_element: ->
    @element = new $G.Marker @default_options()

  options: ->
    _.extend super, {
      position: @result
    }


class window.PolyRouteAddress extends RouteAddressDisplayer
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
