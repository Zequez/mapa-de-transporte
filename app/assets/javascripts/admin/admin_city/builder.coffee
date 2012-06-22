class AdminCity.Builder
  constructor: (@data, @element = $$("map"))->
    @build_map()
    @build_fetcher()

  build_map: ->
    @map = new MapTools.Map(@element, @data['viewport'])
    @gmap = @map.gmap
    
  build_fetcher: ->
    @fetcher = new AdminCity.AddressFetcher(@data["name"], @data["country"], @data["region_tag"])

  fetch_address: (address, callback)->
    @fetcher.fetch(address, callback)