class window.RouteAddressesWatcher extends Eventable
  # Events
  # - change -> RouteAddress

  constructor: (element)->
    @e = element
    
    @bind_element()

  bind_element: ->
    # Enter
    @e.keypress (e)=>
      if e.keyCode == 13
        @fire_event('change')


    # Arrows
    @e.keyup (e)=>
      if [38, 40].indexOf(e.keyCode) != -1
        @fire_event("target_change")

    @e.mouseup (e)=>
      @fire_event("target_change")


  get_selected_address: ->
    address_name = @get_current_line()
    parsed_address = new RouteAddressParser(address_name)
    if parsed_address.id
      parsed_address
    else
      false

  it_changed: ->
    [@last_value, @value] = [@value, @e.val()]

    @value != @last_value

  get_current_line: ()->
    value = @e.val()
    caret = @e.getSelection().start

    @parse_selection(value, caret)
    
  parse_selection: (value, start_from)->
    return value if start_from < 0

    start = value.lastIndexOf('\n', start_from - 1) + 1
    end = value.indexOf('\n', start_from)

    end = value.length if end == -1

    current_line = value.substr(start, end - start)

    if not current_line
      @parse_selection(value, start_from-1)
    else
      current_line

  addresses: ->
    addresses = []
    for value in @e.val().replace(/^\s+|\s+$/, '').split(/\n+/)
      address = (new RouteAddressParser value)
      if address.id
        addresses.push address
    addresses