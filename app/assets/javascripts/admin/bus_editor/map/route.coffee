class BusEditor.Map.Route extends MapTools.Route
  temp_point: null
  point_addition_enabled: true
  reverse_insertion: false

  constructor: (gmap, coordinates, options)->
    super(gmap, coordinates, options)
    @bind_events()

  bind_events: ->
    $G.event.addListener @gmap, "click",       (e)=> @add_point(e.latLng)
    @update_edit_state()

  # We have to be a little bit hacky here, because
  # if you create a polyline with just one point
  # it ignores the point and empties the array
  add_point: (point)->
    if @point_addition_enabled
      if @points.length == 0
        if @temp_point
          @update_poly_path([@temp_point, point])
          @temp_point = null
        else
          @temp_point = point
      else
        if not @reverse_insertion
          @points.push point
        else
          @points.insertAt 0, point

      @update_edit_state()

  update_edit_state: (yes_no = true)->
    @poly.edit(yes_no, ghosts: yes_no)

  get_points: ->
    @points.getArray()

  editable: (yes_no = true)->
    @enable_point_addition(yes_no)
    @update_edit_state(yes_no)

  enable_point_addition: (yes_no = true)->
    @point_addition_enabled = yes_no

  enable_reverse_insertion: (yes_no)->
    @reverse_insertion = yes_no

  encoded: ->
    $G.geometry.encoding.encodePath @points

#

#  insert_point: (index, point)-> @points.splice(index, 0, point)
#  remove_point: (index)->
#    @points.splice(index, 1)
#    @update_edit_state()
#  replace_point: (index, point)->
#    console.log 'replace'
#    @points.splice(index, 1, point)