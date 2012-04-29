class BusEditor.City
  constructor: (data)->
    @data = data

    @build_map()
    @build_fetcher()

  build_map: ->
    @map = new Map($$('map'), @data.viewport)
    @gmap = @map.gmap

  build_fetcher: ->
    @fetcher = new BusEditor.City.AddressFetcher(@data.name, @data.country, @data.region_tag)

  fetch_address: (address, callback)->
    @fetcher.fetch(address, callback)