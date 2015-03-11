# <a name="title"></a> Kitchen::Vagrant

[![Gem Version](https://badge.fury.io/rb/kitchen-vagrant.svg)](http://badge.fury.io/rb/kitchen-vagrant)
[![Build Status](https://secure.travis-ci.org/test-kitchen/kitchen-vagrant.svg?branch=master)](https://travis-ci.org/test-kitchen/kitchen-vagrant)
[![Code Climate](https://codeclimate.com/github/test-kitchen/kitchen-vagrant.svg)](https://codeclimate.com/github/test-kitchen/kitchen-vagrant)
[![Test Coverage](https://codeclimate.com/github/test-kitchen/kitchen-vagrant/coverage.svg)](https://codeclimate.com/github/test-kitchen/kitchen-vagrant)

A Test Kitchen Driver for Vagrant.

This driver works by generating a single Vagrantfile for each instance in a
sandboxed directory. Since the Vagrantfile is written out on disk, Vagrant
needs absolutely no knowledge of Test Kitchen. So no Vagrant plugins are
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
number of platforms (VirtualBox provider only) that have been published by
Opscode, such as:

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
  driver:
    box: chef/ubuntu-10.04
- name: ubuntu-12.04
  driver:
    box: chef/ubuntu-12.04
- name: ubuntu-12.10
  driver:
    box: chef/ubuntu-12.10
# ...
```

Many host wide defaults for Vagrant can be set using `$HOME/.vagrant.d/Vagrantfile`. See the [Vagrantfile documentation][vagrantfile] for more information.

## <a name="config"></a> Configuration

### <a name="config-box"></a> box

**Required** This determines which Vagrant box will be used. For more
details, please read the Vagrant [machine settings][vagrant_machine_settings]
page.

It is recommended to use a short name of a box on Vagrant Cloud and leave
box_url empty if your box is publically available.

The default will be computed from the platform name of the instance. For
example, a platform called "fuzzypants-9.000" will produce a default `box`
value of `"chef/fuzzypants-9.000"`.

### <a name="config-box-url"></a> box\_url

The URL that the configured box can be found at if not available on the
Vagrant Cloud or if on Vagrant < 1.5. If the box is not installed on the
system, it will be retrieved from this URL when the virtual machine is started.

### <a name="config-box-version"></a> box\_version

The [version][vagrant_versioning] of the configured box.

### <a name="config-box-check-update"></a> box\_check\_update

Whether to check for box updates (enabled by default).

### <a name="config-communicator"></a> communicator

For supporting communicating with Windows over WinRM.

For example:

```ruby
driver:
  communicator: "winrm"
```

will generate a Vagrantfile configuration similar to:

```ruby
  config.vm.communicator = "winrm"
```

The default is nil assuming ssh will be used.

### <a name="config-provider"></a> provider

This determines which Vagrant provider to use. The value should match
the provider name in Vagrant. For example, to use VMware Fusion the provider
should be `vmware_fusion`. Please see the docs on [providers][vagrant_providers]
for further details.

By default the value is unset, or `nil`. In this case the driver will use the
Vagrant [default provider][vagrant_default_provider] which at this current time
is `virtualbox` unless set by `VAGRANT_DEFAULT_PROVIDER` environment variable.

### <a name="config-customize"></a> customize

A **Hash** of customizations to a Vagrant virtual machine.  Each key/value
pair will be passed to your providers customization block. For example, with
the default `virtualbox` provider:

```ruby
driver:
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

Please read the "Customizations" sections for [VirtualBox][vagrant_config_vbox]
and [VMware][vagrant_config_vmware] for more details.

### <a name="config-gui"></a> GUI

Allows GUI mode for each defined platform. Default is **nil**. Value is passed
to the `config.vm.provider` but only for the VirtualBox and VMware-based
providers.

```ruby
platforms:
- name: ubuntu-14.04
  driver:
    gui: true
```

will generate a Vagrantfile configuration similar to:

```ruby
Vagrant.configure("2") do |config|
  # ...

  c.vm.provider :virtualbox do |p|
    p.gui = true
  end
end
```

For more info about GUI vs. Headless mode please see [vagrant configuration docs][vagrant_config_vbox]

### <a name="config-dry-run"></a> dry\_run

Useful when debugging Vagrant CLI commands. If set to `true`, all Vagrant CLI
commands will be displayed rather than executed.

The default is unset, or `nil`.

### <a name="config-guest"></a> guest

Set the `config.vm.guest` setting in the default Vagrantfile. For more details
please read the
[config.vm.guest](http://docs.vagrantup.com/v2/vagrantfile/machine_settings.html)
section of the Vagrant documentation.

The default is unset, or `nil`.

### <a name="config-network"></a> network

An **Array** of network customizations for the virtual machine. Each Array
element is itself an Array of arguments to be passed to the `config.vm.network`
method. For example:

```ruby
driver:
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

The default is an empty Array, `[]`.

### <a name="config-pre-create-command"></a> pre\_create\_command

An optional hook to run a command immediately prior to the
`vagrant up --no-provisioner` command being executed.

There is an optional token, `{{vagrant_root}}` that can be used in the
`pre_create_command` string which will be expanded by the driver to be the full
path to the sandboxed Vagrant root directory containing the Vagrantfile. This
command will be executed from the directory containing the .kitchen.yml file,
or the `kitchen_root`.

For example, if your project requires
[Bindler](https://github.com/fgrehm/bindler), this command could be:

```
pre_create_command: cp .vagrant_plugins.json {{vagrant_root}}/ && vagrant plugin bundle
```

The default is unset, or `nil`.

### <a name="config-synced-folders"></a> synced_folders

Allow the user to specify a collection of synced folders on each Vagrant
instance. Source paths can be relative to the kitchen root.

The default is an empty Array, or `[]`. The example:

```ruby
driver:
  synced_folders:
    - ["data/%{instance_name}", "/opt/instance_data"]
    - ["/host_path", "/vm_path", "create: true, type: :nfs"]
```

will generate a Vagrantfile configuration similar to:

```ruby
Vagrant.configure("2") do |config|
  # ...

  c.vm.synced_folder "/Users/mray/cookbooks/pxe_dust/data/default-ubuntu-1204", "/opt/instance_data"
  c.vm.synced_folder "/host_path", "/vm_path", create: true, type: :nfs
end
```

### <a name="config-username"></a> username

This is the username used for SSH authentication if you
would like to connect with a different account than Vagrant default user.

If this value is nil, then Vagrant parameter `config.ssh.default.username`
will be used (which is usually set to 'vagrant').

### <a name="config-vagrantfile-erb"></a> vagrantfile\_erb

An alternate Vagrantfile ERB template that will be rendered for use by this
driver. The binding context for the ERB processing is that of the Driver
object, which means that methods like `config[:kitchen_root]`, `instance.name`,
and `instance.provisioner[:run_list]` can be used to compose a custom
Vagrantfile if necessary.

**Warning:** Be cautious when going down this road as your setup may cease to
be portable or applicable to other Test Kitchen Drivers such as Ec2 or Docker.
Using the alternative Vagrantfile template strategy may be a dangerous
road--be aware.

The default is to use a template which ships with this gem.

### <a name="config-vm-hostname"></a> vm\_hostname

Sets the internal hostname for the instance. This is not used when connecting
to the Vagrant virtual machine.

For more details on this setting please read the
[config.vm.hostname](http://docs.vagrantup.com/v2/vagrantfile/machine_settings.html)
section of the Vagrant documentation.

To prevent this value from being rendered in the default Vagrantfile, you can
set this value to `false`.

The default will be computed from the name of the instance. For
example, the instance was called "default-fuzz-9" will produce a default
`vm_hostname` value of `"default-fuzz-9.vagrantup.com"`. For Windows-based
platforms, a default of `nil` is used to save on boot time and potential
rebooting.

### <a name="config-ssh-key"></a> ssh\_key

This is the path to the private key file used for SSH authentication if you
would like to use your own private ssh key instead of the default vagrant
insecure private key.

If this value is a relative path, then it will be expanded relative to the
location of the main Vagrantfile. If this value is nil, then the default
insecure private key that ships with Vagrant will be used.

The default value is unset, or `nil`.

### <a name="config-vagrantfiles"></a> vagrantfiles

An array of paths to other Vagrantfiles to be merged with the default one. The
paths can be absolute or relative to the .kitchen.yml file.

**Note:** the Vagrantfiles must have a .rb extension to satisfy Ruby's
Kernel#require.

```ruby
driver:
  vagrantfiles:
    - VagrantfileA.rb
    - /tmp/VagrantfileB.rb
```

### <a name="provision"></a> provision

Set to true if you want to do the provision of vagrant in create.
Usefull in case of you want to customize the OS in provision phase of vagrant

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
[driver_usage]:     http://kitchen.ci/docs/getting-started/adding-platform

[vagrant_dl]:               http://www.vagrantup.com/downloads.html
[vagrant_machine_settings]: http://docs.vagrantup.com/v2/vagrantfile/machine_settings.html
[vagrant_networking]:       http://docs.vagrantup.com/v2/networking/basic_usage.html
[virtualbox_dl]:            https://www.virtualbox.org/wiki/Downloads
[vagrantfile]:              http://docs.vagrantup.com/v2/vagrantfile/index.html
[vagrant_default_provider]: http://docs.vagrantup.com/v2/providers/default.html
[vagrant_config_vbox]:      http://docs.vagrantup.com/v2/virtualbox/configuration.html
[vagrant_config_vmware]:    http://docs.vagrantup.com/v2/vmware/configuration.html
[vagrant_providers]:        http://docs.vagrantup.com/v2/providers/index.html
[vagrant_versioning]:       https://docs.vagrantup.com/v2/boxes/versioning.html
[vagrant_wrapper]:          https://github.com/org-binbab/gem-vagrant-wrapper
[vagrant_wrapper_background]: https://github.com/org-binbab/gem-vagrant-wrapper#background---aka-the-vagrant-gem-enigma
[vmware_plugin]:            http://www.vagrantup.com/vmware
[fusion_dl]:                http://www.vmware.com/products/fusion/overview.html
[workstation_dl]:           http://www.vmware.com/products/workstation/
