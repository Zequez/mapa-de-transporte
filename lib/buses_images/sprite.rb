class BusesImages::Sprite < BusesImages::BaseImageMagick
  def initialize(icons_path)
    @icons_path = icons_path
  end

  def options(path)
    options = []
    options << "montage"
    options << "#{@icons_path}*"
    options << "-gravity Center"
    options << "-mode concatenate"
    options << "-tile 1x"
    options << "#{path}"
  end
end