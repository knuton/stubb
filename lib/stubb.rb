require 'rack'

module Stubb

  VERSION = '0.2.0'

  class ResponseNotFound < Exception
  end

  @config = {
   :matcher_pattern => '_*_'
  }

  def self.method_missing(m, *attrs)
    # Ease access to @config
    if @config[m.to_sym]
      @config[m.to_sym]
    elsif @config[m.to_s.chomp('=').to_sym]
      @config[m.to_s.chomp('=').to_sym] = attrs[0]
    else
      super
    end
  end

  def self.app(options = {})
    Rack::Builder.new {
      use CombinedLogger
      use Counter

      run Rack::Cascade.new [
        SequenceFinder.new(options),
        NaiveFinder.new(options),
        SequenceMatchFinder.new(options),
        MatchFinder.new(options)
      ]
    }.to_app
  end

  def self.run(options = {})
    Rack::Handler.default.run(
      app({:root => ''}.update(options)),
      {:Port => 4040}.update(options)
    )
  end

end

require 'stubb/request'
require 'stubb/response'
require 'stubb/counter'
require 'stubb/combined_logger'
require 'stubb/finder'
require 'stubb/naive_finder'
require 'stubb/sequence_finder'
require 'stubb/match_finder'
require 'stubb/sequence_match_finder'
