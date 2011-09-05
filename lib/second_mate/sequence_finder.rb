module SecondMate

  class NoSuchSequence < Exception; end

  class SequenceFinder < Finder
    private
    def respond
      response_body = file_contents(projected_path)
      Rack::Response.new(response_body).finish
    rescue NoSuchSequence
      [404, {}, 'No such sequence.']
    end

    def projected_path
      sequence_members = Dir.glob sequenced_path('*')
      raise NoSuchSequence if sequence_members.empty?

      if loop?
        sequence_members[(request.sequence_index - 1) % sequence_members.size]
      else
        request.sequence_index > sequence_members.size ? sequence_members.last : sequence_members[request.sequence_index - 1]
      end
    end

    def sequenced_path(index)
      if File.directory? local_path_for(request.relative_path)
        File.join request.relative_path, request_options_as_file_ending(index)
      else
        "#{request.relative_path}.#{request_options_as_file_ending(index)}"
      end
    end

    def request_options_as_file_ending(index)
      "#{request.request_method}.#{index}#{request.extension}"
    end

    def loop?
      exists? sequenced_path(0)
    end

  end


end
