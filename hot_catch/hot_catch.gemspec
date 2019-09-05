$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "hot_catch/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hot_catch"
  s.version     = HotCatch::VERSION
  s.authors     = ["Davhot"]
  s.email       = ["david.home@mail.ru"]
  s.homepage    = "https://myhomepage.com"
  s.summary     = "Summary of Testgem."
  s.description = "Description of Testgem."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'sidekiq'
  s.add_dependency "sidekiq-cron", "~> 1.1"
  s.add_dependency "server_metrics"
  # s.add_development_dependency "rspec", '~> 0'
end
