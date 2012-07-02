class MDC.SellLocations.Suggestion.FormInputs
  constructor: (@data, @element)->
    @find_inputs()
    @fill_inputs()
    @bind_inputs()

  find_inputs: ->
    @inputs = {}
    for name, value of @data
      input = @find_input(name)
      if input
        @inputs[name] = input

#    console.log "INPUTS!", @inputs
    null

  find_input: (name)->
    input = @element.find("[name*='[#{name}]']").last()
    if input.length > 0
      input
    else
      false

  fill_inputs: ->
    for name, value of @data
      @fill_input name, value

  fill_input: (name, value)->
    input = @inputs[name]
    if input
      if input.prop('type') == 'checkbox'
          input.prop 'checked', value
        else
          input.val value

  bind_inputs: ->
    @settings_listener = MDC.SETTINGS.add_listener 'change', (name, value)=>
      if name == 'user_name' or name == 'user_email'
        @data[name] = value
        @set_val name, value

    @inputs["user_name"].change  => MDC.SETTINGS.set "user_name", @get_val("user_name")
    @inputs["user_email"].change => MDC.SETTINGS.set "user_email", @get_val("user_email")

  set_val: (name, value)->
    @data[name] = value
    @fill_input name, value

  get_val: (name)->
    input = @inputs[name]
    if input
      if input.prop('type') == 'checkbox'
        input.is(':checked')
      else
        input.val()

  update_data: ->
    for name, value of @data
      val = @get_val name
      if val
        @data[name] = val
    null

  set_position: (position)->
    @set_val "lat", position.lat()
    @set_val "lng", position.lng()

  get_data: ->
    @update_data()
    @data

  get_form_data: ->
    @element.serialize()

  replace_element: (element)->
    @destroy()
    @element = element
    @find_inputs()
    @bind_inputs()

  destroy: ->
    @inputs["user_name"].unbind()
    @inputs["user_email"].unbind()

    MDC.SETTINGS.remove_listener 'change', @settings_listener