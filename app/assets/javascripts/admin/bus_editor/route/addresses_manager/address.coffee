class BusEditor.Route.AddressesManager.Address
  element: null
  results: null
  highlighted: false

  constructor: (@address, @city)->

  show: ->
    if @element
      @element.show()
    else
      @fetch()

  hide: -> @element.hide() if @element
  highlight: ->
    if @element
      @element.highlight()
    else
      @highlighted = true
  unhighlight: ->
    if @element
      @element.unhighlight()
    else
      @highlighted = false

  fetch: ->
    @fetcher ||= new BusEditor.Route.AddressesManager.Fetcher(@city, @address)
    @fetcher.fetch (results)=>
      console.log "Results!", results
      @results = results
      if results
        if results.length == 1
          @element = new BusEditor.Route.AddressesManager.Displayer.Single(@city.gmap, results[0], @highlighted)
        else if results.length >= 2
          @element = new BusEditor.Route.AddressesManager.Displayer.Poly(@city.gmap, results, @highlighted)
        else
          console.log 'Something bad happened'

