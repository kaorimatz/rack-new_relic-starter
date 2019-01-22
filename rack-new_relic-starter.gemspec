# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/new_relic/starter/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-new_relic-starter'
  spec.version       = Rack::NewRelic::Starter::VERSION
  spec.authors       = ['Satoshi Matsumoto']
  spec.email         = ['kaorimatz@gmail.com']

  spec.summary       = 'A Rack middleware to start the New Relic agent.'
  spec.description   = <<-DESCRIPTION
  A Rack middleware that provides an endpoint to start the New Relic agent.
  DESCRIPTION
  spec.homepage      = 'https://github.com/kaorimatz/rack-new_relic-starter'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/}) }
  end
  spec.require_paths = ['lib']
  spec.extensions    = ['ext/rack_new_relic_starter/extconf.rb']

  spec.add_runtime_dependency 'newrelic_rpm'
  spec.add_runtime_dependency 'rack'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rake-compiler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-mocks'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'unicorn'
end
