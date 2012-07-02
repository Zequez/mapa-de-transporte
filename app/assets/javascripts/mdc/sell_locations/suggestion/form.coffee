class MDC.SellLocations.Suggestion.Form extends Utils.Eventable
  constructor: (@sell_location_data)->
    @create_data()
    @create_element()
    @find_form()
    @create_inputs()

    @find_paledator()
    @find_close()

    @bind_close()
    @bind_form()

  create_data: ->
    @data = {}

    @data["user_name"]      = MDC.SETTINGS.read["user_name"]
    @data["user_email"]       = MDC.SETTINGS.read["user_email"]
    @data["sell_location_id"] = @sell_location_data.id
    @data["removed"]          = false

    for name in ["lat", "lng", "address", "name", "info", "card_selling", "card_reloading", "ticket_selling"]
      @data[name] = @sell_location_data[name]

    null

  create_element: ->
    @element = @get_template().clone()

  create_inputs: ->
    @inputs = new MDC.SellLocations.Suggestion.FormInputs @data, @form

  find_paledator: -> @paledator = @element.find('.paledator')

  find_close: -> @close_element = @element.find('.close')

  find_form: -> @form = @element.find('form')

  bind_close: ->
    @close_element.click =>
      @fire_event('close')

  bind_form: ->
    @element.submit (e)=>
      e.preventDefault()
      @fire_event('submit', @get_form_data())

  set_position: (position)-> @inputs.set_position(position)

  get_element: -> @element[0]
  
  get_data: -> @inputs.get_data()
  
  get_form_data: -> @inputs.get_form_data()

  disable: ->
    @paledator.fadeIn()

  enable: ->
    @paledator.fadeOut()

  replace_element: (element)->
    @form.replaceWith element
    @form = element
    @enable()
    if @form.is('form')
      @find_paledator()
      @inputs.replace_element(@form)

  get_template: ->
    MDC.SellLocations.Suggestion.Form.Template ||= do ->
      template = $(".sell-location-suggestion-form")
      template.remove()
      template.show()
      template

  destroy: ->
    @inputs.destroy()
    @close_element.unbind()
    @element.remove()

    