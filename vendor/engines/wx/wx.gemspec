$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "wx/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "wx"
  s.version     = Wx::VERSION
  s.authors     = ["cuizheng"]
  s.email       = ["zheng.cuizh@gmail.com"]
  s.homepage    = ""
  s.summary     = "Cinema WX server"
  s.description = "Cinema WX server"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "sqlite3"
end
