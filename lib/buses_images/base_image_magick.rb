class BusesImages::BaseImageMagick
  def save(path)
    r = `#{options(path).join(' ')}`
    @output = r
    puts r if $?.success?
    $?.success?
  end

  def output
    @output
  end
end