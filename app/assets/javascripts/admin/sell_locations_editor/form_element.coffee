# Events
# - remove
# - enter
# - change
# - address_change
# - focus

class SellLocationsEditor.FormElement extends Utils.Eventable
  constructor: (@data, @template, @number)->
    @build_elements()
    @fill_element()
    @replace_name()
    @bind_elements()

  build_elements: ->
    @element  = @template.clone()
    @inputs   = @element.find(':input')
    @close    = @element.find('.remove')
    @address  = @inputs.filter('[name*="address"]')
    @delete_e = @inputs.filter('[name*="_destroy"]')

  fill_element: ->
    for i, val of @data
      @fill_input i, val

  replace_name: ->
    for input in @inputs
      input.name = input.name.replace('[0]', "[#{@number}]")

  fill_input: (name, value)->
    if typeof(value) == "boolean"
      if value
        value = 1
      else
        value = 0
    @element.find("[name*='#{name}']").val value

  bind_elements: ->
    @inputs.keypress (e)=>
      if e.charCode == 13
        e.preventDefault()
        @fire_event('enter')

    @inputs.focus (e)=>
      @fire_event('focus')

    @inputs.change (e)=>
      @fire_event('change')

    @address.change (e)=>
      @fire_event('address_change')

    @close.click =>
      @fire_event('remove')


  append_to: (parent)->
    parent.append @element
    @address.focus()

  remove: ->
    if not @data.id
      @element.remove()
    else
      @delete_e.val true
      @element.hide()


  address_val: ->
    @address.val()

  set_latlng: (latlng)->
    @fill_input 'lat', latlng.lat()
    @fill_input 'lng', latlng.lng()



    