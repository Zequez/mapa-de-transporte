class SellLocationsReviews.Builder
  constructor: ->
    @build_map()
    @bind_map()
    @build_suggestions()
    @build_sell_location()
    @center_map()

  build_map: ->
    @map_element = $("#map")
    @map_container = $("#map-container")
    @map = new MapTools.Map(@map_element)

  bind_map: ->
    offset = @map_element.offset()
    $(window).scroll =>
      scroll_top = $(window).scrollTop()

      if scroll_top > offset.top
        @map_element.css 'position', 'fixed'
        @map_element.css 'top', 0
        @map_element.css 'left', offset.left
      else
        @map_element.css 'top', ''
        @map_element.css 'left', ''
        @map_element.css 'position', 'absolute'

  build_sell_location: ->
    @sell_location = new SellLocationsReviews.SellLocation(@map.gmap)

  center_map: ->
    @map.set_center @sell_location.get_position()

  build_suggestions: ->
    @suggestions_elements = $("#suggestions fieldset")
    @suggestions = []
    @suggestions_elements.each (i, element)=>
      suggestion = new SellLocationsReviews.Suggestion($(element), @map.gmap)
      @bind_suggestion(suggestion)
      @suggestions.push suggestion

  bind_suggestion: (suggestion)->
    suggestion.add_listener 'select', (name, value)=>
      @sell_location.set_val name, value

    suggestion.add_listener 'hover', =>
      for sugg in @suggestions
        sugg.unhighlight() if sugg != suggestion

      suggestion.highlight()



