
#class window.BusEditor
#  constructor: (form)->
#    @form = form
#    @find_elements()
#    @create_controls()
#    @bind_events()
#
#    @build_map()
#    @build_bus()
#
#
#  find_elements: ->
#    @departure_container = $(".departure_route")
#    @return_container    = $(".return_route")
#    @toolbar             = $("#toolbar")
#
#  create_controls: ->
#    @selector = $(document.createElement('select'))
#    for route in ["departure", "return"]
#      option = @[route + "_toggle"] = $(document.createElement('option'))
#      option.text {departure: "Departure (Red)", return: "Return (Blue)"}[route]
#      option.val route
#      @selector.append option
#
#    @update_button = $(document.createElement('input'))
#    @update_button.val "Update bus routes"
#    @update_button.attr 'type', 'button'
#
#    @toolbar.append @update_button
#    @toolbar.append @selector
#
#    div = $(document.createElement('label'))
#    div.text 'Reverse insertion: '
#    @reverse_insertion = $(document.createElement('input'))
#    @reverse_insertion.attr 'type', 'checkbox'
#    div.append @reverse_insertion
#    @toolbar.append div
#
#
#  bind_events: ->
#    @selector.change => @change_edit()
#    @update_button.click => @write_out()
#    @reverse_insertion.change => @set_insertion_mode()
#
#  build_map: ->
#    @map     = new Map $("#map")
#
#  build_bus: ->
#    @departure_route = new BusRouteEditor(@map, @departure_container, strokeColor: 'red')
#    @return_route    = new BusRouteEditor(@map, @return_container, strokeColor: 'blue')
#    @change_edit "departure"
#
#  change_edit: (what)->
#    if what
#      @selector.val what
#    else
#      what = @selector.val()
#
#    @departure_route.stop_editing()
#    @return_route.stop_editing()
#    @current_route = @[what + "_route"]
#    @current_route.start_editing()
#
#  write_out: ->
#    @departure_route.write_checkpoints()
#    @return_route.write_checkpoints()
#
#  set_insertion_mode: ->
#    reverse_insertion = @reverse_insertion.is(':checked')
#    @departure_route.reverse_insertion(reverse_insertion)
#    @return_route.reverse_insertion(reverse_insertion)
#
#
#
#$(document).ready ->
#  form = $(".formtastic.bus")
#
#  if form.length > 0
#    window.bus_editor = new BusEditor(form)
#
#  #  checkpoints = [
#  #    {latitude: -37.97322797792998,  longitude: -57.59966472917483,  id: 1, number: 1},
#  #    {latitude: -37.968423947297474, longitude: -57.597604792651396, id: 2, number: 0}
#  #  ]
#
##    form.submit (e)->
##      route.write_checkpoints()
##      e.preventDefault()

window.BusEditor = {}
