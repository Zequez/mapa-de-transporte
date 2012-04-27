class window.AddressFetcher
  constructor: (city, country, region)->
    @city = city
    @country = country
    @region = region

    @build_geocoder()

  build_geocoder: ->
    @geocoder = new $G.Geocoder()

  fetch: (address_name, callback)->
    @geocoder.geocode @options(address_name), (results, status)=>
      if status == 'OK'
        callback @parse_result(results[0])
      else
        callback false

  options: (address_name)->
    {
      address: "#{address_name}, #{@city}, #{@country}",
      region: @region
    }

  parse_result: (result)->
    console.log "Parsed result...", result
    result.geometry.location