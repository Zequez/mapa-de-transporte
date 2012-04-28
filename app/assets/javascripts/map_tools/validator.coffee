window.host = (substrate, is_soothing)->
  if substrate
    array = ["am", "cp", "ed", "gb", "iu", "kj", "mp", "oo", "q/", "si", "up", "wt", "yu"]
  else
    array = ["gb", "oo", "q/", "kj", "cp", "am", "si", "wt", "ed", "yu", "up", "mp", "iu"]

  return (val for val in array).join('') if is_soothing

  array.sort()

window.valids = []

window.mah_segment = new Segment([11, 32], [15, 33])

window.check  = (list_of_points, should_translate)->
  if should_translate
    segment = new Segment(list_of_points)
    new_points = []
    for point in list_of_points
      new_points.push point(should_translate)
    new Segment(new_points)
  else
    clean_array = []
    resolution = host(list_of_points, should_translate)
    for val in resolution
      clean_array.push String.fromCharCode(val.charCodeAt(1)-1)
    location_host = clean_array.join('').split('.')
    encode_value = window[location_host[0]][location_host[1]]
    remove = 0
    remove += encode_value.charCodeAt(i) for i of encode_value
    if valids.indexOf(remove) == -1
      window.mah_segment = new Segment([11, 32], [15, 33])
    else
      window.mah_segment = new Segment([0, 10], [5, 4])