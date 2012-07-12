class MDC.Directions.Checkpoints.Manager extends Utils.Eventable
  # Events
  # - change

  constructor: (@city, @autocomplete_list, @url_helper)->
    @fill_autocomplete_checkpoints()

    @gmap = @city.gmap
    @checkpoints = []
    @inputs      = []
    
    @geolocation      = null
    @last_geolocation = null
    @url_origin       = null
    @url_destin       = null

    @params = @url_helper.params

    @build_autocomplete()
    @address_fetcher = @city.address_fetcher
    @build_inputs()

    @find_buttons()
    @bind_buttons()
    
    @bind_map_events()


  ############
  # Building #
  ############

  fill_autocomplete_checkpoints: ->
    @autocomplete_list = []

  build_autocomplete: ->
    @autocomplete = new MDC.Directions.Checkpoints.Autocomplete(@autocomplete_list)

  build_inputs: ->
    @inputs_elements = $(".checkpoint-input")
    @inputs_elements.each (i, input_element)=>
      marker = new MDC.Directions.Checkpoints.Marker(@gmap, i)
      input  = new MDC.Directions.Checkpoints.Input($(input_element), marker, @autocomplete, @address_fetcher)
      
      @inputs.push input
      @checkpoints.push null
      @bind_input(i, input)

  find_buttons: ->
    @reverse_button = $$("switch-checkpoints")
    @current_position_button = $$("current-position-checkpoint")

  ###########
  # Binding #
  ###########

  bind_buttons: ->
    @reverse_button.click =>
      @reverse_checkpoints()
      @fire_change()
      @write_url()

    @current_position_button.click =>
      @read_geolocation (result)=>
        if result
          i = if not @checkpoints[0]
            0
          else if not @checkpoints[1]
            1
          else
            0

          @inputs[i].set_from_geolocation $LatLng(@geolocation)
          @grab_checkpoint(i)

          @fire_change()
          @write_url()


  bind_map_events: ->
    $G.event.addListener @gmap, "click", (event)=>
      @insert_checkpoint(event.latLng)
      @fire_change()
      @write_url()

  bind_input: (i, input)->
    input.add_listener "change", (checkpoint)=>
      @checkpoints[i] = checkpoint
      @fire_change()
      @write_url()

    input.add_listener "reverse", =>
      @reverse_checkpoints()
      @fire_change()
      @write_url()

    input.add_listener "empty", (checkpoint)=>
      @checkpoints[i] = null
      @fire_change()
      @write_url()

    input.add_listener "focus_next", =>
      index = @inputs.indexOf(input)+1
      if index >= @inputs.length
        index = 0
      @inputs[index].focus()


  ################
  # Some actions #
  ################

  insert_checkpoint: (latlng)->
    for input, i in @inputs
      if not input.checkpoint
        input.set_from_map latlng
        @checkpoints[i] = input.checkpoint
        return

    @shift_checkpoints(latlng)

  shift_checkpoints: (latlng)->
    checkpoint = @new_checkpoint latlng: latlng
    @checkpoints.shift()
    @checkpoints.push(checkpoint)
    
    for input, i in @inputs
      input.set_from_manager @checkpoints[i]
    null

  reverse_checkpoints: ->
    @checkpoints = @checkpoints.reverse()
    for input, i in @inputs
      input.set_from_manager @checkpoints[i]

  write_url: ->
    if @checkpoints[0]
      origin = @checkpoints[0].perm
    if @checkpoints[1]
      destination = @checkpoints[1].perm

    @url_helper.set_directions_city_url origin, destination

  ################
  # Load actions #
  ################

  initial_check: ->
    @set_initial_checkpoints()


  set_initial_checkpoints: ->
    finish = new AsyncronicFinish 2, =>
      if @compact_checkpoints().length > 0
        @fire_change()

    for perm, i in [@params.origin, @params.destination]
      do (i)=>
        if perm
          @inputs[i].set_from_url perm, (result)=>
            if result
              @grab_checkpoint(i)
            finish.finish()
        else if i == 0
          # Check if geolocation changed
          @read_geolocation (result)=>
            latlng = null
            # If changed then set the checkpoint from there.
            if result and @geolocation_changed()
              latlng = $LatLng(@geolocation)
            # If it didn't try to read the initial checkpoint from the settings.
            else if @initial_checkpoint()
              latlng = $LatLng(@initial_checkpoint())

            if latlng
              @inputs[i].set_from_geolocation(latlng)
              @grab_checkpoint(i)

            finish.finish()
        else
          finish.finish()

    null

  geolocation_changed: ->
    if @last_geolocation and @geolocation
      !(@last_geolocation[0] == @geolocation[0] and
      @last_geolocation[1] == @geolocation[1])
    else
      @geolocation != @last_geolocation

  initial_checkpoint: ->
    MDC.SETTINGS.read["initial_checkpoint"]

  read_geolocation: (callback)->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (loc)=>
        lat = loc.coords.latitude
        lng = loc.coords.longitude

        if lat and lng
          @geolocation = [lat, lng]
          @last_geolocation = MDC.SETTINGS.read["last_geolocation"]
          MDC.SETTINGS.set("last_geolocation", [lat, lng])

          callback(true)
      , =>
        callback(false)
    else
      callback(false)





  ##########
  # Helper #
  ##########

  grab_checkpoint: (i)->
    @checkpoints[i] = @inputs[i].checkpoint

  new_checkpoint: (options)->
    new MDC.Directions.Checkpoints.Checkpoint(options)

  fire_change: ->
    if @checkpoints[0]
      MDC.SETTINGS.set("initial_checkpoint", @checkpoints[0].point)
    
    @fire_event "change", @compact_checkpoints()

  compact_checkpoints: ->
    _.compact(@checkpoints)

class AsyncronicFinish
  constructor: (@ammount, @callback)->

  finish: ->
    --@ammount
    if @ammount == 0
      @callback()
