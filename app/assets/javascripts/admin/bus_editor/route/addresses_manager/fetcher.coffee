class BusEditor.Route.AddressesManager.Fetcher
  start_number: 100
  end_number: 1000

  constructor: (@city, @address)->
    @queries = []
    @results = []

  build_queries: ->
    if @address.number
      # Single address
      @queries.push @address.full_address
    else
      # Multiple Address (to build a polyline)
      @queries.push "#{@address.address} #{@start_number}"
      @queries.push "#{@address.address} #{@end_number}"

  fetch: (callback)->
    if @results.length == 0
      @build_queries()
      @queries_finished = 0
      @queries_results  = []
      for query in @queries
        @fetch_query query, callback
    else
      callback @results

  fetch_query: (query, callback)->
    console.log 'Querieing...', query
    @city.fetch_address query, (result)=>
      if result
        @results.push result
        ++@queries_finished
        if @queries_finished == @queries.length
          callback @results
      else
        console.log 'Failed query!', query
        callback false