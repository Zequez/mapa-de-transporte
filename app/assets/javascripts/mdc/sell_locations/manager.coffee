class MDC.SellLocations.Manager extends Utils.Eventable
  constructor: (data, @map)->
    @gmap = @map.gmap
    @build_ui()
    @build_displayer(data)
    @bind_displayer()
    @bind_ui()
    @read_initial_state()
    @build_interface_list()

  build_displayer: (data)->
    @displayer = new MDC.SellLocations.Displayer(data, @gmap)

  bind_displayer: ->
    @displayer.add_listener 'edit', (data, marker)=>
      @build_suggestion(data, marker)

  build_suggestion: (data, marker)->
    @displayer.hide()

    if @suggestion and @suggestion.is_the_same(data)
      @suggestion.show()
    else
      @suggestion.destroy() if @suggestion
      @suggestion = new MDC.SellLocations.Suggestion.Builder(data, @gmap)
      @bind_suggestion()

  bind_suggestion: ->
    @suggestion.add_listener 'close', =>
      @suggestion.hide()
      @displayer.show()

  build_ui: ->
    @ui = new MDC.SellLocations.UI()

  bind_ui: ->
    @ui.add_listener 'activated', =>
      @displayer.show()
      @fire_event('activated')

    @ui.add_listener 'deactivated', =>
      @displayer.hide()
      @fire_event('deactivated')

  read_initial_state: ->
    if @ui.activated
      @displayer.show()

  build_interface_list: ->
    # If it started activated it means that there is a list...
    if @ui.activated
      @list = new MDC.SellLocations.ToolbarList

#$ ->
#  start = ->
#    window.manager = new MDC.SellLocations.Manager([
#      {address: "España 3444", name: "Casa vieja", lat: -38, lng: -57.3, info: "Mi casa", card_reloading: true},
#      {address: "España 3182", name: "Casa nueva", lat: -38, lng: -57.4, info: "Mi casa nueva", card_selling: true}
#    ], window.ASD.city.map.gmap)
#
#    console.log "created."
#
#  loopme = ->
#    if typeof ASD != "undefined"
#      start()
#    else
#      setTimeout(loopme, 50)
#
#  loopme()

