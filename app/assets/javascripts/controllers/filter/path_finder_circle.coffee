class window.PathFinderCircle extends Eventable
  constructor: (map, latlng, start_radius, number, element)->
    @map = map
    @center = latlng
    @meters_radius = start_radius
    @number = number
    @element = element

    @circle = null
    @suggested_circle = null

    @add_circle_to_map()
    @add_number_to_map()

    @update_x_y()
    @update_radius()
    @bind_circle_events()

    @attach_element()
    @bind_element_events()

  add_circle_to_map: ->
    @circle = new google.maps.Circle @circle_options()
    @suggested_circle = new google.maps.Circle @suggested_circle_options()

  circle_options: ->
    {
      map: @map.gmap,
      center: @center,
      editable: true,
      radius: @meters_radius,
      strokeColor: "#132230",
      fillColor: "#132230",
      strokeOpacity: 0.6,
      fillOpacity: 0.3,
      zIndex: 1
    }

  suggested_circle_options: ->
    _.extend @circle_options(), {
      editable: false,
      strokeOpacity: 0.3,
      fillOpacity: 0.1,
      visible: false,
      zIndex: 0
    }

  add_number_to_map: ->
    @number_marker = new google.maps.Marker @number_options()

  number_options: ->
    {
      map: @map.gmap,
      position: @center,
      flat: true,
      clickable: false,
      icon: NumberIcons.get(@number)
    }

  bind_circle_events: ->
    google.maps.event.addListener @circle, "radius_changed", =>
      @update_radius()
      @fire_event('changed')

    google.maps.event.addListener @circle, "center_changed", =>
      @update_x_y()
      @fire_event('changed')

    google.maps.event.addListener @circle, "rightclick", =>
      @remove()
      @fire_event('deleted')

  attach_element: ->
    @element.set_value(@number)
    @element.append()


  bind_element_events: ->
    @element.add_listener 'deleted', =>
      @remove()
      @fire_event('deleted')

  update_x_y: ->
    @center = @circle.getCenter()
    @number_marker.setPosition @center
    @suggested_circle.setCenter @center
    @hide_suggestion()
    @x = @center.lat()
    @y = @center.lng()

  update_radius: ->
#    bound = @circle.getBounds().getNorthEast()
#    @radius = Math.abs(bound.lat() - @center.lat())
    @hide_suggestion()
    @radius = @circle.getRadius()

  remove: ->
    @circle.setMap(null)
    @suggested_circle.setMap(null)
    @number_marker.setMap(null)
    @element.remove()

  set_number: (number)->
    @number = number
    @number_marker.setIcon(NumberIcons.get(@number))
    @element.set_value(@number)

  show_suggestion: (radius)->
    @suggested_circle.setRadius(radius)
    @suggested_circle.setVisible(true)

  hide_suggestion: ->
    @suggested_circle.setVisible(false)