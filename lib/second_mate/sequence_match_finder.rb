module SecondMate

  class SequenceMatchFinder < SequenceFinder
    private

    def sequenced_path(sequence_index)
      built_path  = []
      last_is_dir = false
      request.path_parts.each_with_index do |level, index|
        if match = literal_directory(built_path, level)
          last_is_dir = true
        elsif match = literal_file(built_path, level, sequence_index)
          last_is_dir = false
        elsif match = matching_directory(built_path)
          last_is_dir = true
        elsif match = matching_file(built_path, sequence_index)
          last_is_dir = false
        else
          return 'NOT FOUND!'
        end

        built_path << match
      end

      if last_is_dir
        File.join built_path, request_options_as_file_ending(sequence_index)
      else
        File.join built_path
      end
    end

    def literal_directory(current_path, level)
      File.directory?(local_path_for(current_path + [level])) ? level: nil
    end

    def literal_file(current_path, level, index)
      filename = "#{level}.#{request_options_as_file_ending(index)}"
      sequence_members = Dir.glob local_path_for(current_path + [filename])
      sequence_members.empty? ? nil : filename
    end

    def matching_directory(current_path)
      matches = Dir.glob local_path_for(current_path + [SecondMate.matcher_pattern])
      for match in matches
        continue unless File.directory? match
        return File.split(match).last
      end
      nil
    end

    def matching_file(current_path, index)
      matches = Dir.glob local_path_for(current_path + ["#{SecondMate.matcher_pattern}.#{request_options_as_file_ending(index)}"])

      matches.empty? ? nil : File.split(matches.first).last
    end

  end

end
