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

If you are creating Windows VMs over a WinRM Transport, then the
[vagrant-winrm][vagrant_winrm] Vagrant plugin must be installed. As a
consequence, the minimum version of Vagrant required is 1.6 or higher.

### <a name="dependencies-virtualization"></a> Virtualization Hypervisor(s)

Currently this driver supports Parallels, VirtualBox, and VMware Fusion/Workstation
hypervisors. VirtualBox is free and is the default provider for Vagrant.

[VirtualBox package][virtualbox_dl]

If you would like to use VMware Fusion/Workstation you must purchase the
software from VMware and then must also purchase the Vagrant VMware plugin.

[Vagrant VMware Plugin][vmware_plugin]

[VMware Fusion][fusion_dl]

[VMware Workstation][workstation_dl]

If you would like to use Parallels Desktop you must also purchase the software but the
`vagrant-parallels` plugin is freely available.

[Parallels Desktop for Mac][parallels_dl]

[Vagrant Parallels Provider][vagrant_parallels]


## <a name="installation"></a> Installation and Setup

Please read the [Driver usage][driver_usage] page for more details.

## <a name="default-config"></a> Default Configuration

For a select number of platforms and a select number of hypervisors (VirtualBox, VMware,
and Parallels) default boxes are published under the [Bento organization][bento_org]
on [Atlas][atlas] such as:

```yaml
---
platforms:
  - name: ubuntu-16.04
  - name: centos-7.3
  - name: freebsd-11
```

This will effectively generate a configuration similar to:

```yaml
---
platforms:
  - name: ubuntu-16.04
    driver:
      box: bento/ubuntu-16.04
  - name: centos-7.3
    driver:
      box: bento/centos-7.3
  - name: freebsd-11.0
    driver:
      box: bento/freebsd-11.0
  # ...
```

Any other platform names will set a more reasonable default for `box` and leave `box_url` unset. For example:

```yaml
---
platforms:
  - name: slackware-14.1
  - name: openbsd-5.6
  - name: windows-2012r2
```

This will effectively generate a configuration similar to:

```yaml
---
platforms:
  - name: slackware-14.1
    driver:
      box: slackware-14.1
  - name: openbsd-5.6
    driver:
      box: openbsd-5.6
  - name: windows-2012r2
    driver:
      box: windows-2012r2
```

Many host wide defaults for Vagrant can be set using `$HOME/.vagrant.d/Vagrantfile`. See the [Vagrantfile documentation][vagrantfile] for more information.

## <a name="config"></a> Configuration

### <a name="config-cachier"></a> cachier

Enable and configure scope for [vagrant-cachier][vagrant_cachier] plugin.
Valid options are `:box` or `:machine`, setting to a truthy value yields `:box`

For example:

```yaml
---
driver:
  cachier: true
```

will generate a Vagrantfile configuration similar to:

```ruby
  config.cache.scope = :box
```

The default is `nil`, indicating unset.


### <a name="config-box"></a> box

**Required** This determines which Vagrant box will be used. For more
details, please read the Vagrant [machine settings][vagrant_machine_settings]
page.

The default will be computed from the platform name of the instance. However, 
for a number of common platforms in the [Bento][bento] project, the default will 
prefix the name with `bento/` in accordance with Atlas naming standards.

For example, a platform with name `ubuntu-16.04` will produce a
default `box` value of `bento/ubuntu-16.04`. Alternatively, a box called
`slackware-14.1` will produce a default `box` value of `slackware-14.1`.

### <a name="config-box-check-update"></a> box\_check\_update

Whether to check for box updates (enabled by default).

### <a name="config-box-url"></a> box\_url

A box_url is not required when using the Atlas format of 
`bento/ubuntu-16.04` assuming the organization and box referenced
exist. If using a custom box this can be an `https://` or `file://`
URL.

### <a name="config-box-download-ca-cert"></a> box\_download\_ca\_cert

Path relative to the `.kitchen.yml` file for locating the trusted CA bundle.
Useful when combined with `box_url`.

The default is `nil`, indicating to use the default Mozilla CA cert bundle.
See also `box_download_insecure`.

### <a name="config-box-download-insecure"></a> box\_download\_insecure

