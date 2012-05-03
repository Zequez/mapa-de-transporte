class MDC.BusInfo
  constructor: ()->
    @find_elements()
    @bind_elements()

  find_elements: ->
    @e = $$('buses-info')
    @toggle = @e.find('.toggle')
    @text_toggled = @toggle.attr('data-toggled')
    @text_not_toggled = @toggle.attr('data-not-toggled')

  bind_elements: ->
    @toggle.click =>
      hide = @e.is('.toggled')

      if hide
        @e.removeClass('toggled')
        @toggle.html(@text_not_toggled)
      else
        @e.addClass('toggled')
        @toggle.html(@text_toggled)

      MDC.SETTINGS.set('show_bus_info', !hide)

