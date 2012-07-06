class MDC.Interface.Toggleable

  toggler_class: "toggler"
  toggled_class: "toggled"


  constructor: (@element, @settings_var)->

    @find_elements()
    @read_initial_state()

    @bind_elements()
    @set_element_state()

  find_elements: ->
    toggler_class = ".#{@toggler_class}"
    @toggler = @element.filter(toggler_class).add(@element.find(toggler_class))

  read_initial_state: ->
    if @settings_var
      @is_toggled = MDC.SETTINGS.read[@settings_var]
    else
      @is_toggled = @element.hasClass(@toggled_class)

  bind_elements: ->
    @toggler.click =>
      @is_toggled = !@is_toggled
      @set_element_state()
      @save_settings()

  set_element_state: ->
    if @is_toggled
      @activate()
    else
      @deactivate()


  activate: ->
    @element.addClass @toggled_class

  deactivate: ->
    @element.removeClass @toggled_class

  save_settings: ->
    if @settings_var
      MDC.SETTINGS.set(@settings_var, @is_toggled)

