source 'https://rubygems.org'

# Specify your gem's dependencies in kitchen-vagrant.gemspec
gemspec

# This is a workaround to let this driver load our official
# WIP `windows-guest-support` branch in test-kitchen.
#
# We have to release test-kitchen first and then modify the `gemspec`
# to the right version that has the `Kitchen::Transport` Abstraction
# then we can release this.
#
# TODO: REMOVE THIS BEFORE RELEASE
gem 'test-kitchen', git: 'https://github.com/test-kitchen/test-kitchen.git',
                    ref: 'windows-guest-support'

group :test do
  gem 'rake'
end
