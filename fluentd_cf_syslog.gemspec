
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fluentd_cf_syslog/version"

Gem::Specification.new do |spec|
  spec.name          = "fluentd_cf_syslog"
  spec.version       = FluentdCfSyslog::VERSION
  spec.authors       = ["Travis Patterson, Rachel Heaton"]
  spec.email         = %w(tpatterson@pivotal.io rheaton@pivotal.io)

  spec.summary       = %q{Best Loggin Gem Ever}
  spec.description   = %q{See above}
  spec.license       = "Apache 2"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = "http://google.com"
    spec.metadata["source_code_uri"] = "http://google.com"
    spec.metadata["changelog_uri"] = "http://google.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency "fluentd"
  spec.add_runtime_dependency "syslogger5424", "~> 0.5.3"
end
