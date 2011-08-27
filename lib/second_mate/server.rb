module SecondMate
  class Server

    def initialize
      @request_count = {}
    end

    def call(env)
      method = env.request_method
      path = env.path
      sequence = sequence(method, path)
      response = Response.new :request_method => method, :request_path => path, :request_sequence => sequence
      response.respond
    end

    private
    def sequence(method, path, accept = '')
      request_id = method + path + accept
      @request_count[request_id] = (@request_count[request_id] or 0) + 1
    end


  end
end
