class BusesImages::Icon < BusesImages::BaseImageMagick
  def initialize(name, background_color, text_color)
    @name             = name
    @background_color = background_color
    @text_color       = text_color
    @string           = @name.to_s
    @output           = false
  end

  private
  
  def options(path)
    options = []

    options << "convert"
    options << "-size 21x9"
    options << "xc:transparent" # It creates an Image, I don't really know.

    letter_space = variation_image ? 6 : 7
    number_images.each_index do |i|
      options << %Q{-draw "image Over  #{letter_space*i},0 7,9 '#{number_images[i]}'"}
    end

    options << "-fill '#{@text_color}'"
    options << "-opaque '#{BusesImages::FIXED_TEXT_COLOR}'"

    options << "-background '#{@background_color}'"
    options << "-flatten"

    options << "-bordercolor '#0000007F'"
    options << "-border 1x1"
    options << "-flatten"

    if variation_image
      options << "-gravity SouthEast"
      options << %Q{-draw "image Over  0,0 7,9 '#{variation_image}"}
    end

    options << "#{path}"
    options << "2>&1"
  end

  def number_images
    @numbar_images ||= @string[0...3].each_char.map do |char|
      "#{BusesImages::ICONS_PATH}#{char}.png"
    end
  end

  def variation_image
    @variatins_image ||= "#{BusesImages::ICONS_PATH}#{@string[3].upcase}.png" if @string[3]
  end
end