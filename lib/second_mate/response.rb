module SecondMate
  class Response

    attr_reader :request_method, :request_path, :request_sequence

    def initialize(options)
      @request_method = options[:request_method]
      @request_path = options[:request_path]
      @request_sequence = options[:request_sequence] or 1
    end

    def respond
      return [404, {}, ["Not found. (#{response_path})"]] unless present?

      begin
        [200, {"Content-Type" => "application/json"}, response_body]
      rescue => e

        [500, e, ['Internal server error.']]
      end
    end

    private
    def present?
      File.exists?(sequenced_response_path) or File.exists?(response_path)
    end
    
    def sequenced_present?
      File.exists?(sequenced_response_path)
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
      sequence_members[(request_sequence - 1) % sequence_members.size]
    end

    def local_path
      File.join request_path.gsub(/(\A\/|\/\Z)/, '').split('/')
    end

  end
end
