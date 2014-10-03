module Stubb

  class NotFound < Exception; end

  class Finder

    attr_accessor :request, :root

    def initialize(options = {})
      @root = File.expand_path options[:root] || ''
      @verbose = options[:verbose] || false
    end

    def call(env)
      @request = Request.new env

      respond

    rescue Errno::ENOENT, Errno::ELOOP
      [404, {"Content-Type" => "text/plain"}, ["Not found."]]
    rescue Exception => e
      debug e.message, e.backtrace.join("\n")
      [500, {'Content-Type' => 'text/plain'}, ['Internal server error.']]
    end

    private
    def respond
      response_file_path = projected_path
      response_body = File.open(response_file_path, 'r')  {|f| f.read }
      Response.new(
        response_body,
        request.params,
        200,
        {'Content-Type' => content_type, 'X-Stubb-Response-File' => response_file_path}
      ).finish
    rescue NotFound => e
      debug e.message
      [404, {}, [e.message]]
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

    def glob(pattern)
      Dir.glob(pattern).sort
    end

    def content_type
      Rack::Mime.mime_type(request.extension) || "text/html"
    end

    def debug(*messages)
      log(*messages) if @verbose
    end

    def log(*messages)
      if request.env['rack.errors'] && request.env['rack.errors'].respond_to?('write')
        request.env['rack.errors'].write messages.join(" ") << "\n"
      else
        puts messages.join(" ")
      end
    end

  end

end
