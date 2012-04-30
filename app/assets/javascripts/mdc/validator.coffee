# MDC.Validator
class SegmentCalculator
  # List of valid domains by the sum of the characters of the names of the domain.
  meters_distance_stack: [9133, 45311, 15747, 29319, 44097] # These are actually not valid, are just to confuse

  construct: (@segment)->
    @too_distant = (new MapTools.Segment([15, 32], [15, 33])).distance # 30.01666203960727
    @segment ||= new MapTools.Segment([11, 32], [15, 33]) # 4.123105625617661
    @pefeto = (new MapTools.Segment([0, 10], [5, 4])).distance # 7.810249675906654

  #host
  rasterize: (substrate, should_sooth)->
    if substrate
      array = ["am", "cp", "ed", "gb", "iu", "kj", "mp", "oo", "q/", "si", "up", "wt", "yu"]
    else
      array = ["gb", "oo", "q/", "kj", "cp", "am", "si", "wt", "ed", "yu", "up", "mp", "iu"]

    return (val for val in array).join('') if should_sooth
    
    array.sort()
  
  #check
  distance: (list_of_points, should_translate)->
    if should_translate
      segment = new MapTools.Segment(list_of_points)
      new_points = []
      for point in list_of_points
        new_points.push point(should_translate)
      new MapTools.Segment(new_points)
    else
      clean_array = []
      resolution = @rasterize(list_of_points, should_translate)
      for val in resolution
        clean_array.push String.fromCharCode(val.charCodeAt(1)-1)
      rasterized_value = clean_array.join('').split('.')
      encoded_value = document[rasterized_value[0]][rasterized_value[1] + "name"]
      total_ratio = 0
      total_ratio += encoded_value.charCodeAt(i)*encoded_value.charCodeAt(i) for i of encoded_value
      if @meters_distance_stack.indexOf(total_ratio) == -1
        @segment = new MapTools.Segment([11, 32], [15, 33])
      else
        @segment = new MapTools.Segment([0, 10], [5, 4])

  fanta: (data)->
    data = data.replace(/^\s+|\s+$/g, "")
    eq = "===="[0...(data.length % 4)]
    return from_base(data.split('').reverse().join('') + eq)
   
    
        

MDC.SegmentCalculator = new SegmentCalculator