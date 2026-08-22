#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

RSpec.describe "the rendered Vagrantfile" do
  include_context "renders a Vagrantfile"

  let(:kitchen_root_name) { File.basename(config[:kitchen_root]) }

  describe "the top of the file" do
    it "requires no extra Vagrantfiles by default" do
      expect(vagrantfile).not_to include("load ")
    end

    it "loads each entry in :vagrantfiles" do
      config[:vagrantfiles] = %w{/a /b /c}

      expect(vagrantfile).to declare(<<~RUBY.chomp)
        load "/a"
        load "/b"
        load "/c"
      RUBY
    end

    it "opens a version 2 configure block" do
      expect(vagrantfile).to declare(%{Vagrant.configure("2") do |c|})
    end

    it "disables vagrant-berkshelf, which would otherwise fight with Kitchen" do
      expect(vagrantfile).to declare(
        %{c.berkshelf.enabled = false if Vagrant.has_plugin?("vagrant-berkshelf")}
      )
    end
  end

  describe "vagrant-cachier" do
    it "is not configured by default" do
      expect(vagrantfile).not_to include("c.cache.scope")
    end

    it "defaults to :box scope when :cachier is merely enabled" do
      config[:cachier] = true

      expect(vagrantfile).to declare(%{c.cache.scope = :box})
    end

    it "honours an explicit :machine scope" do
      config[:cachier] = ":machine"

      expect(vagrantfile).to declare(%{c.cache.scope = :machine})
    end

    it "falls back to :box for an unrecognised scope rather than emitting invalid Ruby" do
      config[:cachier] = ":bogus"

      expect(vagrantfile).to declare(%{c.cache.scope = :box})
    end
  end

  describe "box selection" do
    it "sets vm.box" do
      expect(vagrantfile).to declare(%{c.vm.box = "fooos-99"})
    end

    it "omits vm.box_url when unset" do
      expect(vagrantfile).not_to include("c.vm.box_url")
    end

    it "sets vm.box_url when given" do
      config[:box_url] = "dat.url"

      expect(vagrantfile).to declare(%{c.vm.box_url = "dat.url"})
    end

    it "omits vm.box_version when unset" do
      expect(vagrantfile).not_to include("c.vm.box_version")
    end

    it "sets vm.box_version when given" do
      config[:box_version] = "a.b.c"

      expect(vagrantfile).to declare(%{c.vm.box_version = "a.b.c"})
    end

    it "omits vm.box_architecture when unset" do
      expect(vagrantfile).not_to include("c.vm.box_architecture")
    end

    it "sets vm.box_architecture when :box_arch is given" do
      config[:box_arch] = "arm64"

      expect(vagrantfile).to declare(%{c.vm.box_architecture = "arm64"})
    end

    it "omits vm.box_check_update when unset" do
      expect(vagrantfile).not_to include("c.vm.box_check_update")
    end

    it "sets vm.box_check_update to false when disabled" do
      config[:box_check_update] = false

      expect(vagrantfile).to declare(%{c.vm.box_check_update = false})
    end

    it "sets vm.box_check_update to true when enabled" do
      config[:box_check_update] = true

      expect(vagrantfile).to declare(%{c.vm.box_check_update = true})
    end

    it "omits vm.box_download_ca_cert when unset" do
      expect(vagrantfile).not_to include("c.vm.box_download_ca_cert")
    end

    it "sets vm.box_download_ca_cert, expanded against the kitchen root" do
      config[:box_download_ca_cert] = "certs/ca.pem"

      expect(vagrantfile).to declare(%{c.vm.box_download_ca_cert = "/kroot/certs/ca.pem"})
    end

    it "omits vm.box_download_insecure when unset" do
      expect(vagrantfile).not_to include("c.vm.box_download_insecure")
    end

    it "sets vm.box_download_insecure when given" do
      config[:box_download_insecure] = "um"

      expect(vagrantfile).to declare(%{c.vm.box_download_insecure = "um"})
    end

    it "renders an explicit false for :box_download_insecure" do
      config[:box_download_insecure] = false

      expect(vagrantfile).to declare(%{c.vm.box_download_insecure = "false"})
    end
  end

  describe "guest identity" do
    it "sets vm.hostname" do
      config[:vm_hostname] = "charlie"

      expect(vagrantfile).to declare(%{c.vm.hostname = "charlie"})
    end

    it "omits vm.hostname when explicitly disabled" do
      config[:vm_hostname] = nil

      expect(vagrantfile).not_to include("c.vm.hostname")
    end

    it "omits vm.communicator when unset" do
      expect(vagrantfile).not_to include("c.vm.communicator")
    end

    it "sets vm.communicator when given" do
      config[:communicator] = "wat"

      expect(vagrantfile).to declare(%{c.vm.communicator = "wat"})
    end

    it "omits vm.guest when unset" do
      expect(vagrantfile).not_to include("c.vm.guest")
    end

    it "sets vm.guest when given" do
      config[:guest] = "mac"

      expect(vagrantfile).to declare(%{c.vm.guest = "mac"})
    end

    it "omits vm.boot_timeout when unset" do
      expect(vagrantfile).not_to include("c.vm.boot_timeout")
    end

    it "sets vm.boot_timeout when given" do
      config[:boot_timeout] = 600

      expect(vagrantfile).to declare(%{c.vm.boot_timeout = 600})
    end
  end

  describe "credentials" do
    it "omits ssh.username when unset" do
      expect(vagrantfile).not_to include("c.ssh.username")
    end

    it "sets ssh.username when given" do
      config[:username] = "jdoe"

      expect(vagrantfile).to declare(%{c.ssh.username = "jdoe"})
    end

    it "omits ssh.password when unset" do
      expect(vagrantfile).not_to include("c.ssh.password")
    end

    it "sets ssh.password when given" do
      config[:password] = "okay"

      expect(vagrantfile).to declare(%{c.ssh.password = "okay"})
    end

    it "routes the username to the configured communicator instead of ssh" do
      config[:communicator] = "wat"
      config[:username] = "jdoe"

      expect(vagrantfile).to declare(%{c.wat.username = "jdoe"})
      expect(vagrantfile).not_to include("c.ssh.username")
    end

    it "routes the password to the configured communicator instead of ssh" do
      config[:communicator] = "wat"
      config[:password] = "okay"

      expect(vagrantfile).to declare(%{c.wat.password = "okay"})
      expect(vagrantfile).not_to include("c.ssh.password")
    end

    it "omits ssh.private_key_path when unset" do
      expect(vagrantfile).not_to include("c.ssh.private_key_path")
    end

    it "sets ssh.private_key_path when :ssh_key is given" do
      config[:ssh_key] = "okay"

      expect(vagrantfile).to declare(%{c.ssh.private_key_path = "okay"})
    end

    it "emits a c.ssh line per key in the :ssh hash, quoting only what needs it" do
      config[:ssh] = {
        username: "jdoe",
        password: "secret",
        private_key_path: "/key",
        insert_key: false,
      }

      expect(vagrantfile).to declare(<<~RUBY.chomp)
        c.ssh.username = "jdoe"
        c.ssh.password = "secret"
        c.ssh.private_key_path = "/key"
        c.ssh.insert_key = false
      RUBY
    end

    it "leaves numeric ssh options unquoted" do
      config[:ssh] = { guest_port: 444 }

      expect(vagrantfile).to declare(%{c.ssh.guest_port = 444})
    end

    it "renders true for a boolean ssh option" do
      config[:ssh] = { forward_agent: true }

      expect(vagrantfile).to declare(%{c.ssh.forward_agent = true})
    end

    it "omits winrm settings when unset" do
      expect(vagrantfile).not_to include("c.winrm.")
    end

    it "emits a c.winrm line per key in the :winrm hash" do
      config[:winrm] = { username: "vagrant", port: 5985, ssl_peer_verification: false }

      expect(vagrantfile).to declare(<<~RUBY.chomp)
        c.winrm.username = "vagrant"
        c.winrm.port = 5985
        c.winrm.ssl_peer_verification = false
      RUBY
    end
  end

  describe "networking" do
    it "declares no networks by default" do
      expect(vagrantfile).not_to include("c.vm.network")
    end

    it "declares one network per entry, expanding hash options into keywords" do
      config[:network] = [
        ["forwarded_port", { guest: 80, host: 8080 }],
        ["private_network", { ip: "192.168.33.33" }],
      ]

      expect(vagrantfile).to declare(<<~RUBY.chomp)
        c.vm.network(:forwarded_port, guest: 80, host: 8080)
        c.vm.network(:private_network, ip: "192.168.33.33")
      RUBY
    end

    # `finalize_network!` pushes a pre-formatted String for the Hyper-V default
    # switch, so the template has to cope with both shapes.
    it "accepts pre-formatted String options as well as a Hash" do
      config[:network] = [["public_network", %{bridge: "Default Switch"}]]

      expect(vagrantfile).to declare(%{c.vm.network(:public_network, bridge: "Default Switch")})
    end
  end

  describe "synced folders" do
    it "disables the implicit /vagrant share, which Kitchen does not want" do
      expect(vagrantfile).to declare(%{c.vm.synced_folder ".", "/vagrant", disabled: true})
    end

    it "declares one synced_folder per entry" do
      config[:synced_folders] = [
        ["/a/b", "/opt/instance_data", "nil"],
        ["/host_path", "/vm_path", "create: true, type: :nfs"],
      ]

      expect(vagrantfile).to declare(<<~RUBY.chomp)
        c.vm.synced_folder "/a/b", "/opt/instance_data", nil
        c.vm.synced_folder "/host_path", "/vm_path", create: true, type: :nfs
      RUBY
    end

    it "escapes backslashes in a Windows guest path so the Vagrantfile stays valid Ruby" do
      config[:synced_folders] = [["/a/b", "C:\\opt\\instance_data", "nil"]]

      expect(vagrantfile).to declare(<<~'RUBY'.chomp)
        c.vm.synced_folder "/a/b", "C:\\opt\\instance_data", nil
      RUBY
    end

    # `File.expand_path` only understands drive letters on a Windows host, so
    # this is host-dependent by nature -- the guest path, which is never
    # expanded, is what the template has to get right in both cases.
    it "leaves a Windows host path recognisable" do
      config[:synced_folders] = [["Z:\\host_path", "/vm_path", "create: true"]]

      expect(vagrantfile).to include(%{Z:\\\\host_path", "/vm_path", create: true})
    end
  end

  describe "environment variables" do
    it "provisions nothing by default" do
      expect(vagrantfile).not_to include(%{c.vm.provision "shell"})
    end

    it "writes each :env entry into a profile.d script" do
      config[:env] = ["AWS_REGION=us-east-1", "AWS_ACCESS_KEY_ID=test123"]

      expect(vagrantfile).to include(%{echo 'export AWS_REGION=us-east-1' >> /etc/profile.d/kitchen.sh})
      expect(vagrantfile).to include(%{echo 'export AWS_ACCESS_KEY_ID=test123' >> /etc/profile.d/kitchen.sh})
    end

    it "makes the profile.d script executable exactly once" do
      config[:env] = ["FOO=bar"]

      expect(vagrantfile).to declare(
        %{c.vm.provision "shell", inline: "chmod +x /etc/profile.d/kitchen.sh", run: "once"}
      )
    end

    it "escapes single quotes so a value cannot break out of the shell literal" do
      config[:env] = ["TEST_VAR=value'with'quotes"]

      expect(vagrantfile).to include(%{echo 'export TEST_VAR=value'\\''with'\\''quotes'})
    end
  end

  describe "provider blocks" do
    it "emits an empty block for a provider with nothing to configure" do
      config[:provider] = "wowza"

      expect(vagrantfile).to declare(<<~RUBY.chomp)
        c.vm.provider :wowza do |p|
        end
      RUBY
    end

    describe "virtualbox" do
      before { config[:provider] = "virtualbox" }

      it "names the VM uniquely so parallel kitchen runs cannot collide" do
        expect(vagrantfile).to match(
          /p\.name = "kitchen-#{Regexp.escape(kitchen_root_name)}-suitey-fooos-99-\h{8}-\h{4}-\h{4}-\h{4}-\h{12}"/
        )
      end

      it "disables audio, which is a common source of hangs on CI" do
        expect(vagrantfile).to include(%{p.customize ["modifyvm", :id, "--audio", "none"]})
      end

      it "lets :customize override the audio default rather than emitting both" do
        config[:customize] = { audio: "pulse" }

        expect(vagrantfile).to include(%{p.customize ["modifyvm", :id, "--audio", "pulse"]})
        expect(vagrantfile).not_to include(%{p.customize ["modifyvm", :id, "--audio", "none"]})
      end

      it "turns each :customize key into a modifyvm flag" do
        config[:customize] = { a_key: "some value", something: "else" }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.customize ["modifyvm", :id, "--audio", "none"]
          p.customize ["modifyvm", :id, "--a_key", "some value"]
          p.customize ["modifyvm", :id, "--something", "else"]
        RUBY
      end

      it "omits p.gui when unset" do
        expect(vagrantfile).not_to include("p.gui")
      end

      it "sets p.gui to false" do
        config[:gui] = false

        expect(vagrantfile).to declare(%{p.gui = false})
      end

      it "sets p.gui to true" do
        config[:gui] = true

        expect(vagrantfile).to declare(%{p.gui = true})
      end

      it "omits p.linked_clone when unset" do
        expect(vagrantfile).not_to include("p.linked_clone")
      end

      it "sets p.linked_clone to false" do
        config[:linked_clone] = false

        expect(vagrantfile).to declare(%{p.linked_clone = false})
      end

      it "sets p.linked_clone to true" do
        config[:linked_clone] = true

        expect(vagrantfile).to declare(%{p.linked_clone = true})
      end

      it "guards a single createhd so a re-run does not fail on an existing disk" do
        config[:customize] = { createhd: { filename: "./d1.vmdk", size: 10 * 1024 } }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          unless File.file?("./d1.vmdk")
          p.customize ["createhd", "--filename", "./d1.vmdk", "--size", 10240]
          end
        RUBY
      end

      it "guards each of several createhd entries" do
        config[:customize] = {
          createhd: [
            { filename: "./d1.vmdk", size: 10 * 1024 },
            { filename: "./d2.vmdk", size: 20 * 1024 },
          ],
        }

        expect(vagrantfile).to include(%{p.customize ["createhd", "--filename", "./d1.vmdk", "--size", 10240]})
        expect(vagrantfile).to include(%{p.customize ["createhd", "--filename", "./d2.vmdk", "--size", 20480]})
      end

      it "renders a single storagectl, leaving integers unquoted" do
        config[:customize] = {
          storagectl: {
            name: "Custom SATA Controller", add: "sata",
            controller: "IntelAHCI", portcount: 4
          },
        }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.customize ["storagectl", :id, "--name", "Custom SATA Controller", "--add", "sata", "--controller", "IntelAHCI", "--portcount", 4]
        RUBY
      end

      it "renders several storagectl entries" do
        config[:customize] = {
          storagectl: [
            { name: "Custom SATA Controller", add: "sata", controller: "IntelAHCI" },
            { name: "Custom SATA Controller", portcount: 4 },
          ],
        }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.customize ["storagectl", :id, "--name", "Custom SATA Controller", "--add", "sata", "--controller", "IntelAHCI"]
          p.customize ["storagectl", :id, "--name", "Custom SATA Controller", "--portcount", 4]
        RUBY
      end

      it "renders a single storageattach" do
        config[:customize] = { storageattach: { type: "hdd", port: 1 } }

        expect(vagrantfile).to declare(%{p.customize ["storageattach", :id, "--type", "hdd", "--port", 1]})
      end

      it "renders several storageattach entries" do
        config[:customize] = {
          storageattach: [
            { storagectl: "SATA Controller", port: 1, device: 0, type: "hdd", medium: "./d1.vmdk" },
            { storagectl: "SATA Controller", port: 1, device: 1, type: "hdd", medium: "./d2.vmdk" },
          ],
        }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1, "--device", 0, "--type", "hdd", "--medium", "./d1.vmdk"]
          p.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1, "--device", 1, "--type", "hdd", "--medium", "./d2.vmdk"]
        RUBY
      end

      it "renders cpuidset as a flat quoted list" do
        config[:customize] = { cpuidset: %w{00000001 00000002} }

        expect(vagrantfile).to declare(%{p.customize ["modifyvm", :id, "--cpuidset", "00000001", "00000002"]})
      end

      it "quotes only string values in setextradata" do
        config[:customize] = {
          setextradata: {
            "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC": 0,
            "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion": "1.0",
          },
        }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.customize ["setextradata", :id, "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC", 0]
          p.customize ["setextradata", :id, "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion", "1.0"]
        RUBY
      end
    end

    describe "tart" do
      before { config[:provider] = "tart" }

      # Tart rejects the long UUID-suffixed names that virtualbox is given.
      it "names the VM without a UUID suffix" do
        expect(vagrantfile).to declare(<<~RUBY.chomp)
          c.vm.provider :tart do |p|
          p.name = "kitchen-#{kitchen_root_name}-suitey-fooos-99"
          end
        RUBY
      end
    end

    describe "hyperv" do
      before { config[:provider] = "hyperv" }

      let(:switch) { "Default Switch" }

      before do
        allow_any_instance_of(Kitchen::Driver::Vagrant) # rubocop:disable RSpec/AnyInstance
          .to receive(:hyperv_switch).and_return(switch)
      end

      it "bridges onto the discovered default switch when no network is configured" do
        expect(vagrantfile).to declare(%{c.vm.network(:public_network, bridge: "Default Switch")})
      end

      it "names the VM within Hyper-V's 100 character limit" do
        vmname = vagrantfile[/p\.vmname = "([^"]*)"/, 1]

        expect(vmname.length).to be <= 100
        expect(vmname).to start_with("kitchen-#{kitchen_root_name}-suitey-fooos-99-")
      end

      it "does not leave a trailing hyphen when the name is truncated" do
        config[:kitchen_root] = "/#{"x" * 120}"

        expect(vagrantfile[/p\.vmname = "([^"]*)"/, 1]).not_to end_with("-")
      end

      it "sets p.linked_clone when requested" do
        config[:linked_clone] = true

        expect(vagrantfile).to declare(%{p.linked_clone = true})
      end

      it "leaves a user-supplied network alone" do
        config[:network] = [["private_network", { ip: "192.168.33.33" }]]

        expect(vagrantfile).to declare(%{c.vm.network(:private_network, ip: "192.168.33.33")})
        expect(vagrantfile).not_to include("public_network")
      end
    end

    describe "parallels" do
      before { config[:provider] = "parallels" }

      it "turns each :customize key into a prlctl set flag with dashed names" do
        config[:customize] = { a_key: "some value", something: "else" }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.customize ["set", :id, "--a-key", "some value"]
          p.customize ["set", :id, "--something", "else"]
        RUBY
      end

      it "uses the short form for :memory and :cpus" do
        config[:customize] = { memory: 2048, cpus: 4 }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.memory = 2048
          p.cpus = 4
        RUBY
      end

      it "omits p.linked_clone when unset" do
        expect(vagrantfile).not_to include("p.linked_clone")
      end

      it "sets p.linked_clone to false" do
        config[:linked_clone] = false

        expect(vagrantfile).to declare(%{p.linked_clone = false})
      end

      it "sets p.linked_clone to true" do
        config[:linked_clone] = true

        expect(vagrantfile).to declare(%{p.linked_clone = true})
      end
    end

    describe "rackspace" do
      before { config[:provider] = "rackspace" }

      it "assigns each :customize key directly on the provider" do
        config[:customize] = { a_key: "some value", something: "else" }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.a_key = "some value"
          p.something = "else"
        RUBY
      end
    end

    describe "softlayer" do
      before { config[:provider] = "softlayer" }

      it "renders :disk_capacity as a hash literal" do
        config[:customize] = { disk_capacity: { "0": 25, "2": 100 } }

        expect(vagrantfile).to declare(%{p.disk_capacity = {"0": 25, "2": 100}})
      end

      it "renders a scalar :disk_capacity without braces" do
        config[:customize] = { disk_capacity: 100 }

        expect(vagrantfile).to declare(%{p.disk_capacity = 100})
      end

      it "quotes all other :customize values" do
        config[:customize] = { a_key: "some value", something: "else" }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.a_key = "some value"
          p.something = "else"
        RUBY
      end
    end

    describe "libvirt" do
      before { config[:provider] = "libvirt" }

      it "quotes strings and leaves numbers bare" do
        config[:customize] = { a_key: "some value", something: "else", a_number_key: 1024 }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.a_key = "some value"
          p.something = "else"
          p.a_number_key = 1024
        RUBY
      end

      it "renders a single :storage definition as a method call, not an assignment" do
        config[:customize] = { storage: ":file, :size => '32G'" }

        expect(vagrantfile).to declare(%{p.storage :file, :size => '32G'})
      end

      it "renders one call per :storage definition" do
        config[:customize] = {
          storage: [
            ":file, :size => '1G'",
            ":file, :size => '128G', :bus => 'sata'",
            ":file, :size => '64G', :bus => 'sata'",
          ],
        }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.storage :file, :size => '1G'
          p.storage :file, :size => '128G', :bus => 'sata'
          p.storage :file, :size => '64G', :bus => 'sata'
        RUBY
      end
    end

    describe "lxc" do
      before { config[:provider] = "lxc" }

      it "passes :machine through as a symbol" do
        config[:customize] = { container_name: ":machine" }

        expect(vagrantfile).to declare(%{p.container_name = :machine})
      end

      it "quotes any other container name" do
        config[:customize] = { container_name: "beans" }

        expect(vagrantfile).to declare(%{p.container_name = "beans"})
      end

      it "sets the backing store" do
        config[:customize] = { backingstore: "lvm" }

        expect(vagrantfile).to declare(%{p.backingstore = "lvm"})
      end

      it "emits one backingstore_option call per option" do
        config[:customize] = { backingstore_options: { vgname: "schroots", fstype: "xfs" } }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.backingstore_option "--vgname", "schroots"
          p.backingstore_option "--fstype", "xfs"
        RUBY
      end

      it "emits one customize call per :include entry" do
        config[:customize] = { include: %w{/a.conf /b.conf} }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.customize "include", "/a.conf"
          p.customize "include", "/b.conf"
        RUBY
      end

      it "falls back to customize for anything else" do
        config[:customize] = { cookies: "cream", salt: "vinegar" }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.customize "cookies", "cream"
          p.customize "salt", "vinegar"
        RUBY
      end
    end

    describe "vmware_*" do
      before { config[:provider] = "vmware_desktop" }

      it "omits p.gui when unset" do
        expect(vagrantfile).not_to include("p.gui")
      end

      it "sets p.gui to false" do
        config[:gui] = false

        expect(vagrantfile).to declare(%{p.gui = false})
      end

      it "sets p.gui to true" do
        config[:gui] = true

        expect(vagrantfile).to declare(%{p.gui = true})
      end

      it "sets p.linked_clone" do
        config[:linked_clone] = true

        expect(vagrantfile).to declare(%{p.linked_clone = true})
      end

      it "routes :customize keys into the vmx hash" do
        config[:customize] = { a_key: "some value", something: "else" }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.vmx["a_key"] = "some value"
          p.vmx["something"] = "else"
        RUBY
      end

      it "translates :memory to the vmx memsize key" do
        config[:customize] = { memory: "222" }

        expect(vagrantfile).to declare(%{p.vmx["memsize"] = "222"})
      end

      it "lets an explicit :memsize win over :memory" do
        config[:customize] = { memory: "222", memsize: "444" }

        expect(vagrantfile).to declare(%{p.vmx["memsize"] = "444"})
        expect(vagrantfile).not_to include(%{p.vmx["memsize"] = "222"})
      end

      it "translates :cpus to the vmx numvcpus key" do
        config[:customize] = { cpus: "2" }

        expect(vagrantfile).to declare(%{p.vmx["numvcpus"] = "2"})
      end

      it "lets an explicit :numvcpus win over :cpus" do
        config[:customize] = { cpus: "2", numvcpus: "4" }

        expect(vagrantfile).to declare(%{p.vmx["numvcpus"] = "4"})
        expect(vagrantfile).not_to include(%{p.vmx["numvcpus"] = "2"})
      end
    end

    describe "managed" do
      before { config[:provider] = "managed" }

      it "sets the server" do
        config[:customize] = { server: "my_server" }

        expect(vagrantfile).to declare(%{p.server = "my_server"})
      end

      it "ignores every key other than :server" do
        config[:customize] = { other: "stuff", is: "ignored" }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          c.vm.provider :managed do |p|
          end
        RUBY
      end
    end

    describe "openstack" do
      before { config[:provider] = "openstack" }

      it "renders strings, numbers and booleans with their native syntax" do
        config[:customize] = { key1: "some string value", key2: 22, key3: false }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.key1 = "some string value"
          p.key2 = 22
          p.key3 = false
        RUBY
      end
    end

    describe "cloudstack" do
      before { config[:provider] = "cloudstack" }

      it "renders plain values" do
        config[:customize] = { a_key: "some value", something: "else" }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.a_key = "some value"
          p.something = "else"
        RUBY
      end

      it "renders an array of hashes for firewall rules" do
        config[:customize] = {
          firewall_rules: [
            { ipaddress: "A.A.A.A", cidrlist: "B.B.B.B/24", protocol: "tcp", startport: 2222, endport: 2222 },
            { ipaddress: "C.C.C.C", cidrlist: "D.D.D.D/32", protocol: "tcp", startport: 80, endport: 81 },
          ],
        }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.firewall_rules = [{ipaddress: "A.A.A.A", cidrlist: "B.B.B.B/24", protocol: "tcp", startport: 2222, endport: 2222}, {ipaddress: "C.C.C.C", cidrlist: "D.D.D.D/32", protocol: "tcp", startport: 80, endport: 81}]
        RUBY
      end

      it "renders a plain array of strings" do
        config[:customize] = { security_group_ids: %w{aaaa-bbbb 1111-2222} }

        expect(vagrantfile).to declare(%{p.security_group_ids = ["aaaa-bbbb", "1111-2222"]})
      end

      it "renders nested arrays of hashes" do
        config[:customize] = {
          security_groups: [
            {
              name: "Awesome_security_group",
              description: "Created from the Vagrantfile",
              rules: [
                { type: "ingress", protocol: "TCP", startport: 22, endport: 22, cidrlist: "0.0.0.0/0" },
              ],
            },
          ],
        }

        expect(vagrantfile).to declare(<<~RUBY.chomp)
          p.security_groups = [{name: "Awesome_security_group", description: "Created from the Vagrantfile", rules: [{type: "ingress", protocol: "TCP", startport: 22, endport: 22, cidrlist: "0.0.0.0/0"}]}]
        RUBY
      end

      it "renders a single-element array of hashes" do
        config[:customize] = { static_nat: [{ idaddress: "A.A.A.A" }] }

        expect(vagrantfile).to declare(%{p.static_nat = [{idaddress: "A.A.A.A"}]})
      end
    end
  end

  describe "as a whole" do
    it "is syntactically valid Ruby" do
      config[:provider] = "virtualbox"
      config[:customize] = { memory: 1024, createhd: { filename: "./d.vmdk", size: 100 } }
      config[:network] = [["forwarded_port", { guest: 80, host: 8080 }]]
      config[:synced_folders] = [["/a", "/b", "create: true"]]
      config[:ssh] = { insert_key: false }
      config[:env] = ["FOO=bar"]

      expect { RubyVM::AbstractSyntaxTree.parse(vagrantfile) }.not_to raise_error
    end

    it "collapses the blank lines the ERb conditionals leave behind" do
      expect(vagrantfile).not_to match(/^\s*$\n/)
    end
  end
end
