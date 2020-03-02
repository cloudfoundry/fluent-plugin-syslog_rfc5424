require "bundler/gem_tasks"
require 'rake/testtask'
require 'fluent-plugin-syslog_rfc5424/version'

Rake::TestTask.new(:test) do |test|
  test.libs << "lib" << "test"
  test.pattern = "test/**/*_spec.rb"
  test.verbose = true
end

task default: :test

task :version do
  puts FluentSyslog5424OutputPlugin::VERSION
end
