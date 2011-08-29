module SecondMate
  class Response

    attr_reader :request_method, :request_sequence, :request_params, :response_header, :response_body

    def initialize(options)
      @request_method   = options[:request_method]
      @request_path     = options[:request_path]
      @request_sequence = options[:request_sequence] or 1
      @request_params   = options[:request_params]
      @base_dir         = options[:base_dir]
    end

    def respond
      construct
      [200, response_header, response_body]
    rescue ResponseNotFound => e
      [404, {"Content-Type" => "text/plain"}, ["Not found. (#{response_path})"]]
    rescue Exception => e
      p e
      [500, {"Content-Type" => "text/plain"}, ['Internal server error.']]
    end

    private
    def construct
      used_file = if sequenced_present?
        sequenced_response_path
      elsif present?
        response_path
      else
        matched_response_path
      end

      @response_body = File.open(used_file, 'r')  {|f| f.read }
      @response_header = {
        "Content-Type" => SecondMate.mime_type(used_file[/\.[^.]+$/])
      }
    end

    # Request data

    def request_hierarchy
      request_path.split '/'
    end

    def request_dirtree
      request_hierarchy[0..-2]
    end

    def request_hierarchy_without_extension
      request_dirtree << request_resourcename
    end

    def request_path
      # Strip slashes at string end and start
      @request_path.gsub /(\A\/|\/\Z)/, ''
    end

    def request_filename
      request_hierarchy.last
    end

    def request_resourcename
      request_filename.split('.')[0]
    end

    def request_extension
      request_filename.split('.')[1]
    end

    # Direct

    def present?
       File.exists?(response_path)
    end

    def response_path(sequence = nil)
      if File.directory? local_path
        File.join local_path, request_options_as_file_ending(sequence)
      else
        "#{local_path}.#{request_options_as_file_ending(sequence)}"
      end
    end

    # Sequences

    def sequenced_present?
      !!(sequenced_response_path && File.exists?(sequenced_response_path))
    end

    def sequenced_response_path
      sequence_members = Dir.glob response_path('*')
      if loop?
        sequence_members[(request_sequence - 1) % sequence_members.size]
      else
        request_sequence > sequence_members.size ? sequence_members.last : sequence_members[request_sequence - 1]
      end
    end

    def loop?
      File.exists? response_path(0)
    end

    # Matchers

    def matched_response_path
      return local_path(@built_path) if @built_path

      built_path = []
      request_hierarchy.each_with_index do |level, index|
        if File.exists? local_path(built_path + [level])
          built_path << level
        else
          matchers = Dir.glob(local_path(built_path + [SecondMate.matcher_prefix + '*']))

          raise ResponseNotFound if matchers.empty?

          built_path << matchers.first[/(:[^\/]+)(?=$)/]
        end
      end

      @built_path = built_path

      local_path @built_path
    end

    # Path helpers

    def response_extension
      request_extension || 'json'
    end

    def local_path(hierarchy = nil)
      File.join base_dir, hierarchy || request_hierarchy_without_extension
    end

    def request_options_as_file_ending(sequence = nil)
      if sequence
        "#{request_method}.#{sequence}.#{response_extension}"
      else
        "#{request_method}.#{response_extension}"
      end
    end

    def base_dir
      if @base_dir and not @base_dir.empty?
        @base_dir
      else
        Dir.pwd
      end
    end

  end
end
