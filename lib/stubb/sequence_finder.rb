module Stubb

  class NoSuchSequence < NotFound; end

  class SequenceFinder < Finder
    private
    def projected_path
      sequence_members = glob local_path_for(sequenced_path_pattern)
      raise NoSuchSequence.new("Nothing found for sequence pattern `#{sequenced_path_pattern}`.") if sequence_members.empty?

      loop? ?  pick_loop_member(sequence_members) : pick_stall_member(sequence_members)
    end

    def sm
      sequence_members = Dir.glob local_path_for(sequenced_path_pattern)
    end

    def index
      sequence_members = Dir.glob local_path_for(sequenced_path_pattern)
      "#{(request.sequence_index - 1) % sequence_members.size}/#{sequence_members.size}"
    end

    def pick_loop_member(sequence_members)
        sequence_members[(request.sequence_index - 1) % sequence_members.size]
    end

    def pick_stall_member(sequence_members)
        request.sequence_index > sequence_members.size ? sequence_members.last : sequence_members[request.sequence_index - 1]
    end

    def sequenced_path(index)
      if File.directory? local_path_for(request.relative_path)
        File.join request.relative_path, request_options_as_file_ending(index)
      else
        "#{request.relative_path}.#{request_options_as_file_ending(index)}"
      end
    end

    def sequenced_path_pattern
      sequenced_path('[0-9]')
    end

    def request_options_as_file_ending(index)
      "#{request.request_method}.#{index}#{request.extension}"
    end

    def loop?
      exists? sequenced_path(0)
    end

  end


end
