class MDC.SellLocations.MarkerPopup
  y_distance: 5

  constructor: (@data)->
    @build_elements()
    @fill_popup()
    @append_to_document()
    @visible = false

  build_elements: ->
    @popup        = @get_template().clone()
    
    @address      = @popup.find('.location-address')
    @name         = @popup.find('.location-name')
    @info         = @popup.find('.location-info')
    @actions      = @popup.find('.location-actions')

    @address_data = @address.find('.location-address-data')
    @name_data    = @name.find('.location-name-data')
    @info_data    = @info.find('.location-info-data')
    @selling_data = @actions.find('.location-action-selling')
    @reload_data  = @actions.find('.location-action-reload')
    @ticket_data  = @actions.find('.location-action-ticket')

    @container = $$("map-container")

  fill_popup: ->
    if @data["address"]
      @address_data.text @data["address"]
    else
      @address.remove()

    if @data["name"]
      @name_data.text @data["name"]
    else
      @name.remove()

    if @data["info"]
      @info_data.text @data["info"]
    else
      @info.remove()

    if not @data["card_selling"]
      @selling_data.remove()

    if not @data["card_reloading"]
      @reload_data.remove()

    if not @data["ticket_selling"]
      @ticket_data.remove()

  append_to_document: ->
    @container.append @popup

  get_template: ->
    MDC.SellLocations.MarkerPopup.Template ||= do ->
      template = $$('sell-locations-marker-popup-template')
      template.removeAttr 'id'
      template

  show: (x, y)->
    @set_position(x, y) if x and y
    @popup.show()       if not @visible

  hide: ->
    @popup.hide()

  set_position: (x, y)->
    @popup.css left: x, bottom: document.body.scrollHeight-y+@y_distance
