
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-syslog_rfc5424"
  spec.version       = "0.1.1"
  spec.authors       = ["Pivotal"]
  spec.email         = %w(cf-loggregator@pivotal.io)
  spec.homepage      = "https://github.com/cloudfoundry/fluent-plugin-syslog_rfc5424"

  spec.summary       = %q{FluentD output plugin to send messages via rfc5424}
  spec.description   = %q{FluentD output plugin to send messages via Syslog rfc5424.}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit", "~> 3.3"
  spec.add_development_dependency "test-unit-rr", "~> 1.0"
  spec.add_development_dependency "pry", "~> 0.12"

  spec.add_runtime_dependency "fluentd", "~> 1.7"
end

