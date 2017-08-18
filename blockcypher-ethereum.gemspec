$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "blockcypher/ethereum/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "blockcypher-ethereum"
  s.version     = Blockcypher::Ethereum::VERSION
  s.authors     = ["Jeremy Baker"]
  s.email       = ["ironclad00@gmail.com"]
  s.homepage    = "https://bitbucket.org/ironclad00/blockcypherethereum/"
  s.summary     = "Ruby wrapper for the Blockcypher Ethereum API."
  s.description = "Ruby wrapper for the Blockcypher Ethereum API."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.3"
  s.add_dependency "faraday"

  s.add_development_dependency "sqlite3"
end
