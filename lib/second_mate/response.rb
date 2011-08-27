module SecondMate
  class Response

    attr_reader :request_method, :request_path, :request_sequence

    def initialize(options)
      @request_method = options[:request_method]
      @request_path = options[:request_path]
      @request_sequence = options[:request_sequence] or 1
      @base_dir = options[:base_dir]
    end

    def respond
      return [404, {"Content-Type" => "text/plain"}, ["Not found. (#{response_path})"]] unless present?

      begin
        [200, {"Content-Type" => "application/json"}, response_body]
      rescue => e
        p e
        [500, {"Content-Type" => "text/plain"}, ['Internal server error.']]
      end
    end

    private
    def present?
       File.exists?(response_path) or sequenced_present?
    end
    
    def sequenced_present?
      !!(sequenced_response_path && File.exists?(sequenced_response_path))
    end

    def loop?
      File.exists? response_path(0)
    end

    def response_body
      if sequenced_present?
        File.open(sequenced_response_path, 'r') {|f| f.read }
      else
        File.open(response_path, 'r') {|f| f.read }
      end
    end

    def response_path(sequence = nil)
      if File.directory? local_path
        if sequence
          File.join local_path, "#{request_method}.#{sequence}.json"
        else
          File.join local_path, "#{request_method}.json"
        end
      else
        if sequence
          "#{local_path}.#{request_method}.#{sequence}.json"
        else
          "#{local_path}.#{request_method}.json"
        end
      end
    end

    def sequenced_response_path
      sequence_members = Dir.glob response_path('*')
      if loop?
        sequence_members[(request_sequence - 1) % sequence_members.size]
      else
        request_sequence > sequence_members.size ? sequence_members.last : sequence_members[request_sequence - 1]
      end
    end

    def base_dir
      if @base_dir and not @base_dir.empty?
        @base_dir
      else
        Dir.pwd
      end
    end

    def local_path
      File.join base_dir, request_path.gsub(/(\A\/|\/\Z)/, '').split('/')
    end

  end
end
