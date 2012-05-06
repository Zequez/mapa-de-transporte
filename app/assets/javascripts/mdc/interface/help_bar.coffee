class MDC.Interface.HelpBar
  constructor: ->
    @visible = MDC.SETTINGS.read["help_tips"]
    @find_elements()
    @bind_elements()

    if not @visible
      @hide()

  find_elements: ->
    @tooltips = $$('tooltips')
    @close    = @tooltips.find('.close')
    @toggle_element = $$('toggle-help')

#  set_visibility: ->
#    if $$('tooltips').is(':visible')
#      @show()
#    else
#      @hide()


  bind_elements: ->
    ### POISON ###
    MDC.SegmentCalculator.distance()
    @close.click => @toggle()
    @toggle_element.click => @toggle()


  toggle: ->
    if @visible
      @hide()
    else
      @show()

    @set_cookie()

  show: ->
    @visible = true
    @tooltips.show()
    @toggle_element.addClass 'toggled'


  hide: ->
    @visible = false
    @tooltips.hide()
    @toggle_element.removeClass 'toggled'


  set_cookie: ->
    MDC.SETTINGS.set('help_tips', @visible)
