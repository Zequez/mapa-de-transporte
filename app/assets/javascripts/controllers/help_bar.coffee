class window.HelpBar
  constructor: ->
    @visible = $.cookie('help_tips') != 'false'
    @find_elements()
    @bind_elements()

  find_elements: ->
    @tooltips = $$('tooltips')
    @close    = @tooltips.find('.close')
    @toggle_element = $$('toggle-help')

  bind_elements: ->
    @close.click => @toggle()
    @toggle_element.click => @toggle()

  toggle: ->
    @tooltips.toggle()
    @visible = !@visible

    if @visible
      @toggle_element.addClass 'toggled'
    else
      @toggle_element.removeClass 'toggled'

    $.cookie('help_tips', @visible)