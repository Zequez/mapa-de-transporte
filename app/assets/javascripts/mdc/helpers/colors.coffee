color_helper = {
  hsl2rgb: (h, s, l)->
    s /=100
    l /= 100
    if (s == 0)
      r = g = b = (l * 255)
    else
      if (l <= 0.5)
        m2 = l * (s + 1)
      else
        m2 = l + s - l * s
      m1 = l * 2 - m2
      hue = h / 360
      r = @hue2rgb(m1, m2, hue + 1/3)
      g = @hue2rgb(m1, m2, hue)
      b = @hue2rgb(m1, m2, hue - 1/3)

    "##{r}#{g}#{b}"

  hue2rgb: (m1, m2, hue)->
    if (hue < 0)
      hue += 1
    else if (hue > 1)
      hue -= 1

    if (6 * hue < 1)
      v = m1 + (m2 - m1) * hue * 6
    else if (2 * hue < 1)
      v = m2
    else if (3 * hue < 2)
      v = m1 + (m2 - m1) * (2/3 - hue) * 6
    else
      v = m1

    @padhex 255 * v

  padhex: (color)->
    @pad parseInt(color).toString(16), 2

  pad: (number, length)->
    str = '' + number
    while str.length < length
      str = '0' + str

    str

  make_colors: ->
    colors = for s in [100, 80]
      for l in [30, 50, 70]
        for h in [0, 90, 135, 180, 225, 270, 315]
          @hsl2rgb(h, s, l)

    _.flatten(colors)
    
}

class Colors
  current_color: 0

  constructor: (colors)->
    @colors = colors || color_helper.make_colors()

  get: ->
    @current_color = 0 if @current_color > @colors.length
    @colors[@current_color++]

colors = ["#990000", "#4c9900", "#009926", "#009899", "#002699", "#4c0099", "#990072", "#ff0000", "#7fff00", "#00ff3f", "#00feff", "#003fff", "#7f00ff", "#ff00bf", "#ff6565", "#b2ff65", "#65ff8c", "#65feff", "#658cff", "#b265ff", "#ff65d8", "#890f0f", "#4c890f", "#0f892d", "#0f8989", "#0f2d89", "#4c0f89", "#890f6b", "#e51919", "#7fe519", "#19e54c", "#19e5e5", "#194ce5", "#7f19e5", "#e519b2", "#ef7575", "#b2ef75", "#75ef93", "#75efef", "#7593ef", "#b275ef", "#ef75d1"]

MDC.Helpers.Colors = new Colors(colors)