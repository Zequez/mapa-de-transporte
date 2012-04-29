class BusEditor.Route.AddressesManager.Displayer.Single extends BusEditor.Route.AddressesManager.Displayer.Base
  constructor: (gmap, @result, highlighted)->
    super(gmap, highlighted)

  build_element: ->
    @element = new $G.Marker @default_options()

  options: ->
    _.extend super, {
      position: @result
    }
