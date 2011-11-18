module SecondMate

  class Counter
  
    def initialize(app)
      @app = app
      @request_history = {}
      trap(:INT) { |signal| reset_or_quit signal }
    end

    def call(env)
      env['REQUEST_SEQUENCE_INDEX'] = count env['PATH_INFO']
      @app.call(env)
    end

    private
    def count(path)
      @request_history[path] = (@request_history[path] || 0) + 1
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
