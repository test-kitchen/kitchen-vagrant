# <a name="title"></a> Kitchen::Vagrant

[![Build Status](https://travis-ci.org/opscode/kitchen-vagrant.png)](https://travis-ci.org/opscode/kitchen-vagrant)
[![Code Climate](https://codeclimate.com/github/opscode/kitchen-vagrant.png)](https://codeclimate.com/github/opscode/kitchen-vagrant)

A Test Kitchen Driver for Vagrant.

This driver works by generating a single Vagrantfile for each instance in a
sandboxed directory. Since the Vagrantfile is written out on disk, Vagrant
needs absolutely no knowledge of Test Kitchen. So no Vagrant plugin gem is
required.

## <a name="requirements"></a> Requirements

### <a name="dependencies-vagrant"></a> Vagrant

A Vagrant version of 1.1.0 or higher is required for this driver which means
that a [native package][vagrant_dl] must be installed on the system running
Test Kitchen.

**Note:** If you have previously installed Vagrant as a gem (a version prior
to 1.1.0), this version may be resolved first in your `PATH`. If you receive an
error message that Vagrant is too old despite having installed Vagrant as a
package, you may be required to uninstall the gem version or modify your `PATH`
environment.

### <a name="dependencies-virtualbox"></a> Virtualbox

Currently this driver only supports the VirtualBox provisioner which requires
the [VirtualBox package][virtualbox_dl] to be installed.

### <a name="dependencies-berkshelf"></a> Vagrant Berkshelf Plugin

If a Berksfile is present in your project's root directory, then this driver
will check to ensure that the [vagrant-berkshelf][vagrant_berkshelf] plugin is
installed.

If your project doesn't use Berkshelf then this check will be skipped.

**Note:** Prior to release 1.2.0, then name of the vagrant-berkshelf gem was
berkshelf-vagrant. This driver no longer checks for the existance of
berkshelf-vagrant, so upgrading this Vagrant plugin is recommended.

## <a name="installation"></a> Installation and Setup

Please read the [Driver usage][driver_usage] page for more details.

## <a name="config"></a> Configuration

### <a name="config-box"></a> box

(**Required**) This determines which Vagrant box will be used. For more
details, please read the Vagrant [machine settings][vagrant_machine_settings]
page.

There is **no** default value set.

### <a name="config-box-url"></a> box\_url

The URL that the configured box can be found at. If the box is not installed on
the system, it will be retrieved from this URL when the virtual machine is
started.

There is **no** default value set.

### <a name="config-customize"></a> customize

A **Hash** of customizations to a Vagrant virtual machine backed by VirtualBox.
Each key/value pair will be passed to the `virtualbox.customize` method. For
example:

```ruby
driver_config:
  customize:
    memory: 1024
    cpuexecutioncap: 50
```

will generate a Vagrantfile configuration similar to:

```ruby
Vagrant.configure("2") do |config|
  # ...

  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.customize ["modifyvm", :id, "--memory", "1024"]
    virtualbox.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end
end
```

Please read the Vagrant [VirtualBox configuration][vagrant_virtualbox] page for
more details.

By default, each Vagrant virtual machine is configured with 256 MB of RAM. In
other words the default value for `customize` is `{:memory => '256'}`.

### <a name="config-dry-run"></a> dry\_run

Useful when debugging Vagrant CLI commands. If set to `true`, all Vagrant CLI commands
will be displayed rather than executed.

The default is unset, or `nil`.

### <a name="config-network"></a> network

An **Array** of network customizations for the virtual machine. Each Array
element is itself an Array of arguments to be passed to the `config.vm.netork`
method. For example:

```ruby
driver_config:
  network:
  - ["forwarded_port", {guest: 80, host: 8080}]
  - ["private_network", {ip: "192.168.33.33"}]
```

will generate a Vagrantfile configuration similar to:

```ruby
Vagrant.configure("2") do |config|
  # ...

  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :private_network, ip: "192.168.33.33"
end
```

Please read the Vagrant [networking basic usage][vagrant_networking] page for
more details.

There is **no** default value set.

### <a name="config-require-chef-omnibus"></a> require\_chef\_omnibus

Determines whether or not a Chef [Omnibus package][chef_omnibus_dl] will be
installed. There are several different behaviors available:

* `true` - the latest release will be installed. Subsequent converges
  will skip re-installing if chef is present.
* `latest` - the latest release will be installed. Subsequent converges
  will always re-install even if chef is present.
* `<VERSION_STRING>` (ex: `10.24.0`) - the desired version string will
  be passed the the install.sh script. Subsequent converges will skip if
  the installed version and the desired version match.
* `false` or `nil` - no chef is installed.

The default value is unset, or `nil`.

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

Created and maintained by [Fletcher Nichol][author] (<fnichol@nichol.ca>)

## <a name="license"></a> License

Apache 2.0 (see [LICENSE][license])


[author]:           https://github.com/opscode
[issues]:           https://github.com/opscode/kitchen-vagrant/issues
[license]:          https://github.com/opscode/kitchen-vagrant/blob/master/LICENSE
[repo]:             https://github.com/opscode/kitchen-vagrant
[driver_usage]:     http://docs.kitchen-ci.org/drivers/usage
[chef_omnibus_dl]:  http://www.opscode.com/chef/install/

[vagrant_berkshelf]:        http://rubygems.org/gems/vagrant-berkshelf
[vagrant_dl]:               http://downloads.vagrantup.com/
[vagrant_machine_settings]: http://docs.vagrantup.com/v2/vagrantfile/machine_settings.html
[vagrant_networking]:       http://docs.vagrantup.com/v2/networking/basic_usage.html
[vagrant_virtualbox]:       http://docs.vagrantup.com/v2/virtualbox/configuration.html
[virtualbox_dl]:            https://www.virtualbox.org/wiki/Downloads
