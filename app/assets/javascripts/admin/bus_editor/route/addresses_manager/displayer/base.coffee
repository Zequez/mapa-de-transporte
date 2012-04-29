class BusEditor.Route.AddressesManager.Displayer.Base
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