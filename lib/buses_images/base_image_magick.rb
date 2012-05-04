class BusesImages::BaseImageMagick
  def save(path)
    path = File.expand_path path
    r = `#{options(path).join(' ')}`
    @output = r
    puts r if not $?.success?
    $?.success? ? path : false
  end

  def output
    @output
  end
end