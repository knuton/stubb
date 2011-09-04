module SecondMate

  class SequenceFinder < Finder
    def respond
      [404, {}, 'nope :(']
    end
  end


end
