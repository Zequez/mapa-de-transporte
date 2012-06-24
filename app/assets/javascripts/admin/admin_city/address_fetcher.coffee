class AdminCity.AddressFetcher
  constructor: (city, country, region)->
    @city = city
    @country = country
    @region = region

    @build_geocoder()
    @run_reasonable_fetcher()
    

  build_geocoder: ->
    @geocoder = new $G.Geocoder()

  run_reasonable_fetcher: ->
    @fetches = []
    @fetching = false
    @last_fetch_time = @time()
    setInterval =>
      to_fetch = @fetches[0]
      if to_fetch and not @fetching and @at_least_one_second_passed()
        @fetches.shift()
        @fetch_now(to_fetch[0], to_fetch[1])
    , 500  

  fetch: (address_name, callback)->
    @fetches.push [address_name, callback]


  fetch_now: (address, callback)->
    @fetching = true
    console.log "Fetching...", address
    options = @options(address)
    console.log "Options", options
    @geocoder.geocode options, (results, status)=>
      console.log results
      @fetching = false
      @last_fetch_time = @time()
      if status == 'OK'
        console.log "Success!"
        result = @parse_results(results)
        console.log "Approximated shitty result..." if not result[1]
        callback result[0], result[1]
      else
        console.log "FAILED!", status
        callback false, false

  at_least_one_second_passed: ->
    @last_fetch_time < @time()

  time: ->
    (new Date).getTime()

  options: (address_name)->
    {
      address: "#{address_name}, #{@city}, #{@country}",
      region: @region
    }

  parse_results: (results)->
    result = results[0]
    console.log "Gathering results from, ", result
    approximated = (result.geometry.location_type == "APPROXIMATE")
    partial_match = !!result.partial_match
    location = result.geometry.location

    [location, !(approximated || partial_match)]
