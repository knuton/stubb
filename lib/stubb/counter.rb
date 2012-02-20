module Stubb

  class Counter
  
    def initialize(app)
      @app = app
      @request_history = {}
      trap(:INT) { |signal| reset_or_quit signal }
    end

    def call(env)
      env['stubb.request_sequence_index'] = count(env['REQUEST_METHOD'], env['PATH_INFO'], env['HTTP_ACCEPT'])
      @app.call(env)
    end

    private
    def count(method, path, accept)
      fingerprint = "#{method}-#{path}-#{accept}"
      @request_history[fingerprint] = (@request_history[fingerprint] || 0) + 1
    end

    def reset_or_quit(signal)
      if @request_history.empty?
        exit! signal
      else
        @request_history.clear
        puts "\n\nReset request history. Interrupt again to quit.\n\n"
      end
    end

  end

end
