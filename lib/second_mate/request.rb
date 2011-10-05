module SecondMate

  class Request < Rack::Request

    def path_parts
      relative_path.split '/'
    end

    def path_dir_parts
      parts = path_parts
      parts.size > 1 ? parts[0..-2] : []
    end

    def file_name
      path_parts.last
    end

    def resource_name
      parts = file_name.split('.')
      parts.size > 1 ? parts[0..-2].join('.') : parts.first
    end

    def resource_path
      File.join((path_dir_parts << resource_name).compact)
    end

    def extension
      extension_by_path.empty? ? extension_by_header : extension_by_path
    end

    def extension_by_path
      File.extname(relative_path)
    end

    def extension_by_header
      Rack::Mime::MIME_TYPES.invert[@env['HTTP_ACCEPT']]
    end

    def relative_path
      # Strip slashes at string end and start
      path_info.gsub /(\A\/|\/\Z)/, ''
    end

    def sequence_index
      @env['REQUEST_SEQUENCE_INDEX'] || 1
    end

  end

end
