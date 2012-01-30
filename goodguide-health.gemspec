$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "goodguide-health/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "goodguide-health"
  s.version     = GoodguideHealth::VERSION
  s.authors     = ["Jay Adkisson", "Joshua Bates"]
  s.email       = ["jay@goodguide.com", "joshua.bates@goodguide.com"]
  s.homepage    = "www.goodguide.com"
  s.summary     = "Adds /health endpoint for haproxy"
  s.description = "Adds /health endpoint for haproxy"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
end
