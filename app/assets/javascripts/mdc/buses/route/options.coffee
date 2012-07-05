class MDC.Buses.Route.Options
  constructor: (color)->
    @color = color

    @normal_route_options = {
      strokeWeight: 3,
      strokeColor: @color,
      strokeOpacity: 0.75,
      zIndex: @z_index()
      cursor: "default"
    }

    @initial_route_options = _.extend _.clone(@normal_route_options), {
      visible: false
    }

    @highlight_route_options = _.extend _.clone(@normal_route_options), {
      strokeWeight: 6,
      strokeOpacity: 1
    }

  get_highlight_route_options: ->
    @highlight_route_options.zIndex = @z_index()
    @highlight_route_options

  z_index: -> MDC.Helpers.MapZIndex()