# <a name="title"></a> Kitchen::Vagrant

[![Gem Version](https://badge.fury.io/rb/kitchen-vagrant.svg)](http://badge.fury.io/rb/kitchen-vagrant)
![CI](https://github.com/test-kitchen/kitchen-vagrant/workflows/CI/badge.svg?branch=master)

A Test Kitchen Driver for Vagrant.

This driver works by generating a single Vagrantfile for each instance in a
sandboxed directory. Since the Vagrantfile is written out on disk, Vagrant
needs absolutely no knowledge of Test Kitchen. So no Vagrant plugins are
required.

## <a name="requirements"></a> Requirements

### <a name="dependencies-vagrant"></a> Vagrant

A Vagrant version of 1.6 or later.

## <a name="installation"></a> Installation

The kitchen-vagrant driver ships as part of Chef Workstation. The easiest way to use this driver is to [Download Chef Workstation](https://www.chef.io/downloads/tools/workstation).

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

## <a name="development"></a> Development

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

## <a name="authors"></a> Authors

Created by [Fletcher Nichol][author] (<fnichol@nichol.ca>)

## <a name="license"></a> License

Apache 2.0 (see [LICENSE][license])


[author]:           https://github.com/test-kitchen
[issues]:           https://github.com/test-kitchen/kitchen-vagrant/issues
[license]:          https://github.com/test-kitchen/kitchen-vagrant/blob/master/LICENSE
[repo]:             https://github.com/test-kitchen/kitchen-vagrant
