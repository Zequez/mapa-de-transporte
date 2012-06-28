class MDC.Interface.BusInfo extends MDC.Interface.Toggleable
  constructor: ->
    @settings_var = "show_bus_info"
    @element      = "#bus-info"
    super()
#
#    @visible = MDC.SETTINGS.read["show_bus_info"]
#    @find_elements()
#    @bind_elements()
#
#    if not @visible
#      @hide()
#
#  find_elements: ->
#    @e = $$("buses-info")
#    @toggle = @e.find(".toggle")
#    @text_toggled = @toggle.attr("data-toggled")
#    @text_not_toggled = @toggle.attr("data-not-toggled")
#
#  bind_elements: ->
#    @toggle.click =>
#      if @visible # Then hide
#        @hide()
#      else
#        @show()
#
#      @set_cookie()
#
#  hide: ->
#    @visible = false
#    @e.removeClass("toggled")
#    @toggle.html(@text_not_toggled)
#
#  show: ->
#    @visible = true
#    @e.addClass("toggled")
#    @toggle.html(@text_toggled)
#
#  set_cookie: ->
#    MDC.SETTINGS.set("show_bus_info", @visible)

