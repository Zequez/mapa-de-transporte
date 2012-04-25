class window.CheckpointsManager extends Eventable
  # Events
  # - checkpoint_added
  # - checkpoint_removed
  # - checkpoint_replaced
  # - checkpoint_changed
  # - checkpoint_direction_mouseover
  # - checkpoint_direction_mouseout

  constructor: (map)->
    @map = map
    @checkpoints = []
    @checkpoints_directions = []

    @bind_map_events()

  bind_map_events: ->
    $G.event.addListener @map.gmap, "click", (event)=>
      point = event.latLng
      @add_checkpoint(point)

  add_checkpoint: (latlng)->
    if @checkpoints.length >= Settings.max_path_finder_checkpoints
      @fire_event('checkpoint_replaced', @checkpoints[0])
      @remove_checkpoint @checkpoints[0]

    checkpoint = new Checkpoint(@map, latlng, @checkpoints.length+1)

    @checkpoints.push checkpoint
    @bind_checkpoint(checkpoint)

    @remove_directions()
    @fire_event('checkpoint_added')


  bind_checkpoint: (checkpoint)->
    checkpoint.add_listener 'closed', =>
      @remove_checkpoint checkpoint
      @remove_directions()
      @fire_event('checkpoint_removed', checkpoint)
    checkpoint.add_listener 'changed', =>
      @remove_directions()
      @fire_event('checkpoint_changed', checkpoint)
  
  remove_checkpoint: (checkpoint)->
    index = @checkpoints.indexOf(checkpoint)
    if index != -1
      @checkpoints.splice index, 1
      
    if index != @checkpoints.length
      @update_checkpoints_numbers()

    checkpoint.remove()

  update_checkpoints_numbers: ->
    for i, checkpoint of @checkpoints
      checkpoint.set_number(parseInt(i)+1)

  show: ->
    for checkpoint in @checkpoints
      checkpoint.hide()

  hide: ->
    for checkpoint in @checkpoints
      checkpoint.show()

  count: ->
    @checkpoints.length

  set_directions: (checkpoints_directions)->
    @checkpoints_directions = checkpoints_directions
    @bind_checkpoints_directions()

  bind_checkpoints_directions: ->
    for checkpoint_direction in @checkpoints_directions
      checkpoint_direction.add_listener 'mouseover', =>
        @fire_event('checkpoint_direction_mouseover', checkpoint_direction)
      checkpoint_direction.add_listener 'mouseout', =>
        @fire_event('checkpoint_direction_mouseout', checkpoint_direction)
        

  # Called each times there is a change on the checkpoints
  remove_directions: ->
    for checkpoint_direction in @checkpoints_directions
      checkpoint_direction.remove()
    @checkpoints_directions = []
    
