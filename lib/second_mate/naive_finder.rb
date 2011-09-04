module SecondMate

  class NaiveFinder < Finder
    
    private
    def respond
      response_body = file_contents(projected_path)
      Rack::Response.new(response_body).finish
    end

    def projected_path
      if File.directory? local_path_for(request.relative_path)
        File.join request.relative_path, request_options_as_file_ending
      else
        "#{request.relative_path}.#{request_options_as_file_ending}"
      end
    end

  end

end
