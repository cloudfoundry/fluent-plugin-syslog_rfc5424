
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluentd_syslog_rfc5424"
  spec.version       = "0.1"
  spec.authors       = ["Travis Patterson, Rachel Heaton", "Ben Fuller"]
  spec.email         = %w(tpatterson@pivotal.io rheaton@pivotal.io bfuller@pivotal.io)

  spec.summary       = %q{Send messages via rfc5424}
  spec.description   = %q{Send messages via rfc5424}
  spec.license       = "TODO"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "test-unit-rr"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "fluentd"
end
