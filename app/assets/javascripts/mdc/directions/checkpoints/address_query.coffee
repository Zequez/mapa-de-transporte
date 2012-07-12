class MDC.Directions.Checkpoints.AddressQuery
  constructor: (@city)->

  fetch: (address, callback)->
    @city.address_fetcher.fetch address, (result)=>
      if result == -1
        # Not found
        callback -1
      else if not result
        # Error
        callback false
      else
        # Found!
        callback new MDC.Directions.Checkpoints.Checkpoint(result, address)
