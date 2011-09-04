require 'rack'

module SecondMate

  class ResponseNotFound < Exception
  end

  @config = {
   :matcher_prefix => ':'
  }

  def self.method_missing(m, *attrs)
    # Ease access to @config
    if @config[m.to_sym]
      @config[m.to_sym]
    elsif @config[m.chomp('=').to_sym]
      @config[m.chomp('=').to_sym] = attrs[0]
    else
      super
    end
  end

  def self.app
    Rack::Builder.new {
      use Rack::CommonLogger
      #use SecondMate::Counter
      
      run Rack::Cascade.new([SequenceFinder.new, NaiveFinder.new, MatchFinder.new])
    }.to_app
  end

  def self.run(options = {})
    Rack::Handler.default.run app, {
      :Port => 4040
    }.update(options)
  end

end

require 'second_mate/request'
require 'second_mate/finder'
require 'second_mate/naive_finder'
require 'second_mate/sequence_finder'
require 'second_mate/match_finder'
