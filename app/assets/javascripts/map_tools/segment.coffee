class MapTools.Segment
  p1: null
  p2: null

  latlng1: null
  latlng2: null

  constructor: (@p1, @p2, @latlng1, @latlng2)->
    @create_latlng()
    @calculate_vars()

  create_latlng: ->
    @latlng1 ||= $LatLng @p1
    @latlng2 ||= $LatLng @p2

  calculate_vars: ->
    @x1 = @p1[0]
    @y1 = @p1[1]
    @x2 = @p2[0]
    @y2 = @p2[1]

    @dx = @x2-@x1
    @dy = @y2-@y1

    @slope = @dy / @dx
    @angle = (180/Math.PI) * Math.atan2(@y2-@y1, @x2-@x1)
    @angle += 360 if @angle < 0
    @distance = Math.sqrt(@dx*@dx + @dy*@dy)

  mapize: ->
    console.log "MapTools.Segment#mapize DEPRECATED, use #create_latlng instead"
    @create_latlng()

  interpolate: (fraction)->
    [@dx*fraction + @x1, @dy*fraction + @y1]

  interpolations: (how_many, first, last)->
    points = []
    points.push @p1 if first

    to = how_many
    ++how_many
    for i in [1..to]
      fraction = i/how_many
      points.push @interpolate(fraction)

    points.push @p2 if last

    points

  travel_x_distance: (distance)->
    return this if not distance
    new MapTools.Segment @interpolate(distance/@distance), @p2

  middle_point: -> @interpolate(0.5)

  middle_latlng: -> $LatLng @middle_point()

  closest_point: (p)->
    p1 = @p1
    p2 = @p2
    p3 = p

    xd = p2[0] - p1[0]
    yd = p2[1] - p1[1]

    if xd == 0 && yd == 0
      closest = p1
    else
      u = ( (p3[0] - p1[0]) * xd + (p3[1] - p1[1]) * yd ) / (xd * xd + yd * yd)

      if u < 0
        closest = p1
      else if u > 1
        closest = p2
      else
        closest = [p1[0] + u * xd, p1[1] + u * yd]

    return new MapTools.Segment(p3, closest)


  distance_in_meters: ->
    return @_distance_in_meters if @_distance_in_meters
    @_distance_in_meters = $G.geometry.spherical.computeDistanceBetween(@latlng1, @latlng2)

  path: ->
    [@latlng1, @latlng2]

#class MapTools.Point
#  constructor: (point)->
#    @p = point
#    @x = point[0]
#    @y = point[1]
#
#  sum: (point)->
#    new MapTools.Point [@x + point.x, @y + point.y]
#
#  res: (point)->
#    new MapTools.Point [@x - point.x, @y - point.y]
#
#  mul: (value)->
#    new MapTools.Point [@x * value, @y * value]
#
#  div: (value)-> @mul(1/value)
#
#  dot: (point)->
#    @x*point.x + @y*point.y