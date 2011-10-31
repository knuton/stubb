require 'erb'

module SecondMate

  class Response < Rack::Response

    def initialize(body=[], params={}, status=200, header={})
      super render_template(body, params), status, header
    end

    def render_template(template, params)
      erb = ERB.new template
      erb.result binding
    end

  end

end
