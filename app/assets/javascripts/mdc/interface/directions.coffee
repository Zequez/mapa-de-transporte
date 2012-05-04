MDC.Interface.Directions = {}

# TODO: Separate all of below in the MDC.Interface.Directions module.

#class AlternativesControl extends Utils.Eventable
#  constructor: ->
#    @max_routes = MDC.SETTINGS.read["max_routes_suggestions"] || 1
#    @find_elements()
#    @bind_elements()
#
#  find_elements: ->
#    @container = $$('add-remove-buses-directions')
#    @plus = @container.find('.plus')
#    @minus = @container.find('.minus')
#
#  bind_elements: ->
#    @plus.click =>
#      MDC.SETTINGS.set('max_routes_suggestions', ++@max_routes)
#      @fire_event('options_updated')
#
#    @minus.click =>
#      MDC.SETTINGS.set('max_routes_suggestions', --@max_routes)
#      @fire_event('options_updated')
#
#
#  show: (ammount, maximum)->
#    if ammount == 0
#      @container.hide()
#    else
#      @container.show()
#
#      minus = plus = false
#
#      if ammount == 1
#        @minus.hide()
#      else
#        @minus.show()
#        minus = true
#
#      if ammount >= maximum
#        @plus.hide()
#      else
#        @plus.show()
#        minus = true
#
#      if plus != minus
#        @container.addClass 'solo'
#      else
#        @container.removeClass 'solo'




