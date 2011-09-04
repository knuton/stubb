module SecondMate

  class Request < Rack::Request

    def path_parts
      relative_path.split '/'
    end

    def path_dir_parts
      File.dirname(relative_path).split '/'
    end

    def file_name
      path_parts.last
    end

    def resource_name
      file_name.split('.')[0..-2].join('.')
    end

    def extension
      # TODO Accept-Header
      File.extname(relative_path)
    end

    def relative_path
      # Strip slashes at string end and start
      path_info.gsub /(\A\/|\/\Z)/, ''
    end

  end

end
