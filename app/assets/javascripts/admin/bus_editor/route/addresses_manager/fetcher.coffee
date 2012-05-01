class BusEditor.Route.AddressesManager.Fetcher
  start_number: 100
  end_number: 1000

  max_results: 2

  fetched: false

  fetch_numbers: [3000, 500, 7000, 0, 10000]

  constructor: (@city, @address)->
    @queries = []
    @results = []

  build_queries: ->
    if @address.number
      # Single address
      @queries.push @address.full_address
      @max_results = 1
    else
      # Multiple addresses to display a polyline, only 2 have to trigger.
      for number in @fetch_numbers
        @queries.push "#{@address.address} #{number}"

  fetch: (callback)->
    if @results.length == 0
      @build_queries()
      @fetch_by_one @queries, callback
    else
      callback @results


  fetch_by_one: (queries, callback)->
    if queries.length == 0
      callback([])
    else
      @city.fetch_address queries.shift(), (result)=>
        if not result
          @fetch_by_one(queries, callback)
        else
          if not @result_exists(result)
            @results.push result

          if @results.length >= @max_results
            callback(@results)
          else
            @fetch_by_one(queries, callback)


  result_exists: (search)->
    for result in @results
      return true if result.lat() == search.lat() and result.lng() == search.lng()
    false

#  fetch_query: (query, callback)->
##    console.log 'Querieing...', query
#    @city.fetch_address query, (result)=>
#      if result
#        @results.push result
#        ++@queries_finished
#        if @queries_finished == @queries.length
#          callback @results
#      else
#        console.log 'Failed query!', query
#        callback false