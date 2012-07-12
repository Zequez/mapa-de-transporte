# Events
# - keyup
# - input_change
# - change
# - reverse
# - empty

class MDC.Directions.Checkpoints.Input extends Utils.Eventable

  constructor: (@element, @marker, @autocomplete, @address_fetcher, @latlng_convertor)->
    @find_elements()

    @build_dropdown()
    @bind_elements()

  ###########
  # Helpers #
  ###########

  new_checkpoint: (options)->
    new MDC.Directions.Checkpoints.Checkpoint(options)

  fire_empty: ->
    @fire_event "empty"

  fire_change: ->
    @fire_event "change", @checkpoint

  empty: ->
    @checkpoint = null
    @marker.hide()
    @dropdown.empty()
    @input.val ""

  focus: ->
    @input.focus()

  focus_next: ->
    @fire_event("focus_next")

  match_dropdown: ->
    @dropdown.match @input.val()

  only_with_fetched_checkpoint_value: (callback_if_false = false, callback)->
    @checkpoint.fetch_if_not_value @address_fetcher, (result)=>
      if result == true
        callback(true)
      else
        @handle_fetch_fail(result)
        callback(false) if callback_if_false

  handle_fetch_fail: (result)->
    if result == false
      @service_unavailable.show().delay(1000).fadeOut()
    else if result == -1
      @not_found.show().delay(1000).fadeOut()


  #######################
  # Finders and binders #
  #######################

  find_elements: ->
    @input               = @element.find("input")
    @cross               = @element.find(".empty-input")
    @dropdown_element    = @element.find(".checkpoint-autocomplete")
    @service_unavailable = @element.find(".checkpoint-service-unavailable")
    @not_found           = @element.find(".checkpoint-not-found")

  build_dropdown: ->
    @dropdown = new MDC.Directions.Checkpoints.InputDropdown(@dropdown_element, @autocomplete)
    @dropdown.show() if @input.is(":focus")


  bind_elements: ->
    @dropdown.add_listener "select", (option)=>
      @set_from_dropdown(option)
      @match_dropdown()

    # Specially for the Dropdown
    @input.keydown (e)=>
      if @dropdown.command e.keyCode
        e.preventDefault()

      # Well, this is not for the Dropdown,
      # but when the user press enter, then
      # it should go to the next input.
      else if e.keyCode == 13
        @focus_next()

    @input.keyup   (e)=> @match_dropdown()
    @input.blur       => @dropdown.hide()
    @input.focus      => @dropdown.show()

    @input.change => @set_from_input(@input.val())

    @cross.click =>
      @empty()
      @focus()
      @fire_empty()

    # Marker binding

    @marker.add_listener "middleclick", =>
      @fire_event "reverse"

    @marker.add_listener "rightclick", =>
      @empty()
      @fire_empty()

    @marker.add_listener "move", (latlng)=> @set_from_marker(latlng)

  ################
  # Data setters #
  ################

  # When something is selected in the dropdown, this is called.
  set_from_dropdown: (option)->
    @checkpoint = @new_checkpoint(name: option[0], point: option[1])
    @set_marker()
    @set_input()
    @fire_change()
    @focus_next()

  # When the input changes, this is called.
  set_from_input: (value)->
    if not value
      @empty()
      @fire_empty()
    else
      @checkpoint = @new_checkpoint(name: value)
      @only_with_fetched_checkpoint_value false, =>
        @set_marker()
        @fire_change()

  # When the marker is moved, this is called.
  set_from_marker: (latlng)->
    @checkpoint = @new_checkpoint(latlng: latlng)
    @set_input()
    @fire_change()

  # When the map is clicked, this is called from the manager.
  set_from_map: (latlng)->
    @checkpoint = @new_checkpoint(latlng: latlng)
    @set_input()
    @set_marker()

  set_from_geolocation: (latlng)->
    @set_from_map(latlng)

  # When loading the website, or reversing checkpoints, this is called from the manager.
  set_from_manager: (checkpoint)->
    if checkpoint
      @checkpoint = checkpoint
      @set_input()
      @set_marker()
    else
      @empty()

  set_from_url: (perm, callback)->
    @checkpoint = @new_checkpoint(perm: perm, autocomplete: @autocomplete)
    @set_input()
    @only_with_fetched_checkpoint_value true, (result)=>
      if result
        @set_marker()
        callback(true)
      else
        callback(false)

  ####################################
  # Unit data setter from checkpoint #
  ####################################

  set_marker: ->
    @marker.show(@checkpoint.latlng)

  set_input: ->
    @input.val @checkpoint.name
    





