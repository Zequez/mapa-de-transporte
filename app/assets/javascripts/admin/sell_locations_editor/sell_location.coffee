# Events
# - remove
# - enter
# - change

class SellLocationsEditor.SellLocation extends Utils.Eventable
  constructor: (data, @template, @city, @number)->
    @highlighted = false
    
    @data = _.extend {
      id: null,
      address: '',
      name: '',
      info: '',
      lat: 0,
      lng: 0,
      card_selling:   null,
      card_reloading: null,
      ticket_selling: null,
      visibility: true,
      inexact: false,
      manual_position: false
    }, data

    @build_form_element()
    @bind_form_element()
    @create_marker()

  build_form_element: ->
    @form_element = new SellLocationsEditor.FormElement(@data, @template, @number)

  bind_form_element: ->
    @inherit_listener(@form_element, 'remove')

    @form_element.add_listener 'enter', (e)=>
      @fire_event('enter', e)

    @form_element.add_listener 'focus', =>
      @fire_event('focus', this)

    @form_element.add_listener 'address_change', =>
      if not @form_element.data.manual_position
        @fetch_address()

  create_marker: (latlng)->
    latlng = new $G.LatLng @data.lat, @data.lng
    @marker = new SellLocationsEditor.Marker(@city.gmap, latlng)
    @bind_marker()

  bind_marker: ->
    @marker.add_listener 'change', (latlng)=>
      @update_from_dragging(latlng)

    @marker.add_listener 'select', =>
      console.log 'click'
      @form_element.focus()

  append_to: (parent)->
    @form_element.append_to(parent)

  remove: ()->
    @form_element.remove()
    @marker.remove()

  highlight: ->
    @highlighted = true
    @marker.highlight()

  unhighlight: ->
    @highlighted = false
    @marker.unhighlight()

  fetch_address: ->
    value = @google_api_bug_workaround @form_element.address_val()
    
    @city.fetch_address value, (latlng, partial_match)=>
      @update_from_fetching(latlng)
      @update_marker(latlng)

  update_from_fetching: (latlng)->
    @update_form_latlng(latlng)

  update_from_dragging: (latlng)->
    @form_element.set_manual_position(true)
    @update_form_latlng(latlng)

  update_form_latlng: (latlng)->
    @form_element.set_latlng(latlng)


  update_marker: (latlng)->
    @marker.set_latlng(latlng)

  google_api_bug_workaround: (fetch_address)->
    trigger_key = '+'

    do_work_around = (fetch_address[fetch_address.length-1] == trigger_key)
    console.log do_work_around
    if do_work_around
      fetch_address = fetch_address.replace /.$/, ''
      number = fetch_address.match /[0-9]+[^0-9]*$/ # Match last number
      number = parseInt number
      ++number
      fetch_address = fetch_address.replace /[0-9]+[^0-9]*$/, number
    fetch_address



#class FormDataHandler
#  constructor: (inputs)->
#
#
