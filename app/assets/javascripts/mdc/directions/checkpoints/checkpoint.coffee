class MDC.Directions.Checkpoints.Checkpoint
  constructor: ({@name, @perm, @latlng, @value, @autocomplete})->
    @value ||= _arg.point

    @parse_value_latlng()
    
    if @perm
      @perm = decodeURI(@perm)

    # NAME AND VALUE
    if not @perm and @name and @value
      # Input fetched checkpoint
      @perm_from_name()

    # ONLY VALUE
    else if not @name and not @perm and @value
      # Marker checkpoint
      @perm_from_value()
      @name_from_value()

    # ONLY PERM
    else if not @name and not @value and @perm
      # URL checkpoint
      if @value_from_perm()
        # Perm is the value
        @name_from_value()
      else
        # Perm is the name
        @name_from_perm()
        @value_from_autocomplete()
        # NOT FUCKING VALUE; YOU HAVE TO FUCKING FETCH IT.

    # ONLY NAME
    else if not @perm and not @value and @name
      # Input not fetched checkpoint
      if @value_from_name()
        @perm_from_value()
      else
        @perm_from_name()
        @value_from_autocomplete()
        # NOT FUCKING VALUE; YOU HAVE TO FUCKING FETCH IT.

  ################
  # General shit #
  ################

  parse_value_latlng: ->
    if @value
      @latlng = $LatLng(@value)
    else if @latlng
      @value = [@latlng.lat(), @latlng.lng()]

    if @value
      @set_value_attributes()

  set_value_attributes: ->
    @lat   = @value[0]
    @lng   = @value[1]
    @point = @value

  set_latlng: (latlng)->
    @latlng = latlng
    @parse_value_latlng()

  fetch: (fetcher, callback)->
    fetcher.fetch @name, (result)=>
      if result == -1
        # Not found
        callback -1
      else if not result
        # Error
        callback false
      else
        # Success! Latlng fetched!
        @set_latlng result
        callback(true)

  fetch_if_not_value: (fetcher, callback)->
    if @value
      callback(true)
    else
      @fetch fetcher, callback


  #########################
  # Stuff conversion shit #
  #########################

  perm_from_value: ->
    @perm = @compress_points(@value)

  name_from_value: ->
    @name = "#{parseInt(@value[0]*1000) / 1000}, #{parseInt(@value[1]*1000) / 1000}"

  perm_from_name: ->
    @perm = encodeURI(@name.replace(" ", "-"))

  value_from_perm: ->
    console.log @perm
    @value = @decompress_points(@perm.replace(/\s/g, ""))
    
    if @value and @value[0] and @value[1]
      @parse_value_latlng()
      true
    else
      @value = null
      false

  value_from_name: ->
    values = @name.split(",")
    @value = []
    @value[0] = parseFloat values[0]
    @value[1] = parseFloat values[1]
    if @value[0] and @value[1]
      @parse_value_latlng()
      true
    else
      @value = null
      false

  name_from_perm: ->
    @name = @perm.replace("-", " ")

  value_from_autocomplete: ->
    if @autocomplete
      result = @autocomplete.match_unique @name
      if result
        @name  = result[0]
        @value = result[1]
        @parse_value_latlng()
      
    

  #################
  # Encoding shit #
  #################

  compress_points: (points, precision = 5)->
    oldLat = 0
    oldLng = 0
    len = points.length
    index = 0
    encoded = ''

    precision = Math.pow(10, precision)

    while index < len
      # Round to N decimal places
      lat = Math.round(points[index++] * precision)
      lng = Math.round(points[index++] * precision)

      # Encode the differences between the points
      encoded += @encode_number(lat - oldLat)
      encoded += @encode_number(lng - oldLng)

      oldLat = lat
      oldLng = lng

    "[#{btoa(encoded).replace(/\=/g, "")}]"

  encode_number: (num)->
    num = num << 1

    if num < 0
      num = ~(num)

    encoded = ''

    while num >= 0x20
      encoded += String.fromCharCode((0x20 | (num & 0x1f)) + 63)
      num >>= 5

    encoded += String.fromCharCode(num + 63)

  decompress_points: (encoded, precision = 5)->
    return null if not encoded.match(/^\[.*\]$/)

    try
      encoded = atob(encoded.replace(/\[|\]/g, ""))

      precision = Math.pow(10, -precision);
      len   = encoded.length
      index = 0
      lat   = 0
      lng   = 0
      array = []

      while index < len
        shift = 0
        result = 0
        loop
          b = encoded.charCodeAt(index++) - 63;
          result |= (b & 0x1f) << shift;
          shift += 5;
          break if not (b >= 0x20)

        dlat = if (result & 1) then ~(result >> 1) else (result >> 1)
        lat += dlat
        shift = 0
        result = 0

        loop
          b = encoded.charCodeAt(index++) - 63
          result |= (b & 0x1f) << shift
          shift += 5
          break if not (b >= 0x20)

        dlng = if (result & 1) then ~(result >> 1) else (result >> 1)
        lng += dlng

        array.push(lat * precision)
        array.push(lng * precision)
      return array
    catch error
      return null

