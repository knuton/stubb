require 'bundler/setup'
require 'rake/testtask'

Bundler::GemHelper.install_tasks

Rake::TestTask.new(:test) do |test|
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
