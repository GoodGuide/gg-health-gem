$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'goodguide-health/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'goodguide-health'
  s.version     = GoodguideHealth::VERSION
  s.authors     = ['Jay Adkisson', 'Joshua Bates', 'Matt Ridenour']
  s.email       = ['jay@goodguide.com', 'joshua.bates@goodguide.com', 'matt@goodguide.com']
  s.homepage    = 'TODO'
  s.summary     = 'TODO: Summary of GoodguideHealth.'
  s.description = 'TODO: Description of GoodguideHealth.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '~> 3.2.18'
end
