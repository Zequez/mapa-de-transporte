class MDC.Builder
  constructor: (@data, @encrypted)->
    @build_city()

  build_city: ->
    @city = new MDC.City(@processed_data())

  processed_data: ->
    JSON.parse(@decrypted_data())

  decrypted_data: ->
    return @data if not @encrypted
    # Now do something to decrypt the data, but don't save it in a local variable.
    @data