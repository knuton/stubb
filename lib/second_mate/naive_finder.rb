module SecondMate

  class NaiveFinder < Finder
    
    private
    def respond
      path = local_path_for(projected_path)
      debug "Trying `#{path}`."
      response_body = File.open(path, 'r')  {|f| f.read }
      Response.new(response_body, request.params, 200, {'Content-Type' => content_type}).finish
    end

    def projected_path
      if File.directory? local_path_for(request.resource_path)
        File.join request.resource_path, request_options_as_file_ending
      else
        "#{request.resource_path}.#{request_options_as_file_ending}"
      end
    end

  end

end
