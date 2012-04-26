class L
	@@first = []
  @@default_log_path = (Rails.root + "log/%s").to_s
  @@default_log_file = "mylog.log"

	class << self
    def log_to(data, file_name = @@default_log_file)
      first_time file_name

      file = @@default_log_path % file_name.to_s

      File.open(file, 'a') do |f|
        f.write (data)
			end
    end

		def l(*args)
      log_to parse args.map(&:inspect)
    end

    def rl(*args)
      log_to parse args
    end

    def l_to(*args, file_name)
      log_to parse(args.map(&:inspect)), file_name
    end

    def rl_to(*args, file_name)
      log_to parse(args.join(', ')), file_name
    end

    private

		def first_time(file_name)
      if not @@first.include? file_name
        @@first << file_name
        log_to "##----------------------------------------------------------------##\s", file_name
      end
    end

    def parse(args)
      args.join(", ") + "\n"
    end
	end
end