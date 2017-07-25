# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kitchen/driver/vagrant_version.rb"
require "English"

Gem::Specification.new do |gem|
  gem.name          = "kitchen-vagrant"
  gem.version       = Kitchen::Driver::VAGRANT_VERSION
  gem.license       = "Apache 2.0"
  gem.authors       = ["Fletcher Nichol"]
  gem.email         = ["fnichol@nichol.ca"]
  gem.description   = "Kitchen::Driver::Vagrant - A Vagrant Driver for Test Kitchen."
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/test-kitchen/kitchen-vagrant/"

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = []
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "test-kitchen", "~> 1.4"

  gem.add_development_dependency "countloc", "~> 0.4"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec",     "~> 3.2"
  gem.add_development_dependency "simplecov", "~> 0.9"
  gem.add_development_dependency "github_changelog_generator", "1.11.3"

  gem.add_development_dependency "chefstyle"
end
