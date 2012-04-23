class window.BusesInfo
  constructor: ->
    @e = $("#buses-info")
#    @e.hide()

  show: ->
    
  hide: ->      


class window.BusInfo extends Eventable
  has_to_be_visible: true

  constructor: (id)->
    @id = id
    @find_element()

  find_element: ->
    @element = @e = $$("bus-info-#{@id}")

  ensure_data: (callback)->
    if not @element
      @fetch_data(callback)
    else
      callback()

  fetch_data: ->
    "Do ajax stuff"
    # AJAX STUFF

  hover_show: ->
#    @e.parent().prepend @e.remove()

  hover_hide: ->
#    @e.removeClass('hover-show')


  show: ->
    console.log 'Mostrar'
    @has_to_be_visible = true
    @ensure_data =>
      @e.show() if @has_to_be_visible

  hide: ->
    @has_to_be_visible = false
    if @element
      @e.hide()