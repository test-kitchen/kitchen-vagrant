lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kitchen/driver/vagrant_version"

Gem::Specification.new do |gem|
  gem.name          = "kitchen-vagrant"
  gem.version       = Kitchen::Driver::VAGRANT_VERSION
  gem.license       = "Apache-2.0"
  gem.authors       = ["Fletcher Nichol"]
  gem.email         = ["fnichol@nichol.ca"]
  gem.description   = "Kitchen::Driver::Vagrant - A HashiCorp Vagrant Driver for Test Kitchen."
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/test-kitchen/kitchen-vagrant/"

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR).grep(/LICENSE|^lib|^support|^templates/)
  gem.require_paths = ["lib"]

  gem.required_ruby_version = ">= 3.0"

  if ENV['CHEF_TEST_KITCHEN_ENTERPRISE']
    gem.add_dependency "chef-test-kitchen-enterprise", ">= 1.1.4", "< 4"
  else
    gem.add_dependency "test-kitchen", ">= 1.4", "< 4"
  end
end
