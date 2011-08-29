module SecondMate

  class ResponseNotFound < Exception
  end

  @config = {
   :matcher_prefix => ':'
  }

  def self.method_missing(m, *attrs)
    if @config[m.to_sym]
      @config[m.to_sym]
    elsif @config[m.chomp('=').to_sym]
      @config[m.chomp('=').to_sym] = attrs[0]
    end
  end

  def self.mime_type(file_path)
    if file_path == '.html'
      'text/html'
    else
      'application/json'
    end
  end

end

require 'second_mate/response'
require 'second_mate/server'
