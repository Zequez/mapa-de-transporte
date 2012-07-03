# Events
# - select
# - close

class SellLocationsReviews.SuggestionForm extends Utils.Eventable
  constructor: (@element)->
    @find_elements()
    @bind_elements()

  find_elements: ->
    @selectable_values = @element.find('.selectable-values')
    @values = @selectable_values.find('li')
    @reviewed_checkbox = @element.find('[name*="reviewed"]')
    @position_element = @values.filter('.position')
    @title_element = @element.find('.user-info')

  bind_elements: ->
    @values.click (e)=>
      element = $(e.currentTarget)
      name  = element.attr('class')
      value = element.find('.value').text()
      if name == 'position'
        [lat, lng] = value.split(',')
        lat = parseFloat lat
        lng = parseFloat lng
        @send_value 'lat', lat
        @send_value 'lng', lng
      else
        value = true  if value == 'true'
        value = false if value == 'false'
        @send_value name, value

    @reviewed_checkbox.change (e)=>
      if @reviewed_checkbox.is(":checked")
        @fire_event('close')

    @element.mouseover =>
      @fire_event('hover')

    @title_element.click =>
      @fire_event('toggle')


  get_position: ->
    element = @position_element.find('.value')
    if element.length > 0
      value = @position_element.find('.value').text()
      [lat, lng] = value.split(',')
      lat = parseFloat lat
      lng = parseFloat lng
      $LatLng([lat, lng])

  hide: ->
    @element.addClass('minimized')

  show: ->
    @element.removeClass('minimized')

  send_value: (name, value)->
    @fire_event('select', name, value)
