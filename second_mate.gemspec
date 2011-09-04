Gem::Specification.new do |s|
  s.name        = 'second_mate'
  s.version     = '0.0.9'
  s.date        = '2011-08-28'
  s.summary     = "Specify REST API stubs using your file system"
  s.description = "Stubb is the second mate."
  s.authors     = ["Johannes Emerich"]
  s.email       = 'johannes@emerich.de'
  s.homepage    = 'http://github.com/knuton/second_mate'
  s.files       = [
    "lib/second_mate.rb", "lib/second_mate/server.rb",
    "lib/second_mate/response.rb", 
    "LICENSE", "README.markdown"
  ]
    
  s.add_runtime_dependency "rack", "~>1.3.0"

end