If true, then SSL certificates from the server will
not be verified.

The default is `false`, meaning if the URL is an HTTPS URL,
then SSL certs will be verified.

### <a name="config-box-version"></a> box\_version

The [version][vagrant_versioning] of the configured box. 

The default is `nil`, indicating unset.

This option is only relevant when used with Atlas boxes which support versioning.

### <a name="config-communicator"></a> communicator

**Note:** It should largely be the responsibility of the underlying Vagrant
base box to properly set the `config.vm.communicator` value. For example, if
the base box is a Windows operating system and does not have an SSH service
installed and enabled, then Vagrant will be unable to even boot it (using
`vagrant up`), without a custom Vagrantfile. If you are authoring a base box,
please take care to set your value for communicator to give your users the best
possible out-of-the-box experience.

For overriding the default communicator setting of the base box.

For example:

```yaml
---
driver:
  communicator: ssh
```

will generate a Vagrantfile configuration similar to:

```ruby
  config.vm.communicator = "ssh"
```

The default is `nil` assuming ssh will be used.

### <a name="config-customize"></a> customize

A **Hash** of customizations to a Vagrant virtual machine.  Each key/value
pair will be passed to your providers customization block. For example, with
the default `virtualbox` provider:

```yaml
---
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

#### <a name="config-customize-virtualbox-disk"></a> VirtualBox additional disk

Adding the `createhd` and `storageattach` keys in `customize` allows for creation
of an additional disk in VirtualBox. Full paths must be used as required by VirtualBox.

*NOTE*: IDE Controller based drives always show up in the boot order first, regardless of if they
are [bootable][vbox_ide_boot].

```yaml
driver:
  customize:
    createhd:
      filename: /tmp/disk1.vmdk
      size: 1024
    storageattach:
      storagectl: SATA Controller
      port: 1
      device: 0
      type: hdd
      medium: /tmp/disk1.vmdk
```

will generate a Vagrantfile configuration similar to:

```ruby
Vagrant.configure("2") do |config|
  # ...

  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.customize ["createhd", "--filename", "./tmp/disk1.vmdk", "--size", 1024]
    virtualbox.customize ["storageattach", :id, "--storagectl", "IDE Controller", "--port", "1", "--device", 0, "--type", "hdd", "--medium", "./tmp/disk1.vmdk"]
  end
end
```

Please read [createhd](https://www.virtualbox.org/manual/ch08.html#vboxmanage-createvdi)
and [storageattach](https://www.virtualbox.org/manual/ch08.html#vboxmanage-storageattach)
for additional information on these options.

### <a name="config-guest"></a> guest

**Note:** It should largely be the responsibility of the underlying Vagrant
base box to properly set the `config.vm.guest` value. For example, if the base
box is a Windows operating system, then Vagrant will be unable to even boot it
(using `vagrant up`), without a custom Vagrantfile. If you are authoring a base
box, please take care to set your value for communicator to give your users the
best possible out-of-the-box experience.

For overriding the default guest setting of the base box.

The default is unset, or `nil`.

### <a name="config-gui"></a> gui

Allows GUI mode for each defined platform. Default is **nil**. Value is passed
to the `config.vm.provider` but only for the VirtualBox and VMware-based
providers.

```yaml
---
platforms:
  - name: ubuntu-16.04
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

### <a name="config-linked_clone"></a> linked_clone

Allows to use linked clones to import boxes for VirtualBox, VMware and Parallels Desktop. Default is **nil**.

```yaml
---
platforms:
  - name: ubuntu-16.04
    driver:
      linked_clone: true
```

will generate a Vagrantfile configuration similar to:

```ruby
Vagrant.configure("2") do |config|
  # ...

  c.vm.provider :virtualbox do |p|
    p.linked_clone = true
  end
end
```

### <a name="config-network"></a> network

An **Array** of network customizations for the virtual machine. Each Array
element is itself an Array of arguments to be passed to the `config.vm.network`
method. For example:

```yaml
---
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

```yaml
---
driver
  pre_create_command: cp .vagrant_plugins.json {{vagrant_root}}/ && vagrant plugin bundle
