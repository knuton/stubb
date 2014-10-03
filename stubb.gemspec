Gem::Specification.new do |s|
  s.name        = 'stubb'
  s.version     = '0.2.0'
  s.date        = '2014-10-03'
  s.summary     = 'Specify REST API stubs using your file system'
  s.description = 'Stubb is the second mate.'
  s.authors     = ['Johannes Emerich']
  s.email       = 'johannes@emerich.de'
  s.homepage    = 'http://github.com/knuton/stubb'
  s.files       = [
    'lib/stubb.rb',
    'lib/stubb/request.rb',
    'lib/stubb/response.rb',
    'lib/stubb/counter.rb',
    'lib/stubb/combined_logger.rb',
    'lib/stubb/finder.rb',
    'lib/stubb/naive_finder.rb',
    'lib/stubb/sequence_finder.rb',
    'lib/stubb/match_finder.rb',
    'lib/stubb/sequence_match_finder.rb',
    'bin/stubb',
    'LICENSE',
    'README.markdown'
  ]
  s.executables = ['stubb']

  s.add_development_dependency 'rake'

  s.add_runtime_dependency 'rack', '>=1.2.0'
  s.add_runtime_dependency 'thor'

end
