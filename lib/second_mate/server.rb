require 'rack'

module SecondMate
  class Server

    attr_reader :base_dir

    def self.start(options)
      rack_server = Rack::Server.new options.merge :app => new
      rack_server.start
    end

    def initialize(base_dir = '')
      @base_dir = base_dir
      @request_count = {}
    end

    def call(env)
      method = env['REQUEST_METHOD']
      path = env['REQUEST_PATH']
      sequence = sequence(method, path)
      response = Response.new(
        :base_dir => base_dir, :request_method => method,
        :request_path => path, :request_sequence => sequence
      )

      response.respond
    end

    private
    def sequence(method, path, accept = '')
      request_id = method + path + accept
      @request_count[request_id] = (@request_count[request_id] or 0) + 1
    end


  end
end
