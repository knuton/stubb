module SecondMate

  class Finder
    
    attr_accessor :request, :root

    def initialize(root = '')
      @root = File.expand_path root
    end

    def call(env)
      @request = Request.new env

      respond

    rescue Errno::ENOENT, Errno::ELOOP
      [404, {"Content-Type" => "text/plain"}, ["Not found."]]
    rescue Exception => e
      p e
      [500, {'Content-Type' => 'text/plain'}, 'Internal server error.']
    end

    private
    def respond
      raise "SecondMate::Finder can not respond directly and needs to be subclassed."
    end

    def request_options_as_file_ending
      "#{request.request_method}#{request.extension}"
    end

    def exists?(relative_path)
      File.exists? local_path_for(relative_path)
    end

    def local_path_for(relative_path)
      File.join root, relative_path
    end

    def log(*messages)
      if request.env['rack.errors'] && request.env['rack.errors'].respond_to?('write')
        env['rack.errors'].write messages.join("\n")
      else
        puts *messages
      end
    end

  end

end
