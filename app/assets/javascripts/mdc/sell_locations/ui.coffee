class MDC.SellLocations.UI extends Utils.Eventable
  constructor: ->
    @find_elements()
    @read_attributes()
    @bind_elements()

  find_elements: ->
    @button = $$('toggle-sell-locations')

  read_attributes: ->
    @activated = @button.is('.toggled')
    @url       = @button.attr('href')

  bind_elements: ->
    @button.click (e)=>
      if @activated
        @fire_event('deactivated')
        @deactivate()
      else
        @fire_event('activated')
        @activate()

      e.preventDefault()

  activate: ->
    @activated = true
    @button.addClass('toggled')

  deactivate: ->
    @activated = false
    @button.removeClass('toggled')