class ColorsHelper
  @@saturations = [100, 60, 80]
  @@lights      = [30, 50, 70]
  @@hues        = [0, 90, 135, 180, 225, 270, 315]

  def normal
    @normal ||= each_color do |hue, saturation, light|
      Color.hsl(hue, saturation, light).to_rgb
    end
  end

  def dark
    @dark ||= each_color do |hue, saturation, light|
      Color.hsl(hue, saturation, light).darken!(0.1).to_rgb
    end
  end

  def light
    @light ||= each_color do |hue, saturation, light|
      Color.hsl(hue, saturation, light).lighten!(0.1).to_rgb
    end
  end


  def each_color(&block)
    result = []

    @@saturations.each do |saturation|
      @@lights.each do |light|
        @@hues.each do |hue|
          result << block.call(hue, saturation, light)
        end
      end
    end

    result
  end
end