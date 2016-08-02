# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'goodguide/health/version'

Gem::Specification.new do |spec|
  spec.name          = 'goodguide-health'
  spec.version       = Goodguide::Health::VERSION
  spec.authors       = ['Ryan Taylor Long']
  spec.email         = ['ryan.long@goodguide.com']
  spec.summary       = 'application health summary check/endpoint'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ['lib']

  spec.add_dependency 'goodguide-pinglish', '~> 1.0'
  spec.add_dependency 'rack', '>= 1.3'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'timecop'
end
