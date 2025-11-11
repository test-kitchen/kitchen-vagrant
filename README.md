# Kitchen::Vagrant

[![Gem Version](https://badge.fury.io/rb/kitchen-vagrant.svg)](http://badge.fury.io/rb/kitchen-vagrant)
[![CI](https://github.com/test-kitchen/kitchen-vagrant/actions/workflows/lint.yml/badge.svg)](https://github.com/test-kitchen/kitchen-vagrant/actions/workflows/lint.yml)

A Test Kitchen Driver for HashiCorp Vagrant.

This driver works by generating a single Vagrantfile for each instance in a
sandboxed directory. Since the Vagrantfile is written out on disk, Vagrant
needs absolutely no knowledge of Test Kitchen. So no Vagrant plugins are
required.

## Requirements

### Vagrant

Vagrant version of 2.4 or later.

## Installation

The kitchen-vagrant driver ships as part of Chef Workstation. The easiest way to use this driver is to use it with Chef Workstation.

If you want to install the driver directly into a Ruby installation:

```sh
gem install kitchen-vagrant
```

If you're using Bundler, simply add it to your Gemfile:

```ruby
gem "kitchen-vagrant"
```

... and then run `bundle install`.

## Configuration and Usage

See the [kitchen.ci Vagrant Driver Page](https://kitchen.ci/docs/drivers/vagrant/) for documentation on configuring this driver.

### Custom SSH Port Configuration

If your VM's SSH daemon listens on a non-standard port (other than port 22), you can configure Test Kitchen to use the custom port:

```yaml
driver:
  name: vagrant
  ssh:
    guest_port: 444  # SSH daemon listens on port 444 inside the VM
  network:
    - ["forwarded_port", {guest: 444, host: 2222, auto_correct: true}]
```

This configuration tells Vagrant that the SSH daemon inside the guest VM is listening on port 444 instead of the default port 22. Vagrant will handle the port forwarding appropriately.

## Development

* Source hosted at [GitHub][repo]
* Report issues/questions/feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

Created by [Fletcher Nichol][author] (<fnichol@nichol.ca>)

## License

Apache 2.0 (see [LICENSE][license])

[author]:           https://github.com/test-kitchen
[issues]:           https://github.com/test-kitchen/kitchen-vagrant/issues
[license]:          https://github.com/test-kitchen/kitchen-vagrant/blob/master/LICENSE
[repo]:             https://github.com/test-kitchen/kitchen-vagrant
