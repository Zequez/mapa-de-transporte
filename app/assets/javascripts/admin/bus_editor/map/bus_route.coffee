#= require ./route

class BusEditor.Map.BusRoute extends BusEditor.Map.Route
  constructor: (_, checkpoints, options)->
    @checkpoints = checkpoints
    super(_, @checkpoints_to_coordinates(), options)

  checkpoints_to_coordinates: ->
    @order_checkpoints()
    for checkpoint in @checkpoints
      [checkpoint.latitude, checkpoint.longitude]

  order_checkpoints: ->
    @checkpoints = @checkpoints.sort (a,b)-> a.number - b.number

  to_attributes: ->
    result = []

    points      = @get_points()
    checkpoints = @checkpoints[0..points.length]
    to_destroy  = @checkpoints[points.length..]

    for i, point of points
      checkpoint = _.clone(@checkpoints[i]) || {}
      checkpoint["latitude"]  = point.lat()
      checkpoint["longitude"] = point.lng()
      checkpoint["number"] = i
      result.push checkpoint

    for checkpoint in to_destroy
      checkpoint = _.clone checkpoint
      checkpoint["_destroy"] = 1
      result.push checkpoint

    result
