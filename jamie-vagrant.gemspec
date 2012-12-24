# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jamie/driver/vagrant_version.rb'

Gem::Specification.new do |gem|
  gem.name          = "jamie-vagrant"
  gem.version       = Jamie::Driver::VAGRANT_VERSION
  gem.authors       = ["Fletcher Nichol"]
  gem.email         = ["fnichol@nichol.ca"]
  gem.description   = "Jamie::Driver::Vagrant - A Vagrant Driver for Jamie."
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/jamie-ci/jamie-vagrant/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = []
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'jamie'
  gem.add_dependency 'vagrant', '~> 1.0.5'

  gem.add_development_dependency 'cane'
  gem.add_development_dependency 'tailor'
end
