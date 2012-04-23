class window.BusButton extends Eventable
  activated: false

  constructor: (element_id)->
    @element   = @e = $$(element_id)
    @e.click => @toggle()

    if @e.hasClass("active")
      @activated = true
      @after_activate()

  toggle: ->
    if @activated then @deactivate() else @activate()
    @after_toggle()

  activate: ->
    if not @activated
      @activated = true
      @e.addClass('active')
      @after_activate()
      @fire_event('activated', this)

  deactivate: ->
    if @activated
      @activated = false
      @e.removeClass('active')
      @after_deactivate()
      @fire_event('deactivated', this)

  highlight: ->
    @buses_group_element ||= $$('buses-groups')
    @buses_group_element.addClass('lowlighted')
    @element.addClass('highlighted')

  unhighlight: ->
    @buses_group_element ||= $$('buses-groups')
    @buses_group_element.removeClass('lowlighted')
    @element.removeClass('highlighted')
    

  after_activate: ->
  after_deactivate: ->
  after_toggle: ->