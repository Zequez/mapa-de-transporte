class MDC.Buses.BusButton extends Utils.Eventable
  # Events
  # - mouseover
  # - mouseout
  # - activated
  # - deactivated
  # - toggled

  activated: false

  constructor: (@bus_id)->
    @state = false
    @find_element()
    @inspect_element()
    @bind_element()

  find_element: ->
    @element = @e = $$("bus-#{@bus_id}")

  inspect_element: ->
    @activated = true if @e.hasClass("active")
    @title = @e.attr('title')
    @toggled_title = @e.attr('toggled_title')

  bind_element: ->
    @e.click (e)=>
      if @activated
        @fire_event('deactivated')
      else
        @fire_event('activated')
      e.preventDefault()
    @e.mouseover => @fire_event('mouseover')
    @e.mouseout => @fire_event('mouseout')

  toggle: ->
    if @activated
      @activate()
    else
      @deactivate()

  activate: ->
    if not @activated
      @activated = true
      @e.addClass('active')
      @set_title()

  deactivate: ->
    if @activated
      @activated = false
      @e.removeClass('active')
      @set_title()

  highlight: ->
    @buses_group_element ||= $$('buses-groups')
    @buses_group_element.addClass('lowlighted')
    @element.addClass('highlighted')

  unhighlight: ->
    @buses_group_element ||= $$('buses-groups')
    @buses_group_element.removeClass('lowlighted')
    @element.removeClass('highlighted')

  set_title: ->
    @e.attr('title', if @activated then @toggled_title else @title)
      