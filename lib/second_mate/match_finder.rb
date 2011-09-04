module SecondMate

  class MatchFinder < Finder
    def respond
      [404, {}, 'no match :(']
    end
  end


end
