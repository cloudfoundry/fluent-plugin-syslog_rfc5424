require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << "lib" << "test"
  test.pattern = "test/**/*_spec.rb"
  test.verbose = true
end

task default: :test
