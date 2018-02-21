lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "resource_inspector/version"

Gem::Specification.new do |s|
  s.name = "resource_inspector"
  s.version = ResourceInspector::VERSION
  s.authors = ["Thom May"]
  s.email = "thom@chef.io"

  s.summary = %q{Generate metadata about Chef resources}
  s.description = %q{Generate metadata about Chef resources}
  s.homepage = "https://github.com/chef/resource_inspector"

  s.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir = "bin"
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = %w{lib}
  s.add_development_dependency "bundler", "~> 1.16"
  s.add_development_dependency "rake", "~> 12.0"
  s.add_development_dependency "rspec", "~> 3.0"
end
