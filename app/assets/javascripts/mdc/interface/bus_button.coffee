class MDC.Interface.BusButton extends Utils.Eventable
  # Events
  # - mouseover
  # - mouseout
  # - activated
  # - deactivated
  # - toggled
  
  activated: false

  constructor: (@bus_id)->
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
      @toggle()
      e.preventDefault()
    @e.mouseover => @fire_event('mouseover')
    @e.mouseout => @fire_event('mouseout')

  toggle: ->
    if @activated
      @deactivate()
      @fire_event('deactivated')
    else
      @activate()
      @fire_event('activated', this)
    @fire_event('toggled')

  activate: ->
    if not @activated
      @activated = true
      @e.addClass('active')

  deactivate: ->
    if @activated
      @activated = false
      @e.removeClass('active')

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
      