class window.BusRouteInputsHandler
  constructor: (map, container, options)->
    @container = container
    @map = map
    @container = container
#    @create_elements()
    @read_checkpoints()
    @route = new EditableBusRoute @map, @checkpoints, options
    @bind_events()
    
#  create_elements: ->
#    toggler = document.createElement('input')

  read_checkpoints: ->
    @checkpoints_input = @container.find('[name$="[json_checkpoints_attributes]"]')
    @encoded_input     = @container.find('[name$="[encoded]"]')
    @checkpoints       = JSON.parse @checkpoints_input.val()

  bind_events: ->
    google.maps.event.addListener @map.gmap, "mouseout", =>
      @write_checkpoints()

  write_checkpoints: ->
    @checkpoints_input.val JSON.stringify(@route.to_attributes())
    @encoded_input.val @route.encoded()

  start_editing: ->
    @route.editable(true)
    
  stop_editing: ->
    @route.editable(false)

  reverse_insertion: (yes_no)->
    @route.enable_reverse_insertion(yes_no)