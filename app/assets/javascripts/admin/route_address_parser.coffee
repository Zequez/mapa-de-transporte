class window.RouteAddressParser
  constructor: (address_line)->
    @address_line = address_line
    @parse_address()

  parse_address: ->
    streets = @address_line.split('>')
    comments = []
    @streets = for street in streets
      comments.push street.comment
      new RouteAddressStreetParser(street)

    @id           = @streets[0].full_address
    @full_address = @streets[0].full_address
    @comment      = comments.join(' | ')
    @address      = @streets[0].address
    @number       = @streets[0].number


class RouteAddressStreetParser
  full_address: null
  comment:      null
  address:      null
  number:       null

  constructor: (street)->
    @street = street
    @parse_street()

  parse_street: ->
    matches = @street.match(/([^(]*)(?:\((.*)\))?/)
    if matches
      @full_address = matches[1].replace(/^\s+|\s+$/g, '')
      @comment      = matches[2]

      matches = @full_address.match(/(.+?)([0-9]*)?$/)

      if matches
        @address = matches[1].replace(/^\s+|\s+$/g, '')
        @number = matches[2]
    
