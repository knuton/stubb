module Stubb

  class NaiveFinder < Finder
    
    private
    def projected_path
      relative_path = if File.directory? local_path_for(request.resource_path)
        File.join request.resource_path, request_options_as_file_ending
      else
        "#{request.resource_path}.#{request_options_as_file_ending}"
      end

      local_path_for relative_path
    end

  end

end
