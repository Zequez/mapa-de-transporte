# Events
# - remove
# - enter
# - change
# - address_change
# - focus

class SellLocationsEditor.FormElement extends Utils.Eventable
  constructor: (@data, @template, @number)->
    @build_elements()
    @build_inputs()
    @fill_element()
    @replace_name()
    @bind_elements()

  build_elements: ->
    @element  = @template.clone()
    @close    = @element.find('.remove')

  build_inputs: ->
    inputs   = @element.find(':input')
    @all_inputs = inputs
    @inputs  = {}
    @data._destroy = false
    for name, value of @data
      input = inputs.filter("[name*='#{name}']").last()
      if input.length > 0
        @inputs[name] = input

  fill_element: ->
    for i, val of @data
      @fill_input i, val

  replace_name: ->
    @all_inputs.each (i, input)=>
      input.name = input.name.replace('[0]', "[#{@number}]")

  fill_input: (name, value)->
    input = @inputs[name]

    if input.prop('type') == 'checkbox'
      input.prop('checked', value)
    else
      if input.prop('tagName') == 'SELECT'
        if typeof(value) == "boolean"
          if value
            value = 1
          else
            value = 0

      input.val value

    @data[name] = value

  gather_input: (name)->
    input = @inputs[name]
    console.log name, input

    if input.prop('type') == 'checkbox'
      value = input.is(':checked')
    else
      value = $(input).val()

    @data[name] = value
    console.log @data[name]

  bind_elements: ->
    @all_inputs.keypress (e)=>
      if e.charCode == 13
        e.preventDefault()
        @fire_event('enter', @inheritable_data())

    @all_inputs.focus (e)=>
      @fire_event('focus')

    @all_inputs.change (e)=>
      data_name = e.target.name.match(/\[([^[]+)\]$/)[1]
      @gather_input data_name

      @fire_event('change')

    @inputs.address.change (e)=>
      @fire_event('address_change')

    @close.click =>
      @fire_event('remove')


  append_to: (parent)->
    parent.append @element
    @inputs.address.focus()

  remove: ->
    if not @data.id
      @element.remove()
    else
      @delete_e.val true
      @element.hide()

  address_val: ->
    @inputs.address.val()

  set_latlng: (latlng)->
    @fill_input 'lat', latlng.lat()
    @fill_input 'lng', latlng.lng()

  set_manual_position: (boolean)->
    @fill_input('manual_position', boolean)

  focus: ->
    @inputs.address.focus()

  inheritable_data: ->
    {
      card_selling: @data.card_selling
      card_reloading: @data.card_reloading
      ticket_selling: @data.ticket_selling
    }


    