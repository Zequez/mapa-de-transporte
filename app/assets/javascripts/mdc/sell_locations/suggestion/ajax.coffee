# Events
# - start
# - stop
class MDC.SellLocations.Suggestion.Ajax extends Utils.Eventable
  constructor: ->
    @loading = false
    @send_count = 0

  send: (data, callback)->
    ++@send_count
    send_count = @send_count

    if not @loading
      @loading = true
      @fire_event('start')

    handle_response = (response)=>
      if send_count == @send_count
        response = $(response)
        @loading = false
        @fire_event('stop', response)
        callback(response) if callback

    $.post("/sell_locations_suggestions", data, (response)=>
      handle_response(response)
    ).error => handle_response('<p>Error :[</p>')