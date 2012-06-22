class MDC.SellLocations.UI extends Utils.Eventable
  constructor: ->
    @find_elements()
    @bind_elements()

  find_elements: ->
    @button = $$('toggle-sell-locations')

  bind_elements: ->
    @button.click =>
      if @button.is('.toggled')
        @fire_event('deactivated')
        @deactivate()
      else
        @fire_event('activated')
        @activate()

  activate: ->
    @button.addClass('toggled')

  deactivate: ->
    @button.removeClass('toggled')
