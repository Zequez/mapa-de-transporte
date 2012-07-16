class MDC.Directions.Direction.BusesIconsOverlay
  constructor: (@bus_data, @color, latlng, map)->
    @latlng_ = latlng
    @map_    = map

    @div_    = null

    @setMap map

  @prototype = new $G.OverlayView()

  onAdd: ->
    # Note: an overlay's receipt of onAdd() indicates that
    # the map's panes are now available for attaching
    # the overlay to the map via the DOM.

    # Create the DIV and set some basic attributes.

    container = document.createElement('div')
    container.style.zIndex      = '99999'
    container.className         = 'bus-icon'

    div = document.createElement('div')
    div.style.backgroundColor = @color.normal
    div.style.borderColor     = @color.dark
    div.innerHTML             = @bus_data["name"]

    if @bus_data["division"]
      span = document.createElement('span')
      span.innerHTML = @bus_data['division']

      div.appendChild span

    container.appendChild div

    # Set the overlay's div_ property to this DIV
    @div_ = container

    # We add an overlay to a map via one of the map's panes.
    # We'll add this overlay to the overlayImage pane.
    panes = @getPanes()
    panes.overlayMouseTarget.appendChild(container)

    @bind()

  bind: ->
    $G.event.addDomListener @div_, 'mouseover', =>
      google.maps.event.trigger(@, 'mouseover')

    $G.event.addDomListener @div_, 'mouseout', => 
      google.maps.event.trigger(@, 'mouseout')


  draw: ->
    # Size and position the overlay. We use a southwest and northeast
    # position of the overlay to peg it to the correct position and size.
    # We need to retrieve the projection from this overlay to do this.
    overlayProjection = @getProjection();

    # Retrieve the southwest and northeast coordinates of this overlay
    # in latlngs and convert them to pixels coordinates.
    # We'll use these coordinates to resize the DIV.
    position = overlayProjection.fromLatLngToDivPixel(@latlng_)

    # Resize the image's DIV to fit the indicated dimensions.
    div            = @div_
    div.style.left = position.x + 'px'
    div.style.top  = position.y + 'px'

  onRemove: ->
    @div_.parentNode.removeChild(@div_)
    @div_ = null

  hide: ->
    @div_.style.visibility = "hidden" if @div_

  show: ->
    @div_.style.visibility = "visible" if @div_

  toggle: ->
    if @div_
      if @div_.style.visibility == "hidden"
        @show()
      else
        @hide()

  toggleDOM: ->
    if @getMap()
      @setMap(null)
    else
      @setMap(@map_)
    