class MDC.SellLocations.UI extends Utils.Eventable
  constructor: ->
    @find_elements()
    @read_state()
    @bind_elements()

  find_elements: ->
    @button = $$('toggle-sell-locations')

  read_state: ->
    @activated = @button.is('.toggled')

  bind_elements: ->
    @button.click =>
      if @read_state()
        @fire_event('deactivated')
        @deactivate()
      else
        @fire_event('activated')
        @activate()

  activate: ->
    @activated = true
    @button.addClass('toggled')

  deactivate: ->
    @activated = false
    @button.removeClass('toggled')
