class MDC.AddressFetcher
  constructor: (city_data)->
    @city    = city_data["name"]
    @country = city_data["country"]
    @region  = city_data["region_tag"]

    @build_geocoder()

  build_geocoder: ->
    @geocoder = new $G.Geocoder()

  fetch: (address_name, callback)->
    @fetching = true
    @geocoder.geocode @options(address_name), (results, status)=>
      if status = "OK"
        if results.length > 0 and results[0].geometry and results[0].geometry.location_type != "APPROXIMATE"
          callback results[0].geometry.location
        else
          callback -1
      else
        callback false


  options: (address_name)->
    {
      address: "#{address_name}, #{@city}, #{@country}",
      region: @region
    }

#  parse_results: (results)->
#    result = results[0]
#
#    console.log "Gathering results from, ", result
#
#    # This doesn't say shit. Is worthless information given by Google.
#    approximated = (result.geometry.location_type == "APPROXIMATE")
#    partial_match = !!result.partial_match
#
#    location = result.geometry.location
#
#    [location, !(approximated || partial_match)]