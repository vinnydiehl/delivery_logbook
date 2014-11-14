require File.expand_path("../lib/delivery_logbook/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name = "delivery_logbook"
  gem.version = DeliveryLogbook::VERSION

  gem.author = "Vinny Diehl"
  gem.email = "vinny.diehl@gmail.com"
  gem.homepage = "https://github.com/vinnydiehl/delivery_logbook"

  gem.license = "MIT"

  gem.summary = "Keep a log of your delivery business!"
  gem.description =
    "For delivery drivers to keep track of the deliveries that " +
    "they've made, who tips and who doesn't, and more."

  gem.bindir = "bin"
  gem.executables = "dlog"

  gem.require_paths = %w[lib]
  gem.files = Dir["lib/**/*"] + %w[
    LICENSE Rakefile README.md delivery_logbook.gemspec
  ]

  gem.required_ruby_version = "~> 2.0"

  gem.add_dependency "commander", "~> 4.2"
  gem.add_dependency "nutella", "~> 0.13"
  gem.add_dependency "StreetAddress", "~> 1.0"

  gem.add_development_dependency "rake", "~> 10.3"
end
