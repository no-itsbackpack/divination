# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'divination/version'

Gem::Specification.new do |spec|
  spec.name          = "divination"
  spec.version       = Divination::VERSION
  spec.authors       = ["Elom Gomez"]
  spec.email         = ["gomezelom@yahoo.com"]

  spec.summary       = %q{Simple implementation of cursor pagination for Rails and ActiveRecord.}
  spec.description   = %q{A simple implementation of cursor pagination for Rails and ActiveRecord, it pages based on the primary_key or id of the table.}
  spec.homepage      = "https://github.com/paddingtonsbear/divination"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', '~> 5.0.0'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'rr', '>= 0'
  spec.add_development_dependency 'railties', '~> 5.0.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3.11'
  spec.add_development_dependency 'pry'
end
