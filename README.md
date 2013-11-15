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
environment. If you require the vagrant gem for older projects you should
consider the [vagrant-wrapper][vagrant_wrapper] gem which helps manage both
styles of Vagrant installations
([background details][vagrant_wrapper_background]).

### <a name="dependencies-virtualization"></a> Virtualbox and/or VMware Fusion/Workstation

Currently this driver supports VirtualBox and VMware Fusion/Workstation.
Virtualbox is free and is the default provider for Vagrant.

[VirtualBox package][virtualbox_dl]

If you would like to use VMware Fusion/Workstation you must purchase the
software from VMware and then must also purchase the Vagrant VMware plugin.

[Vagrant VMware Plugin][vmware_plugin]

[VMware Fusion][fusion_dl]

[VMware Workstation][workstation_dl]


## <a name="installation"></a> Installation and Setup

Please read the [Driver usage][driver_usage] page for more details.

## <a name="default-config"></a> Default Configuration

This driver can predict the Vagrant box name and download URL for a select
number of platforms that have been published by Opscode, such as:

```ruby
---
platforms:
- name: ubuntu-10.04
- name: ubuntu-12.04
- name: ubuntu-12.10
- name: ubuntu-13.04
- name: centos-5.9
- name: centos-6.4
- name: debian-7.1.0
```

This will effectively generate a configuration similar to:

```ruby
---
platforms:
- name: ubuntu-10.04
  driver_config:
    box: opscode-ubuntu-10.04
    box_url: https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-10.04_provisionerless.box
- name: ubuntu-12.04
  driver_config:
    box: opscode-ubuntu-12.04
    box_url: https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box
- name: ubuntu-12.10
  driver_config:
    box: opscode-ubuntu-12.10
    box_url: ...
# ...
```

## <a name="config"></a> Configuration

### <a name="config-box"></a> box

**Required** This determines which Vagrant box will be used. For more
details, please read the Vagrant [machine settings][vagrant_machine_settings]
page.

There is **no** default value set.

### <a name="config-box-url"></a> box\_url

The URL that the configured box can be found at. If the box is not installed on
the system, it will be retrieved from this URL when the virtual machine is
started.

There is **no** default value set.

### <a name="config-provider"></a> provider

This determines which Vagrant provider to use when testing and should match
the provider name in Vagrant. For example, to use VMware Fusion the provider
should be `vmware_fusion`. Please see the docs on [providers][vagrant_providers]
for further details.

By default the value is unset, or `nil`. In this case the driver will use the
Vagrant default provider which at this current time is **virtualbox**

### <a name="config-customize"></a> customize

A **Hash** of customizations to a Vagrant virtual machine.  Each key/value
pair will be passed to your providers customization block. For example, with
the default `virtualbox` provider:

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

Please read the [Vagrantfile configuration][vagrantfile] page for
more details.

By default, each Vagrant virtual machine is configured with 256 MB of RAM. In
other words the default value for `customize` is `{:memory => '256'}`.

### <a name="config-dry-run"></a> dry\_run

Useful when debugging Vagrant CLI commands. If set to `true`, all Vagrant CLI
commands will be displayed rather than executed.

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

### <a name="config-use-vagrant-provision"></a> use_vagrant_provision

Determines whether or not this driver will use a `vagrant provision` shell out
in the **converge** action. If this value is falsey (`nil`, `false`) the
behavior from `Kitchen::Driver::SSHBase` will be used, bypassing the Vagrant
Chef solo provisioner. If this value is truthy, a `vagrant provision` will
be used.

The default is unset, or `nil`.

### <a name="config-synced-folders"></a> synced_folders

Allow the user to specify a collection of synced folders for on each Vagrant
instance.

The default is an empty Array, or `[]`. The example:

```ruby
driver_config:
  synced_folders: [["/Users/mray/ws/cookbooks/pxe_dust/.kitchen/kitchen-vagrant/opt/chef", "/opt/chef"],
                   ["/host_path", "/vm_path", "create: true, disabled: false"]]
```

will generate a Vagrantfile configuration similar to:

```ruby
Vagrant.configure("2") do |config|
  # ...

  c.vm.synced_folder "/Users/mray/ws/cookbooks/pxe_dust/.kitchen/kitchen-vagrant/opt/chef", "/opt/chef"
  c.vm.synced_folder "/host_path", "/vm_path", create: true, disabled: false
end
```

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

### <a name="config-username"></a> username

This is the username used for SSH authentication if you
would like to connect with a different account than Vagrant default user.

If this value is nil, then Vagrant parameter `config.ssh.default.username`
will be used (which is usually set to 'vagrant').

### <a name="config-ssh-key"></a> ssh\_key

This is the path to the private key file used for SSH authentication if you
would like to use your own private ssh key instead of the default vagrant
insecure private key.

If this value is a relative path, then it will be expanded relative to the
location of the main Vagrantfile. If this value is nil, then the default
insecure private key that ships with Vagrant will be used.

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

[vagrant_dl]:               http://downloads.vagrantup.com/
[vagrant_machine_settings]: http://docs.vagrantup.com/v2/vagrantfile/machine_settings.html
[vagrant_networking]:       http://docs.vagrantup.com/v2/networking/basic_usage.html
[virtualbox_dl]:            https://www.virtualbox.org/wiki/Downloads
[vagrantfile]:              http://docs.vagrantup.com/v2/vagrantfile/index.html
[vagrant_providers]:        http://docs.vagrantup.com/v2/providers/index.html
[vagrant_wrapper]:          https://github.com/org-binbab/gem-vagrant-wrapper
[vagrant_wrapper_background]: https://github.com/org-binbab/gem-vagrant-wrapper#background---aka-the-vagrant-gem-enigma
[vmware_plugin]:            http://www.vagrantup.com/vmware
[fusion_dl]:                http://www.vmware.com/products/fusion/overview.html
[workstation_dl]:           http://www.vmware.com/products/workstation/
