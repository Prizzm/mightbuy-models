$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mightbuy_models/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mightbuy_models"
  s.version     = MightbuyModels::VERSION
  s.authors     = ["Hemant Kumar"]
  s.email       = ["hemant@codemancers.com"]
  s.homepage    = "http://mightbuy.it"
  s.summary     = "Extract most of mightbuy models into engine."
  s.description = "Extract most of mightbuy models into engine."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_development_dependency('rspec', '~> 2.11.0')
  s.add_development_dependency("pry")
end
