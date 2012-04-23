class window.PathFilterInstructions
  constructor: ->
    @find_elements()
    @children.hide()
    @show('start')


  find_elements: ->
    @container = $$("filter-instructions")
    @children = @container.children()
    @elements = {}

  fire_auto_hide: (name)->
    if not Settings.filter_instructions[name] and @elements[name]
      @elements[name].hide()

  fire: (name)->
    if Settings.help_tips == true
      if Settings.filter_instructions[name] and not @elements[name]
        @elements[name] = new PathFilterInstruction(name)

  show: (name)->
    if !@elements[name]
      @elements[name] = new PathFilterInstruction(name)
    else
      @elements[name].show()

# start / many-zones / remove / no-buses / suggestion  / maximum
class PathFilterInstruction
  constructor: (name)->
    @name = name
    @element = @e = $$("filter-instruction-#{name}")
    @bind_element()
    @show()

  bind_element: ->
    @element.click =>
      @element.slideUp()
      Settings.filter_instructions[@name] = false
      SaveSettings()

  show: ->
    @element.stop().delay(1000).slideDown()

  hide: ->
    @element.delay(500).slideUp()


