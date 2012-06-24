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
    @city.fetch_address @form_element.address_val(), (latlng)=>
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


    

