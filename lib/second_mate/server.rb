module SecondMate
  class Server

    attr_reader :base_dir

    def initialize(base_dir = '')
      @base_dir = base_dir
      @request_count = {}
    end

    def call(env)
      method = env.request_method
      path = env.path
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
