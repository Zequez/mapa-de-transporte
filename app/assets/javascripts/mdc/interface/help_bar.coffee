class MDC.Interface.HelpBar
  constructor: ->
    @find_elements()
    @build_toggle()
#    @bind_elements()
#
#    if not @toggle.activated
#      @hide()

  find_elements: ->
    @tooltips       = $('#tooltips')
#    @close    = @tooltips.find('.close')


  build_toggle: ->
    ### POISON ###
#    MDC.SegmentCalculator.distance()
    
    @toggle = new MDC.Interface.Toggleable(@tooltips, "help_tips")


#  bind_elements: ->
#    @toggle.add_listener 'activated', =>
#
#    @close.click => @toggle()
#    @toggle_element.click => @toggle()
#
#
#  toggle: ->
#    if @visible
#      @hide()
#    else
#      @show()
#
#    @set_cookie()
#
#  show: ->
#    @visible = true
#    @tooltips.show()
#    @toggle_element.addClass 'toggled'
#
#
#  hide: ->
#    @visible = false
#    @tooltips.hide()
#    @toggle_element.removeClass 'toggled'
#
#
#  set_cookie: ->
#    MDC.SETTINGS.set('help_tips', @visible)