```

The default is unset, or `nil`.

### <a name="config-provider"></a> provider

This determines which Vagrant provider to use. The value should match
the provider name in Vagrant. For example, to use VMware Fusion the provider
should be `vmware_fusion`. Please see the docs on [providers][vagrant_providers]
for further details.

By default the value is unset, or `nil`. In this case the driver will use the
Vagrant [default provider][vagrant_default_provider] which at this current time
is `virtualbox` unless set by `VAGRANT_DEFAULT_PROVIDER` environment variable.

### <a name="provision"></a> provision

Set to true if you want to do the provision of vagrant in create.
Useful in case of you want to customize the OS in provision phase of vagrant

### <a name="config-ssh-key"></a> ssh\_key

This is the path to the private key file used for SSH authentication if you
would like to use your own private ssh key instead of the default vagrant
insecure private key.

If this value is a relative path, then it will be expanded relative to the
location of the main Vagrantfile. If this value is nil, then the default
insecure private key that ships with Vagrant will be used.

The default value is unset, or `nil`.

### <a name="config-synced-folders"></a> synced_folders

Allow the user to specify a collection of synced folders on each Vagrant
instance. Source paths can be relative to the kitchen root.

The default is an empty Array, or `[]`. The example:

```yaml
---
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

### <a name="config-cache_directory"></a> cache_directory

Customize the cache directory on the Vagrant instance. This parameter must be an
absolute path.

The defaults are:
* Windows: `C:\\omnibus\\cache`
* Unix: `/tmp/omnibus/cache`

The example:

```yaml
---
driver:
  cache_directory: Z:\\custom\\cache
```

### <a name="config-kitchen_cache_directory"></a> kitchen_cache_directory

Customize the kitchen cache directory on the system running Test Kitchen. This parameter must be an
absolute path.

The defaults are:
* Windows: `~/.kitchen/cache`
* Unix: `~/.kitchen/cache`

The example:

```yaml
---
driver:
  kitchen_cache_directory: Z:\\custom\\kitchen_cache
```

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

### <a name="config-vagrantfiles"></a> vagrantfiles

An array of paths to other Vagrantfiles to be merged with the default one. The
paths can be absolute or relative to the .kitchen.yml file.

**Note:** the Vagrantfiles must have a .rb extension to satisfy Ruby's
Kernel#require.

```yaml
---
driver:
  vagrantfiles:
    - VagrantfileA.rb
    - /tmp/VagrantfileB.rb
```

### <a name="config-vm-hostname"></a> vm\_hostname

Sets the internal hostname for the instance. This is not used when connecting
to the Vagrant virtual machine.

For more details on this setting please read the
[config.vm.hostname](http://docs.vagrantup.com/v2/vagrantfile/machine_settings.html)
section of the Vagrant documentation.

To prevent this value from being rendered in the default Vagrantfile, you can
set this value to `false`.

The default will be computed from the name of the instance. For example, the
instance was called "default-fuzz-9" will produce a default `vm_hostname` value
of `"default-fuzz-9"`. For Windows-based platforms, a default of `nil` is used
to save on boot time and potential rebooting.

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
[driver_usage]:     http://kitchen.ci/docs/getting-started/adding-platform

[bento]:                    https://github.com/chef/bento
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
[vagrant_winrm]:            https://github.com/criteo/vagrant-winrm
[vagrant_wrapper]:          https://github.com/org-binbab/gem-vagrant-wrapper
[vagrant_wrapper_background]: https://github.com/org-binbab/gem-vagrant-wrapper#background---aka-the-vagrant-gem-enigma
[vmware_plugin]:            http://www.vagrantup.com/vmware
[fusion_dl]:                http://www.vmware.com/products/fusion/overview.html
[workstation_dl]:           http://www.vmware.com/products/workstation/
[bento_org]:                https://atlas.hashicorp.com/bento
[atlas]:                    https://atlas.hashicorp.com/
[parallels_dl]:             http://www.parallels.com/products/desktop/download/
[vagrant_parallels]:        https://github.com/Parallels/vagrant-parallels
[vagrant_cachier]:          https://github.com/fgrehm/vagrant-cachier
[vbox_ide_boot]:            https://www.virtualbox.org/ticket/6979
