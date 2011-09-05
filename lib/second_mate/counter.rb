module SecondMate

  class Counter
  
    def initialize(app)
      @app = app
      @paths_requests = {}
    end

    def call(env)
      env['REQUEST_SEQUENCE_INDEX'] = count env['PATH_INFO']
      @app.call(env)
    end

    def count(path)
      @paths_requests[path] = (@paths_requests[path] || 0) + 1
    end

  end

end
