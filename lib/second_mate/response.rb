require 'erb'

module SecondMate

  class Response < Rack::Response

    attr_accessor :body, :params, :status, :header

    def initialize(body=[], params={}, status=200, header={})
      @body   = body
      @params = params
      @status = status
      @header = header

      process_yaml
      render_template

      super self.body, self.status, self.header
    end

    private
    def process_yaml
      if self.body =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
        self.body = self.body[($1.size + $2.size)..-1]
        begin
          data = YAML.load($1)

          # Use specified HTTP status
          self.status = data['status'] if data['status']
          # Fill header information
          data['header'].each { |field, value| self.header[field] = value } if data['header'].kind_of? Hash
          self.header['second_mate.yaml_frontmatter'] = 'Yes'
        rescue => e
          self.header['second_mate.yaml_frontmatter'] = 'Error'
        end
      end
    end

    def render_template
      erb = ERB.new @body
      @body = erb.result binding
    end

  end

end
