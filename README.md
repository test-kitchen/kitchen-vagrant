# Kitchen::Vagrant

[![Build Status](https://travis-ci.org/opscode/kitchen-vagrant.png)](https://travis-ci.org/opscode/kitchen-vagrant)
[![Code Climate](https://codeclimate.com/github/opscode/kitchen-vagrant.png)](https://codeclimate.com/github/opscode/kitchen-vagrant)

This gem provides `kitchen-vagrant`, a driver for `test-kitchen` to provision systems to test under Vagrant.

## Requirements

* [test-kitchen](https://github.com/opscode/test-kitchen) version 1.0 or later
* [Vagrant](http://www.vagrantup.com/) 1.1 or newer

## Installation

Add this line to your application's Gemfile:

    gem 'kitchen-vagrant'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kitchen-vagrant

## Usage

If you were using this plugin before version 0.7, be sure to delete the
`.kitchen` folder in your project and possibly remove your Vagrantfile
unless you have specific configuration options in there. **This plugin
does not need to be required anywhere other than your Gemfile.**

Run the `kitchen init` command with the `-D vagrant` option to install
the Vagrant driver. Define your box settings within the `.kitchen.yml`
file to your liking. The next time you run `kitchen test` it will
automatically generate a Vagrantfile for each defined test suite.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
