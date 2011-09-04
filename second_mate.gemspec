Gem::Specification.new do |s|
  s.name        = 'second_mate'
  s.version     = '0.0.9'
  s.date        = '2011-09-04'
  s.summary     = "Specify REST API stubs using your file system"
  s.description = "Stubb is the second mate."
  s.authors     = ["Johannes Emerich"]
  s.email       = 'johannes@emerich.de'
  s.homepage    = 'http://github.com/knuton/second_mate'
  s.files       = [
    "lib/second_mate.rb", "lib/second_mate/request.rb",
    "lib/second_mate/finder.rb", "lib/second_mate/naive_finder.rb"
    "lib/second_mate/sequence_finder.rb", "lib/second_mate/match_finder.rb"
    "LICENSE", "README.markdown"
  ]
    
  s.add_runtime_dependency "rack", ">=1.2.0"

end
