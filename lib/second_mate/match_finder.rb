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
    # REFACTOR Break out finding of literal matches
    def projected_path
      built_path  = []
      last_is_dir = false 
      request.path_parts.each_with_index do |level, index|
        if File.directory? local_path_for(built_path + [level])
          built_path << level
          last_is_dir = true
        elsif File.exists? local_path_for(built_path + ["#{level}.#{request_options_as_file_ending}"])
          built_path << "#{level}.#{request_options_as_file_ending}"
          last_is_dir = false
        else
          if match = matching_directory(built_path)
            last_is_dir = true
          elsif match = matching_file(built_path)
            last_is_dir = false
          else
            raise NoMatch unless match
          end

          built_path << match
        end
      end

      if last_is_dir
        File.join local_path_for(built_path), request_options_as_file_ending
      else
        local_path_for built_path
      end
    end

    def matching_directory(current_path)
      matches = Dir.glob local_path_for(current_path + [SecondMate.matcher_pattern])
      for match in matches
        continue unless File.directory? match
        return File.split(match).last
      end
      nil
    end

    def matching_file(current_path)
      matches = Dir.glob local_path_for(current_path + ["#{SecondMate.matcher_pattern}.#{request_options_as_file_ending}"])

      matches.empty? ? nil : File.split(matches.first).last
    end

  end


end
