class MDC.Interface.Toggleable
  @settings_var = null
  @element      = null

  constructor: ->
    throw "Error @settings_var" if not @settings_var
    throw "Error @element"      if not @element

    @toggler ||= "h1, h2, .toggle"
    @read_initial_state()
    @find_elements()
    @bind_elements()
    @set_element_state()

  read_initial_state: ->
    @toggled = MDC.SETTINGS.read[@settings_var]

  find_elements: ->
    @element = $(@element)
    @toggle  = @element.find(@toggler)

  bind_elements: ->
    @toggle.click =>
      @toggled = !@toggled
      @set_element_state()
      @save_settings()

  set_element_state: ->
    if @toggled
      @activate()
    else
      @deactivate()


  activate: ->
    @element.addClass 'toggled'

  deactivate: ->
    @element.removeClass 'toggled'

  save_settings: ->
    MDC.SETTINGS.set(@settings_var, @toggled)

