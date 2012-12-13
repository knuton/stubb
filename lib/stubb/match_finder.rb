module Stubb

  class NoMatch < NotFound; end

  class MatchFinder < Finder
    private
    def projected_path
      built_path  = []
      last_is_dir = false
      request.path_parts.each_with_index do |level, index|
        if match = literal_directory(built_path, level)
          last_is_dir = true
        elsif match = literal_file(built_path, level)
          last_is_dir = false
        elsif match = matching_directory(built_path)
          last_is_dir = true
        elsif match = matching_file(built_path)
          last_is_dir = false
        else
          raise NoMatch.new("Not found.")
        end

        built_path << match
      end

      if last_is_dir
        File.join local_path_for(built_path), request_options_as_file_ending
      else
        local_path_for built_path
      end
    end

    def literal_directory(current_path, level)
      File.directory?(local_path_for(current_path + [level])) ? level: nil
    end

    def literal_file(current_path, level)
      parts = level.split('.')
      level = parts.size > 1 ? parts[0..-2].join('.') : parts.first
      filename = "#{level}.#{request_options_as_file_ending}"
      File.exists?(local_path_for(current_path + [filename])) ? filename : nil
    end

    def matching_directory(current_path)
      matches = glob local_path_for(current_path + [Stubb.matcher_pattern])
      for match in matches
        continue unless File.directory? match
        return File.split(match).last
      end
      nil
    end

    def matching_file(current_path)
      matches = glob local_path_for(current_path + ["#{Stubb.matcher_pattern}.#{request_options_as_file_ending}"])

      matches.empty? ? nil : File.split(matches.first).last
    end

  end


end
