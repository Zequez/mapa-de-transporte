class BusEditor.Route.AddressesManager
  constructor: (city, parent)->
    @city = city
    @parent = parent

    @addresses         = {}
    @current_addresses = {}

    @find_element()
    @build_watcher()
    @bind_watcher()

  find_element: ->
    @element = @e = @parent.find('textarea')

  build_watcher: ->
    @watcher = new BusEditor.Route.AddressesManager.Watcher(@element)

  bind_watcher: ->
    @watcher.add_listener 'target_change', =>
      @handle_selected_address()

    @watcher.add_listener 'change', =>
      @update_addresses_visibility()
      @handle_selected_address()


  # TODO: I should only hide the addresses that are not in the next current_addresses
  handle_selected_address: ->
    selected_address = @watcher.get_selected_address()
    if selected_address
      @unhighlight_addresses()
      @highlight_address(selected_address)

  update_addresses_visibility: ->
    @hide_addresses()
    @update_current_addresses()
    @show_addresses()

  update_current_addresses: ->
    @current_addresses = {}
    for address in @watcher.addresses()
      if not @addresses[address.id]
        @addresses[address.id] = new BusEditor.Route.AddressesManager.Address address, @city
      @current_addresses[address.id] = @addresses[address.id]
    @current_addresses

  show_addresses: ->
    for i, address of @current_addresses
      address.show()
    return

  hide_addresses: ->
    for i, address of @current_addresses
      address.hide()
    return

  highlight_address: (address)->
    if @current_addresses[address.id]
      @current_addresses[address.id].highlight()

  unhighlight_addresses: ->
    for i, address of @current_addresses
      address.unhighlight()
    return


