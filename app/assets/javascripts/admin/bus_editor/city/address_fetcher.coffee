class BusEditor.City.AddressFetcher
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
    @geocoder.geocode @options(address), (results, status)=>
      @fetching = false
      @last_fetch_time = @time()
      if status == 'OK'
        console.log "Success!"
        callback @parse_result(results[0])
      else
        console.log "FAILED!"
        callback false

  at_least_one_second_passed: ->
    @last_fetch_time < @time()

  time: ->
    (new Date).getTime()

  options: (address_name)->
    {
      address: "#{address_name}, #{@city}, #{@country}",
      region: @region
    }

  parse_result: (result)->
#    console.log "Parsed result...", result
    result.geometry.location