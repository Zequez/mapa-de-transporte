class window.Segment
  constructor: (p1, p2, latlng1, latlng2)->
    @p1 = p1
    @p2 = p2

    @latlng1 = latlng1
    @latlng2 = latlng2
    
    @calculate_vars()

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
    @latlng1 ||= $LatLng @p1
    @latlng2 ||= $LatLng @p2

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

  middle_point: -> @interpolate(0.5)

  closest_point: (p)->
    a = @p1
    b = @p2

    ap = [p[0]-a[0], p[1]-a[1]]
    ab = [b[0]-a[0], b[1]-a[1]]

    ab2   = ab[0]*ab[0] + ab[1]*ab[1]
    ap_ab = ap[0]*ab[0] + ap[1]*ab[1]


    if ab2 != 0
      t     = ap_ab / ab2
      if t < 0
        t = 0
      else if t > 1
        t = 1
    else
      t = 1

    ab_m_t = [ab[0]*t, ab[1]*t]
    point = [a[0]+ab_m_t[0], a[1]+ab_m_t[1]] # Closest

    new Segment(p, point)

  distance_in_meters: ->
    return @_distance_in_meters if @_distance_in_meters
    @mapize()
    @_distance_in_meters = $G.geometry.spherical.computeDistanceBetween(@latlng1, @latlng2)

  path: ->
    @mapize()
    [@latlng1, @latlng2]