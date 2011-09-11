module SecondMate

  class NoMatch < Exception; end

  class MatchFinder < Finder
    def respond
      response_body = File.open(projected_path, 'r')  {|f| f.read }
      Rack::Response.new(response_body).finish
    rescue NoMatch => e
      log e.message
      [404, {}, "No match."]
    end

    private
    def projected_path
      built_path = []
      request.path_parts.each_with_index do |level, index|
        log built_path, local_path_for(built_path)
        if File.exists? local_path_for(built_path + [level])
          built_path << level
        else
          matchers = Dir.glob(local_path_for(built_path + [SecondMate.matcher_pattern]))
          matchers = Dir.glob(local_path_for(built_path + ["#{SecondMate.matcher_pattern}.#{request_options_as_file_ending}"])) if matchers.empty?

          raise NoMatch if matchers.empty?

          built_path << File.split(matchers.first).last
        end
      end

      local_path_for built_path
    end

  end


end
