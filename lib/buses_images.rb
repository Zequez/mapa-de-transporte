module BusesImages
  def self.included(base)
    base.extend ClassMethods
  end

  def handle_bus_image
    if CONFIG[:buses_images_on_save]
      generate_bus_image
      self.class.generate_buses_images_sheet
    else
      self.class.delete_buses_images_sheet
    end
  end

  def generate_bus_image
    path = image_path
    darker_color_1 =  Color.new(color_1).darken(0.3)

    convert = ["convert"]
    convert << "-size 24x12"
    convert << "-font 'Courier-Bold'"
    convert << "-pointsize 9"
    convert << "-gravity South"
    convert << "-background '#{color_1}'"
    convert << "-fill '#{color_2}'"
    convert << "-bordercolor '#{darker_color_1}'"
    convert << "-border 1"
    convert << "label:#{name}"
    convert << "'#{path}'"
    convert << "2>&1"

    r = `#{convert.join ' '}`

    raise "Error creating image" if not $?.success?
  end

  def image_path
    self.class.images_paths(id)
  end

  module ClassMethods
    def rebuild_buses_images
      all.each(&:generate_bus_image)
      generate_buses_images_sheet
    end

    def generate_buses_images_sheet
      paths = images_paths

      montage = ["montage"]
      montage << "-border 0"
      montage << "-frame 0"
      montage << "-label ''"
      montage << "-tile 1x"
      montage << "-geometry '22x'"
      montage << "'#{paths}'"
      montage << "'#{CONFIG[:buses_images_sheet_path]}'"
      montage << "2>&1"

      r = `#{montage.join ' '}`

      raise "Error creating the montaged image" if not $?.success?
    end

    def delete_buses_images_sheet
      FileUtils.rm CONFIG[:buses_images_sheet_path] if File.exists?(CONFIG[:buses_images_sheet_path])
    end

    def images_paths(id = '*')
      (Rails.root + CONFIG[:bus_image_path]).to_s.sub(':id', id.to_s)
    end
  end
end