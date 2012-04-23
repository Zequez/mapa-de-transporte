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