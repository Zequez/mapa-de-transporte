class SellLocationsEditor.Manager
  sell_locations: []
  number: 0

  constructor: (@city_data)->
    @find_elements()
    @parse_template()
    @build_city()
    @build_sell_locations()

  find_elements: ->
    @map = $$('map')
    @form_template = $$("sell_location_template")
    @container = $$("sell_locations_container")

  parse_template: ->
    @form_template.remove()
    @form_template.removeAttr('id')
    @form_template.find(':input').removeAttr('id')

  build_city: ->
    @city = new AdminCity.Builder(@city_data, @map)

  build_sell_locations: ->
    if @city_data.sell_locations.length > 0
      for i, sell_location_data of @city_data.sell_locations
        @build_sell_location sell_location_data, i
    else
      @build_sell_location()

  build_sell_location: (data = false)->
    sell_location = new SellLocationsEditor.SellLocation(data, @form_template, @city, @number++)

    sell_location.append_to(@container)

    @sell_locations.push sell_location
    @bind_sell_location(sell_location)

  bind_sell_location: (sell_location)->
    sell_location.add_listener 'enter', (data)=>
      @build_sell_location(data)

    sell_location.add_listener 'remove', =>
      @remove_sell_location sell_location

    sell_location.add_listener 'focus', (focused_sell_location)=>
      for sell_location in @sell_locations
        if sell_location == focused_sell_location
          if not sell_location.highlighted
            sell_location.highlight() 
        else
          sell_location.unhighlight()


  remove_sell_location: (sell_location)->
    @sell_locations.splice @sell_locations.indexOf(sell_location), 1
    sell_location.remove()

#    for sell_location_data in @sell_locations
