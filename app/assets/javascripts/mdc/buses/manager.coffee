# Events
# - visibility_change

class MDC.Buses.Manager extends Utils.Eventable
  constructor: (data, @url_helper, @gmap)->
    @build_bus_groups(data)
    @bind_bus_groups()
    @bind_buses()
    @set_states_actions()


  build_bus_groups: (data)->
    @buses = []
    @bus_groups = []
    for bus_group_data in data

      bus_group = new MDC.Buses.Group bus_group_data, @gmap

      @bus_groups.push bus_group
      @buses = @buses.concat bus_group.buses
    null

  bind_bus_groups: ->
    for bus_group in @bus_groups
      bus_group.add_listener "button_activated",   (buses)=> @set_state(buses, "activated")
      bus_group.add_listener "button_deactivated", (buses)=> @set_state(buses, "deactivated")
      bus_group.add_listener "button_hover",       (buses)=> @shift_state(buses, "bus_hover")
      bus_group.add_listener "button_out",         (buses)=> @unshift_state(buses)

  bind_buses: ->
    for bus in @buses
      do (bus)=>
        bus.add_listener "button_activated",   => @set_state([bus], "activated")
        bus.add_listener "button_deactivated", => @set_state([bus], "deactivated")
        bus.add_listener "button_hover",       => @shift_state([bus], "bus_hover")
        bus.add_listener "button_out",         => @unshift_state([bus])
        bus.add_listener "route_hover",        (route)=> @shift_state([[bus, route]], "route_hover")
        bus.add_listener "route_out",          => @unshift_state([bus])

  find_closest_route: (checkpoints)->
    for bus in @buses
      bus.find_closest_route(checkpoints)
      
  # States changers
  #################

  base_states:
    {
      "activated":             {button: true,  routes: 2}
      "deactivated":           {button: false, routes: 0}
      "bus_hover":             {routes: 3}
      "route_hover":           {highlight_ui: true, popup: true, route: 3}
      "direction_hover":       {highlight_ui: true, popup: true, route: 2}
      "direction_activated":   {routes: 0, route: 1, button: true}
      "direction_deactivated": {routes: 0, button: false}
    }

  set_states_actions: ->
    @states_actions = {}
    
    @states_actions["activated"] =
    @states_actions["deactivated"] =
    @states_actions["direction_activated"] = =>
      @update_url()


  set_state: (buses, state_name)->
    @apply_state(buses, state_name)

  shift_state: (buses, state_name)->
    @apply_state(buses, state_name, true)

  unshift_state: (buses)->
    bus.unshift_state() for bus in buses

  apply_state: (buses, state_name, shift = false)->
    state = @base_states[state_name]
    
    for bus in buses
      if bus.constructor == Array
        route = bus[1]
        bus   = bus[0]
        state[route.id] = state.route
        @push_state(bus, state, shift)
        delete state[route.id]
      else
        @push_state(bus, state, shift)

    @run_state_action(state_name)
        
  push_state: (bus, state, shift)->
    if shift
      bus.shift_state(state)
    else
      bus.set_state(state)
 

  run_state_action: (state)->
    @states_actions[state]() if @states_actions[state]


  # States actions
  ################

  update_url: ->
    buses_names = []
    for bus in @buses
      buses_names.push bus.perm() if bus.is_activated()

    console.log buses_names

    @url_helper.set_url buses_names.join('+')
      
