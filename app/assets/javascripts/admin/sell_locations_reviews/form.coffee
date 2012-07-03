class SellLocationsReviews.Form extends Utils.Eventable
  constructor: ->
    @find_elements()

  find_elements: ->
    @element    = $("form")
    @container  = $("#sell-location")
    @inputs     = {}

  set_position: (latlng)->
    @set_val "lat", latlng.lat()
    @set_val "lng", latlng.lng()
    @set_val "manual_position", true

  get_position: ()->
    $LatLng([
      parseFloat(@get_val('lat')),
      parseFloat(@get_val('lng'))
    ])

  val: (name, value)->
    if value == undefined
      @get_val(name)
    else
      @set_val(name, value)

  set_val: (name, value)->
    input = @find_input(name)
    input.val value

  get_val: (name)->
    input = @find_input(name)
    input.val()

  find_input: (name)->
    return @inputs[name] if @inputs[name]
    input = @container.find("[name*='#{name}']")
    @inputs[name] = new Utils.Input input

class Utils.Input
  constructor: (@element)->
    @element = @element.last()
    @set_type()

  set_type: ->
    tag_name = @element.prop("tagName")
    if tag_name == 'INPUT'
      @type = @element.attr('type')
    else
      @type = tag_name.toLowerCase()

  val: (val)->
    if val != undefined
      @set_val(val)
    else
      @get_val()

  set_val: (val)->
    if @type == 'checkbox'
      @element.prop('checked', val)
    else if @type == 'select'
      @element.val @to_select(val)
    else
      @element.val val

  get_val: ->
    if @type == "checkbox"
      @element.is(":checked")
    else if @type == "select"
      @from_select @element.val()
    else
      @element.val()

  to_select: (value)->
    if value == true
      "true"
    else if value == false
      "false"
    else
      value

  from_select: (value)->
    if value == "true"
      true
    else if value == "false"
      false
    else
      value