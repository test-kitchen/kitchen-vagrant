# kitchen-vagrant

[![Gem Version](https://badge.fury.io/rb/kitchen-vagrant.svg)](http://badge.fury.io/rb/kitchen-vagrant)
[![CI](https://github.com/test-kitchen/kitchen-vagrant/actions/workflows/lint.yml/badge.svg)](https://github.com/test-kitchen/kitchen-vagrant/actions/workflows/lint.yml)

A [Test Kitchen](https://kitchen.ci/) driver for [HashiCorp Vagrant](https://www.vagrantup.com/). It creates and destroys local virtual machines, which makes it the usual choice for testing cookbooks on your own workstation.

The driver writes a self-contained `Vagrantfile` into a sandbox directory for each instance. Because everything Vagrant needs is in that file, Vagrant requires no knowledge of Test Kitchen and **no Vagrant plugins are required**.

> This documentation uses [Cinc Workstation](https://cinc.sh/) and the `cinc` commands throughout. Everything here works identically with Chef Workstation — see [Using with Chef](#using-with-chef).

## Requirements

- [Vagrant](https://developer.hashicorp.com/vagrant/downloads) 2.4 or later
- A Vagrant provider, most commonly [VirtualBox](https://www.virtualbox.org/). Others such as `hyperv`, `libvirt`, `vmware_desktop`, and `parallels` work too. VMware needs two extra pieces — see [Using the VMware provider](#using-the-vmware-provider).
- Ruby 3.1 or later (already satisfied if you use Cinc Workstation)

## Installation

This driver ships as part of [Cinc Workstation](https://cinc.sh/start/workstation/). If you have Cinc Workstation installed, there is nothing else to install.

To install it into a standalone Ruby:

```sh
gem install kitchen-vagrant
```

Or with Bundler, add it to your `Gemfile`:

```ruby
gem "kitchen-vagrant"
```

...then run `bundle install`.

## Quick Start

Vagrant is the default driver for Test Kitchen, so a minimal `kitchen.yml` is very short:

```yaml
---
driver:
  name: vagrant

provisioner:
  name: cinc_infra

verifier:
  name: cinc_auditor

platforms:
  - name: ubuntu-22.04
  - name: rockylinux-9

suites:
  - name: default
    run_list:
      - recipe[my_cookbook::default]
```

Then run the full test cycle:

```sh
cinc kitchen test
```

Or step through it:

```sh
cinc kitchen create    # vagrant up the box
cinc kitchen converge  # apply your cookbook
cinc kitchen verify    # run your tests
cinc kitchen destroy   # vagrant destroy the box
```

## How the box is chosen

If you do not set `box`, the driver derives one from the platform name. When the
platform matches a [Bento](https://github.com/chef/bento) box it uses
`bento/<platform>`, so a platform of `ubuntu-22.04` becomes `bento/ubuntu-22.04`.
Otherwise the platform name is used as the box name directly.

Set `box` explicitly whenever you want a box that is not published by Bento.

## Configuration

All options below are set under the `driver:` key in `kitchen.yml`, or per platform under `platforms[].driver:`.

### Box

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `box` | String | derived from the platform | Vagrant box to start from, e.g. `bento/ubuntu-22.04`. Required, but normally satisfied by the default. |
| `box_url` | String | *unset* | URL or path to the box, for boxes not published on Vagrant Cloud. |
| `box_version` | String | *latest* | Version constraint for the box. |
| `box_arch` | String | *provider default* | Architecture to request, e.g. `amd64` or `arm64`. Sets `config.vm.box_architecture`, and is passed to `vagrant box update` when `box_auto_update` is on. |
| `box_check_update` | Boolean | *Vagrant default* | Check for a newer version of the box on every `vagrant up`. |
| `box_auto_update` | Boolean | *unset* | Run `vagrant box update` before creating the instance. |
| `box_auto_prune` | Boolean | *unset* | Run `vagrant box prune` before creating the instance, removing outdated box versions. |
| `box_download_insecure` | Boolean | *unset* | Skip TLS verification when downloading the box. |
| `box_download_ca_cert` | String | *unset* | Path to a CA certificate used when downloading the box. Relative paths are resolved against the directory holding `kitchen.yml`. |

### Provider and machine

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `provider` | String | `$VAGRANT_DEFAULT_PROVIDER`, else `"virtualbox"` | Vagrant provider to use, e.g. `virtualbox`, `hyperv`, `libvirt`, `vmware_desktop`, `parallels`. |
| `customize` | Hash | `{}` | Provider-specific settings, such as `memory` and `cpus`. See [Customizing the machine](#customizing-the-machine). |
| `gui` | Boolean | *unset* | Boot the machine with a GUI console attached. Useful for watching a stuck boot. Honoured by `virtualbox` and `vmware_*`. |
| `linked_clone` | Boolean | *unset* | Create the machine as a linked clone, which is much faster and uses less disk. Honoured by `virtualbox`, `vmware_*`, `parallels`, and `hyperv`. |
| `guest` | String | *unset* | Overrides Vagrant's guest OS detection, e.g. `windows`. Sets `config.vm.guest`. |
| `vm_hostname` | String, false | `<instance>.vagrantup.com`, or unset on Windows | Hostname set inside the guest. Set to `false` to leave it alone. On Windows guests a name longer than 15 characters is truncated to fit the NetBIOS limit. |
| `boot_timeout` | Integer | *Vagrant default* | Seconds Vagrant waits for the machine to boot. |

### Guest access

These options configure how Vagrant itself logs into the guest, which is separate
from the Test Kitchen transport. You normally only need them for a box that does
not use the stock `vagrant` credentials, or for a Windows box.

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `communicator` | String | *Vagrant default* | Which communicator Vagrant uses, `ssh` or `winrm`. Sets `config.vm.communicator`. When set, `username` and `password` are applied to that communicator rather than to `ssh`. |
| `username` | String | *unset* | Username Vagrant logs in with, e.g. `c.ssh.username`. |
| `password` | String | *unset* | Password Vagrant logs in with, e.g. `c.ssh.password`. |
| `ssh_key` | String | *unset* | Path to a private key for Vagrant to authenticate with. Sets `config.ssh.private_key_path`. |
| `ssh` | Hash | `{}` | Any further `config.ssh.*` settings, such as `guest_port`, `insert_key`, or `forward_agent`. See [Custom SSH port](#custom-ssh-port). |
| `winrm` | Hash | `{}` | Any further `config.winrm.*` settings, such as `port` or `ssl_peer_verification`. See [Windows guests](#windows-guests). |

### Networking and folders

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `network` | Array | `[]` | Array of Vagrant network definitions, each an array of arguments to Vagrant's `config.vm.network`. |
| `synced_folders` | Array | `[]` | Array of `[source, destination, options]` entries mounted into the guest. Sources are resolved against the directory holding `kitchen.yml`, and `%{instance_name}` is substituted in both paths. |

### Vagrantfile generation

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `vagrantfile_erb` | String | the bundled template | Path to a custom ERB template used to render the Vagrantfile. |
| `vagrantfiles` | Array | `[]` | Array of extra Vagrantfiles `load`ed at the top of the generated one. |
| `provision` | Boolean | `false` | Let Vagrant run its own provisioners during `vagrant up`. |
| `pre_create_command` | String | *unset* | Shell command run from the kitchen root before the machine is created. `{{vagrant_root}}` is replaced with the instance's sandbox directory. |
| `env` | Array | `[]` | Environment variables to set **inside the guest**, each written as `NAME=value`. The driver adds a shell provisioner that appends them to `/etc/profile.d/kitchen.sh`, so they apply to Linux guests only. |
| `vagrant_binary` | String | `"vagrant"` | Path to the Vagrant executable. |

### Caching

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `cachier` | String | *unset* | Enable the `vagrant-cachier` plugin, if installed. Accepts a scope of `:box` or `:machine`; anything else falls back to `:box`. |
| `cache_directory` | String, false | `/tmp/omnibus/cache`, or `/omnibus/cache` on Windows | Directory inside the guest used to cache installer packages. Set to `false` to disable the shared cache. |
| `kitchen_cache_directory` | String | `~/.kitchen/cache` | Directory on the host holding the shared cache. Honours `VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH` for use under WSL. |
| `use_cached_chef_client` | Boolean | `false` | Share the cache even for a box the driver does not otherwise consider safe for synced folders. |

### Debugging

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `dry_run` | Boolean | `false` | Print the Vagrant commands instead of running them. |
| `use_sudo` | Boolean | *unset* | Run the local `vagrant` commands through sudo. |

## Customizing the machine

`customize` passes settings to the provider. The common keys work across
providers:

```yaml
driver:
  name: vagrant
  customize:
    memory: 4096
    cpus: 2
```

Anything else is passed to the provider's own customization mechanism. For
VirtualBox, keys become `VBoxManage modifyvm` arguments:

```yaml
driver:
  name: vagrant
  provider: virtualbox
  customize:
    memory: 2048
    cpus: 2
    natdnshostresolver1: "on"
    audio: "none"
```

## Custom SSH port

If the guest's SSH daemon listens on a non-standard port, tell the driver which
port it is and forward it:

```yaml
driver:
  name: vagrant
  ssh:
    guest_port: 444
  network:
    - ["forwarded_port", {guest: 444, host: 2222, auto_correct: true}]
```

This tells Vagrant the SSH daemon inside the guest listens on 444 rather than
22, and Vagrant sets up the forwarding accordingly.

## Windows guests

A Windows box needs Vagrant pointed at WinRM rather than SSH, and Test Kitchen
needs its own WinRM transport. The two are configured separately: `communicator`
and `winrm` are what Vagrant uses to bring the box up, and `transport` is what
Test Kitchen uses afterwards.

```yaml
driver:
  name: vagrant
  communicator: winrm
  username: vagrant
  password: vagrant
  winrm:
    port: 5985
    ssl_peer_verification: false

transport:
  name: winrm

platforms:
  - name: windows-2022
    driver:
      box: my-org/windows-2022
```

Two behaviours are worth knowing about:

- `vm_hostname` defaults to unset on Windows platforms, and a hostname you set
  yourself is truncated to 15 characters to fit the NetBIOS limit.
- `env` writes to `/etc/profile.d/kitchen.sh` and therefore does nothing on a
  Windows guest.

## Examples

### Pinning a box and version

```yaml
driver:
  name: vagrant
  box: bento/ubuntu-22.04
  box_version: "202309.08.0"
  box_check_update: false
```

### A box hosted somewhere other than Vagrant Cloud

```yaml
driver:
  name: vagrant
  box: my-custom-box
  box_url: https://boxes.example.com/my-custom-box.box
```

### Faster local runs

Linked clones avoid copying the whole disk image for every instance, and pruning
keeps old box versions from filling the disk.

```yaml
driver:
  name: vagrant
  linked_clone: true
  box_auto_prune: true
```

### Private network and a synced folder

```yaml
driver:
  name: vagrant
  network:
    - ["private_network", {ip: "192.168.56.10"}]
  synced_folders:
    - ["test/fixtures", "/tmp/fixtures", {create: true}]
```

### A provider other than VirtualBox

```yaml
driver:
  name: vagrant
  provider: libvirt
  customize:
    memory: 4096
    cpus: 4
```

### Per-platform overrides

```yaml
driver:
  name: vagrant
  customize:
    memory: 2048

platforms:
  - name: ubuntu-22.04
  - name: windows-2022
    driver:
      box: my-org/windows-2022
      customize:
        memory: 4096
```

### Extending the generated Vagrantfile

```yaml
driver:
  name: vagrant
  vagrantfiles:
    - test/fixtures/Vagrantfile.extra
```

## Using the VMware provider

VMware is the most practical provider on Apple Silicon Macs, where VirtualBox
cannot run the x86 boxes most platforms publish. Unlike VirtualBox, it needs
three pieces beyond Vagrant itself:

1. **[VMware Fusion](https://www.vmware.com/products/desktop-hypervisor.html)**
   (macOS) or **VMware Workstation** (Linux, Windows).
2. **The Vagrant VMware Utility**, a privileged local service Vagrant talks to
   over `https://127.0.0.1:9922`. Installing it requires `sudo`, because it
   registers a system service.
3. **The `vagrant-vmware-desktop` plugin**, which is what actually exposes the
   `vmware_desktop` provider to Vagrant.

On macOS:

```sh
brew install --cask vagrant vagrant-vmware-utility
vagrant plugin install vagrant-vmware-desktop
```

On other platforms, download the utility from
[HashiCorp](https://developer.hashicorp.com/vagrant/docs/providers/vmware/vagrant-vmware-utility)
and then install the plugin the same way.

Then select the provider, either in `kitchen.yml`:

```yaml
driver:
  name: vagrant
  provider: vmware_desktop
```

...or through the environment, which the driver reads as its default:

```sh
export VAGRANT_DEFAULT_PROVIDER=vmware_desktop
```

### Box architecture

Vagrant Cloud boxes are published per architecture. On an Apple Silicon Mac,
Vagrant selects `arm64` automatically, but not every box publishes an `arm64`
build for every provider — Bento does, while many community boxes are `amd64`
only. Use `box_arch` to ask for a specific one:

```yaml
driver:
  name: vagrant
  provider: vmware_desktop
  box_arch: arm64
```

## Troubleshooting

**The box cannot be found.** The default box is derived from the platform name,
so a platform Bento does not publish will produce a box name that does not
exist. Set `box`, and `box_url` if it is not on Vagrant Cloud.

**The machine boots but Test Kitchen cannot connect.** Watch the boot with
`gui: true`, and raise `boot_timeout` if it is simply slow.

**VMware fails with a connection or "utility" error.** The Vagrant VMware
Utility is a separate service from the plugin. Confirm it is installed and
listening with `nc -z 127.0.0.1 9922`, and see
[Using the VMware provider](#using-the-vmware-provider).

**VMware reports that the box has no matching provider or architecture.** The
box does not publish a build for your architecture — this is common for
`arm64` on Apple Silicon. Check the box on Vagrant Cloud, and set `box_arch`
or pick a different box.

**You want to see what Vagrant is being asked to do.** Set `dry_run: true` to
print the commands instead of running them, and look at the generated
Vagrantfile in the instance's sandbox directory.

## Using with Chef

This driver is not tied to Cinc. The examples above use Cinc Workstation and the `cinc_infra` provisioner, but the driver works exactly the same with [Chef Workstation](https://www.chef.io/downloads/tools/workstation) — run `kitchen` instead of `cinc kitchen`, and use `chef_infra` instead of `cinc_infra`:

```yaml
provisioner:
  name: chef_infra

verifier:
  name: inspec
```

No driver configuration changes are needed.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/test-kitchen/kitchen-vagrant). See [CONTRIBUTING.md](CONTRIBUTING.md) for development setup, how to run the tests, how to generate the documentation, and the release process.

## Authors

Created by [Fletcher Nichol](https://github.com/fnichol) (<fnichol@nichol.ca>).

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](https://github.com/test-kitchen/kitchen-vagrant/blob/main/LICENSE) for details.
