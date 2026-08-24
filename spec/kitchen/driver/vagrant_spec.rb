#
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
#
# Copyright (C) 2015, Fletcher Nichol
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

require "tmpdir" unless defined?(Dir.mktmpdir)

RSpec.describe Kitchen::Driver::Vagrant do
  include_context "vagrant driver"

  describe "plugin metadata" do
    it "declares driver API version 2" do
      expect(driver.diagnose_plugin[:api_version]).to eq(2)
    end

    it "reports the gem version as its plugin version" do
      expect(driver.diagnose_plugin[:version]).to eq(Kitchen::Driver::VAGRANT_VERSION)
    end

    it "refuses to create or destroy in parallel, since Vagrant serialises anyway" do
      expect(described_class.serial_actions).to include(:create, :destroy)
    end
  end

  describe "#default_box" do
    %w{
      almalinux amazonlinux centos debian fedora freebsd hardenedbsd opensuse
      oracle oraclelinux rockylinux springdalelinux ubuntu
    }.each do |name|
      it "maps the #{name} platform onto a bento box" do
        allow(platform).to receive(:name).and_return("#{name}-99.04")

        expect(driver[:box]).to eq("bento/#{name}-99.04")
      end
    end

    it "uses the platform name verbatim when no bento box could exist" do
      allow(platform).to receive(:name).and_return("slackware-14.1")

      expect(driver[:box]).to eq("slackware-14.1")
    end

    it "requires the platform name to carry a version suffix to count as bento" do
      allow(platform).to receive(:name).and_return("ubuntu")

      expect(driver[:box]).to eq("ubuntu")
    end

    it "never overrides an explicit :box" do
      allow(platform).to receive(:name).and_return("ubuntu-24.04")
      config[:box] = "booya"

      expect(driver[:box]).to eq("booya")
    end
  end

  describe "#default_box_url" do
    it "is nil, because modern Vagrant resolves boxes through Vagrant Cloud" do
      expect(driver[:box_url]).to be_nil
    end
  end

  describe "configuration defaults" do
    {
      box_check_update: nil,
      box_download_ca_cert: nil,
      box_download_insecure: nil,
      box_version: nil,
      box_arch: nil,
      boot_timeout: nil,
      customize: {},
      gui: nil,
      linked_clone: nil,
      network: [],
      pre_create_command: nil,
      provision: false,
      ssh: {},
      env: [],
      use_cached_chef_client: false,
      vagrant_binary: "vagrant",
      vagrantfiles: [],
      cachier: nil,
    }.each do |key, value|
      it "defaults :#{key} to #{value.inspect}" do
        expect(driver[key]).to eq(value)
      end
    end

    it "defaults :provider to virtualbox" do
      expect(driver[:provider]).to eq("virtualbox")
    end

    it "honours VAGRANT_DEFAULT_PROVIDER from the environment" do
      env["VAGRANT_DEFAULT_PROVIDER"] = "vcool"

      expect(driver[:provider]).to eq("vcool")
    end

    it "lets an explicit :provider beat the environment" do
      env["VAGRANT_DEFAULT_PROVIDER"] = "vcool"
      config[:provider] = "mything"

      expect(driver[:provider]).to eq("mything")
    end

    it "ships a Vagrantfile template" do
      expect(driver[:vagrantfile_erb]).to match(%r{/templates/Vagrantfile\.erb$})
      expect(File).to exist(driver[:vagrantfile_erb])
    end

    it "expands a relative :vagrantfile_erb against the kitchen root" do
      config[:vagrantfile_erb] = "Yep.erb"

      expect(driver[:vagrantfile_erb]).to eq(File.expand_path("/kroot/Yep.erb"))
    end

    it "expands every entry in :vagrantfiles against the kitchen root" do
      config[:vagrantfiles] = %w{one two three}

      expect(driver[:vagrantfiles])
        .to eq(%w{/kroot/one /kroot/two /kroot/three}.map { |f| File.expand_path(f) })
    end
  end

  # `default_config` stores one object per key on the *class*, so any finalize
  # step that mutates a collection default in place corrupts every other
  # instance in the process -- including ones built afterwards.
  describe "isolation between driver instances" do
    def build_driver(overrides = {})
      d = described_class.new({ kitchen_root: "/kroot" }.merge(overrides))
      Kitchen::Instance.new(
        verifier: Kitchen::Verifier::Dummy.new,
        driver: d,
        logger: logger,
        suite: Kitchen::Suite.new(name: "suitey"),
        platform: Kitchen::Platform.new(name: "fooos-99"),
        provisioner: Kitchen::Provisioner::Dummy.new,
        lifecycle_hooks: Kitchen::LifecycleHooks.new({}, {}),
        transport: Kitchen::Transport::Dummy.new,
        state_file: instance_double(Kitchen::StateFile)
      )
      d
    end

    before do
      allow_any_instance_of(described_class) # rubocop:disable RSpec/AnyInstance
        .to receive(:hyperv_switch).and_return("Default Switch")
    end

    it "does not leak a hyperv default network into other instances" do
      build_driver(provider: "hyperv")

      expect(build_driver[:network]).to eq([])
    end

    it "does not leak a hyperv default network into instances built earlier" do
      other = build_driver
      build_driver(provider: "hyperv")

      expect(other[:network]).to eq([])
    end

    it "still configures the hyperv instance itself" do
      hyperv = build_driver(provider: "hyperv")

      expect(hyperv[:network]).to eq([["public_network", %{bridge: "Default Switch"}]])
    end
  end

  describe "#finalize_network!" do
    before do
      allow(driver_object).to receive(:hyperv_switch).and_return("Default Switch")
    end

    it "bridges hyperv onto the discovered default switch" do
      config[:provider] = "hyperv"

      expect(driver[:network]).to eq([["public_network", %{bridge: "Default Switch"}]])
    end

    it "leaves a user-supplied hyperv network alone" do
      config[:provider] = "hyperv"
      config[:network] = [["private_network", { ip: "192.168.33.33" }]]

      expect(driver[:network]).to eq([["private_network", { ip: "192.168.33.33" }]])
    end

    it "adds nothing for other providers" do
      config[:provider] = "virtualbox"

      expect(driver[:network]).to eq([])
    end
  end

  describe "#finalize_ca_cert!" do
    it "leaves an unset cert alone" do
      expect(driver[:box_download_ca_cert]).to be_nil
    end

    it "expands a relative cert path against the kitchen root" do
      config[:box_download_ca_cert] = "cacert.pem"

      expect(driver[:box_download_ca_cert]).to eq("/kroot/cacert.pem")
    end

    it "leaves an absolute cert path alone" do
      config[:box_download_ca_cert] = "/etc/ssl/ca.pem"

      expect(driver[:box_download_ca_cert]).to eq("/etc/ssl/ca.pem")
    end
  end

  describe "#finalize_pre_create_command!" do
    it "leaves an unset command alone" do
      expect(driver[:pre_create_command]).to be_nil
    end

    it "passes a plain command straight through" do
      config[:pre_create_command] = "execute yo"

      expect(driver[:pre_create_command]).to eq("execute yo")
    end

    it "substitutes {{vagrant_root}}" do
      config[:pre_create_command] = "{{vagrant_root}}/candy"

      expect(driver[:pre_create_command])
        .to eq("/kroot/.kitchen/kitchen-vagrant/suitey-fooos-99/candy")
    end
  end

  describe "#finalize_box_auto_update!" do
    it "leaves :box_auto_update unset when the user said nothing" do
      expect(driver[:box_auto_update]).to be_nil
    end

    it "builds an update command when enabled" do
      config[:box_auto_update] = true

      expect(driver[:box_auto_update])
        .to eq("vagrant box update --box fooos-99 --provider virtualbox")
    end

    it "includes the architecture when :box_arch is set" do
      config[:box_auto_update] = true
      config[:box_arch] = "arm64"

      expect(driver[:box_auto_update])
        .to eq("vagrant box update --box fooos-99 --architecture arm64 --provider virtualbox")
    end

    it "passes --insecure through" do
      config[:box_auto_update] = true
      config[:box_download_insecure] = true

      expect(driver[:box_auto_update]).to end_with(" --insecure")
    end

    it "uses the configured vagrant binary" do
      config[:box_auto_update] = true
      config[:vagrant_binary] = "vagrant.cmd"

      expect(driver[:box_auto_update]).to start_with("vagrant.cmd box update ")
    end

    it "lets vagrant pick the provider when :provider is explicitly cleared" do
      config[:box_auto_update] = true
      config[:provider] = nil

      expect(driver[:box_auto_update]).to eq("vagrant box update --box fooos-99")
    end

    it "stays disabled when the user explicitly said false" do
      config[:box_auto_update] = false

      expect(driver[:box_auto_update]).to be(false)
    end
  end

  describe "#finalize_box_auto_prune!" do
    it "leaves :box_auto_prune unset when the user said nothing" do
      expect(driver[:box_auto_prune]).to be_nil
    end

    it "builds a prune command that keeps boxes still in use" do
      config[:box_auto_prune] = true

      expect(driver[:box_auto_prune]).to eq(
        "vagrant box prune --force --keep-active-boxes --name fooos-99 --provider virtualbox"
      )
    end

    it "lets vagrant pick the provider when :provider is explicitly cleared" do
      config[:box_auto_prune] = true
      config[:provider] = nil

      expect(driver[:box_auto_prune])
        .to eq("vagrant box prune --force --keep-active-boxes --name fooos-99")
    end

    it "stays disabled when the user explicitly said false" do
      config[:box_auto_prune] = false

      expect(driver[:box_auto_prune]).to be(false)
    end
  end

  describe "#finalize_vm_hostname!" do
    context "on a unix guest" do
      before { allow(platform).to receive(:os_type).and_return("unix") }

      it "derives a hostname from the instance name" do
        expect(driver[:vm_hostname]).to eq("suitey-fooos-99.vagrantup.com")
      end

      it "leaves a custom hostname alone, however long" do
        config[:vm_hostname] = "a-really-quite-long-hostname"

        expect(driver[:vm_hostname]).to eq("a-really-quite-long-hostname")
      end
    end

    context "on a windows guest" do
      before { allow(platform).to receive(:os_type).and_return("windows") }

      it "sets no hostname by default, because renaming reboots Windows" do
        expect(driver[:vm_hostname]).to be_nil
      end

      it "leaves a NetBIOS-legal hostname alone" do
        config[:vm_hostname] = "short-name"

        expect(driver[:vm_hostname]).to eq("short-name")
      end

      it "truncates an over-long hostname, keeping the last character for uniqueness" do
        config[:vm_hostname] = "this-is-a-pretty-long-name-ya-think"

        expect(driver[:vm_hostname]).to eq("this-is-a-pr-k")
      end

      it "keeps the truncated hostname within the 15 character NetBIOS limit" do
        config[:vm_hostname] = "x" * 64

        expect(driver[:vm_hostname].length).to be <= 15
      end
    end
  end

  describe "#finalize_synced_folders!" do
    let(:cache_share) do
      [File.expand_path("~/.kitchen/cache"), "/tmp/omnibus/cache", "create: true"]
    end

    it "shares nothing by default, because fooos-99 is not a known-safe box" do
      expect(driver[:synced_folders]).to eq([])
    end

    it "expands a relative source against the kitchen root" do
      config[:synced_folders] = [["./a", "/vm_path", "stuff"]]

      expect(driver[:synced_folders]).to eq([[File.expand_path("/kroot/a"), "/vm_path", "stuff"]])
    end

    it "substitutes %{instance_name} in both source and destination" do
      config[:synced_folders] = [["/root/%{instance_name}", "/vm/%{instance_name}", "stuff"]]

      expect(driver[:synced_folders])
        .to eq([[File.expand_path("/root/suitey-fooos-99"), "/vm/suitey-fooos-99", "stuff"]])
    end

    it "keeps String options verbatim for backwards compatibility" do
      config[:synced_folders] = [["/host_path", "/vm_path", "type: :nfs, create: true"]]

      expect(driver[:synced_folders])
        .to eq([[File.expand_path("/host_path"), "/vm_path", "type: :nfs, create: true"]])
    end

    it "renders Hash options as Ruby keyword syntax, which the template inlines" do
      config[:synced_folders] = [
        ["/host_path", "/vm_path", { type: "smb", smb_username: "u", smb_password: "p" }],
      ]

      expect(driver[:synced_folders]).to eq([
        [File.expand_path("/host_path"), "/vm_path",
         %{type: "smb", smb_username: "u", smb_password: "p"}],
      ])
    end

    it "leaves booleans unquoted in Hash options" do
      config[:synced_folders] = [["/host_path", "/vm_path", { type: "smb", create: true }]]

      expect(driver[:synced_folders].first.last).to eq(%{type: "smb", create: true})
    end

    it "renders missing options as the literal nil the template expects" do
      config[:synced_folders] = [["/host_path", "/vm_path", nil]]

      expect(driver[:synced_folders].first.last).to eq("nil")
    end

    it "stringifies anything else rather than rendering a Ruby object literal" do
      config[:synced_folders] = [["/host_path", "/vm_path", :create]]

      expect(driver[:synced_folders].first.last).to eq("create")
    end
  end

  describe "#format_network_options" do
    it "passes a pre-formatted String through, as finalize_network! produces" do
      expect(driver.send(:format_network_options, %{bridge: "Default Switch"}))
        .to eq(%{bridge: "Default Switch"})
    end

    it "renders a Hash as Ruby keyword syntax" do
      expect(driver.send(:format_network_options, { guest: 80, host: 8080 }))
        .to eq("guest: 80, host: 8080")
    end

    it "quotes String values" do
      expect(driver.send(:format_network_options, { ip: "192.168.33.33" }))
        .to eq(%{ip: "192.168.33.33"})
    end

    it "stringifies anything else rather than rendering a Ruby object literal" do
      expect(driver.send(:format_network_options, :auto_config)).to eq("auto_config")
    end
  end

  describe "the omnibus package cache share" do
    let(:cache_share) do
      [File.expand_path("~/.kitchen/cache"), "/tmp/omnibus/cache", "create: true"]
    end

    before { allow(FileUtils).to receive(:mkdir_p) }

    it "is shared for bento boxes known to support shared folders" do
      config[:box] = "bento/centos-99"

      expect(driver[:synced_folders]).to eq([cache_share])
    end

    it "is shared for any box once :use_cached_chef_client is set" do
      config[:box] = "some_owner/centos-99"
      config[:use_cached_chef_client] = true

      expect(driver[:synced_folders]).to eq([cache_share])
    end

    it "is skipped when :cache_directory is disabled" do
      config[:box] = "bento/centos-99"
      config[:cache_directory] = false

      expect(driver[:synced_folders]).to eq([])
    end

    it "is skipped on freebsd, which bento does not build with shared folders" do
      config[:box] = "bento/freebsd-99"

      expect(driver[:synced_folders]).to eq([])
    end

    %w{hyperv libvirt qemu utm}.each do |provider|
      it "is skipped on #{provider}, which has no usable shared folder support" do
        config[:box] = "bento/centos-99"
        config[:provider] = provider
        allow(driver_object).to receive(:hyperv_switch).and_return("Default Switch")

        expect(driver[:synced_folders]).to eq([])
      end
    end

    it "honours a custom :cache_directory as the guest mount point" do
      config[:box] = "bento/centos-99"
      config[:cache_directory] = "Z:\\awesome\\cache"

      expect(driver[:synced_folders])
        .to eq([[File.expand_path("~/.kitchen/cache"), "Z:\\awesome\\cache", "create: true"]])
    end

    it "is appended after the user's own synced folders" do
      config[:box] = "bento/centos-99"
      config[:synced_folders] = [["/root/%{instance_name}", "/vm_path", "stuff"]]

      expect(driver[:synced_folders]).to eq([
        [File.expand_path("/root/suitey-fooos-99"), "/vm_path", "stuff"],
        cache_share,
      ])
    end

    it "creates the host-side cache directory so Vagrant does not have to" do
      config[:box] = "bento/centos-99"

      driver[:synced_folders]

      expect(FileUtils).to have_received(:mkdir_p).with(File.expand_path("~/.kitchen/cache"))
    end

    it "defaults the guest mount point to a Windows-friendly path on Windows guests" do
      allow(platform).to receive(:os_type).and_return("windows")

      expect(driver[:cache_directory]).to eq("/omnibus/cache")
    end
  end

  describe "#cache_directory" do
    it "reports the configured directory when caching applies" do
      config[:box] = "bento/centos-99"

      expect(driver.cache_directory).to eq("/tmp/omnibus/cache")
    end

    it "reports false when caching does not apply" do
      config[:box] = "randomguy/centos-99"

      expect(driver.cache_directory).to be(false)
    end
  end

  describe "#winrm_transport?" do
    it "recognises a WinRM transport" do
      allow(transport).to receive(:name).and_return("WinRM")

      expect(driver.winrm_transport?).to be_truthy
    end

    it "recognises the underscored spelling too" do
      allow(transport).to receive(:name).and_return("Win_RM")

      expect(driver.winrm_transport?).to be_truthy
    end

    it "does not mistake ssh for winrm" do
      allow(transport).to receive(:name).and_return("Ssh")

      expect(driver.winrm_transport?).to be_falsey
    end
  end

  describe "#verify_dependencies" do
    it "accepts a supported Vagrant" do
      with_modern_vagrant

      expect { driver.verify_dependencies }.not_to raise_error
    end

    it "works before an Instance has been attached" do
      with_modern_vagrant

      expect { driver_with_no_instance.verify_dependencies }.not_to raise_error
    end

    it "rejects a Vagrant older than the supported minimum" do
      with_unsupported_vagrant

      expect { driver.verify_dependencies }
        .to raise_error(Kitchen::UserError, /Please upgrade to version 2\.4\.0 or higher/)
    end

    it "explains how to install when the vagrant binary is missing" do
      allow(driver_object).to receive(:run_command)
        .with("vagrant --version", any_args).and_raise(Errno::ENOENT)

      expect { driver.verify_dependencies }
        .to raise_error(Kitchen::UserError, /Vagrant 2\.4\.0 or higher is not installed/)
    end

    it "only shells out once, caching the version for the whole run" do
      with_modern_vagrant

      driver.verify_dependencies
      driver.verify_dependencies

      expect(driver_object).to have_received(:run_command).once
    end
  end

  # The driver overrides ShellOut#run_command purely to scrub the environment
  # before delegating with `super`. These specs let the real override -- and
  # the real Kitchen::ShellOut behind it -- run, capturing what finally reaches
  # Mixlib::ShellOut. Nothing is ever executed.
  describe "#run_command" do
    let(:shell) do
      instance_double(Mixlib::ShellOut, run_command: nil, error!: nil, stdout: "", execution_time: 0)
    end

    let(:constructed_with) { [] }

    before do
      allow(Mixlib::ShellOut).to receive(:new) do |_cmd, opts|
        constructed_with << opts
        shell
      end
    end

    # Returns the option hash Mixlib::ShellOut was constructed with.
    def shell_options(cmd = "cmd", options = {}, via: :run_command)
      driver.send(via, cmd, options)
      constructed_with.last
    end

    # Vagrant must not inherit our bundler environment or it will try to run
    # its own Ruby under our Gemfile. See issue #190.
    %w{
      BUNDLE_BIN_PATH BUNDLE_GEMFILE GEM_HOME GEM_PATH GEM_ROOT RUBYLIB RUBYOPT
      _ORIGINAL_GEM_PATH
    }.each do |var|
      it "unsets #{var} so vagrant does not inherit our bundle" do
        expect(shell_options[:environment]).to include(var => nil)
      end
    end

    it "passes caller-supplied environment variables through untouched" do
      options = shell_options("cmd", { environment: { "EV1" => "Val1", "EV2" => "Val2" } })

      expect(options[:environment]).to include("EV1" => "Val1", "EV2" => "Val2")
    end

    it "runs in the instance's vagrant root by default" do
      expect(shell_options("cmd", {}, via: :run)[:cwd])
        .to eq("/kroot/.kitchen/kitchen-vagrant/suitey-fooos-99")
    end

    it "lets the caller override the working directory" do
      expect(shell_options("cmd", { cwd: "/elsewhere" }, via: :run)[:cwd]).to eq("/elsewhere")
    end

    it "labels log output with the driver name" do
      driver.send(:run_command, "cmd")

      expect(logged_output.string).to include("[Vagrant command] BEGIN (cmd)")
    end

    it "echoes rather than executes under :dry_run" do
      config[:dry_run] = true
      commands = []
      allow(driver).to receive(:run_command) { |cmd, _| commands << cmd }

      driver.send(:run, "vagrant up")

      expect(commands).to eq(["echo vagrant up"])
    end

    context "when a GEM_HOME bin directory is on the PATH" do
      let(:gem_bin) { File.join("/gems", "bin") }

      before { env["GEM_HOME"] = "/gems" }

      it "strips the gem bin directory out of the PATH" do
        path = "#{gem_bin}#{File::PATH_SEPARATOR}/usr/bin"
        options = shell_options("cmd", { environment: { "PATH" => path } })

        expect(options[:environment]["PATH"]).to eq("/usr/bin")
      end

      it "leaves a PATH without the gem bin directory alone" do
        path = "/usr/bin#{File::PATH_SEPARATOR}/bin"
        options = shell_options("cmd", { environment: { "PATH" => path } })

        expect(options[:environment]["PATH"]).to eq(path)
      end

      it "seeds the PATH from the environment when the caller did not supply one" do
        env["PATH"] = "/usr/bin"

        expect(shell_options[:environment]["PATH"]).to eq("/usr/bin")
      end
    end

    context "on a Windows host" do
      before do
        allow(driver_object).to receive(:windows_host?).and_return(true)
        env["GEM_HOME"] = "/gems"
        env["PATH"] = "/gems/bin;/usr/bin"
      end

      # Rewriting PATH breaks Vagrant's Windows batch launcher, which relies on
      # prepending its own Ruby. See the comment in #run_command.
      it "leaves the PATH completely alone" do
        expect(shell_options[:environment]).not_to have_key("PATH")
      end
    end
  end

  describe "#create" do
    include_context "with a real kitchen root"

    it "writes a Vagrantfile into the instance's vagrant root" do
      driver.create(state)

      expect(File).to exist(File.join(vagrant_root, "Vagrantfile"))
    end

    it "writes the Vagrantfile only once per action" do
      driver.create(state)
      mtime = File.mtime(File.join(vagrant_root, "Vagrantfile"))

      driver.send(:create_vagrantfile)

      expect(File.mtime(File.join(vagrant_root, "Vagrantfile"))).to eq(mtime)
    end

    it "says what it is doing at debug level" do
      driver.create(state)

      expect(debug_lines).to match(/Creating Vagrantfile for <suitey-fooos-99> /)
    end

    it "dumps the rendered Vagrantfile at debug level, so failures are diagnosable" do
      driver.create(state)

      expect(debug_lines).to match(/------------\nVagrant\.configure\("2"\) do \|c\|.*\n------------/m)
    end

    it "does not dump the Vagrantfile when debug logging is off" do
      logger.level = Logger::INFO

      driver.create(state)

      expect(debug_lines).not_to include("------------")
    end

    it "fails clearly when a custom template is missing" do
      config[:vagrantfile_erb] = "/a/bunch/of/nope"

      expect { driver.create(state) }
        .to raise_error(Kitchen::ActionFailed, /^Could not find Vagrantfile template/)
    end

    it "waits for the transport to become ready" do
      conn = instance_double(Kitchen::Transport::Dummy::Connection)
      allow(transport).to receive(:connection).with(state).and_return(conn)
      allow(conn).to receive(:wait_until_ready)

      driver.create(state)

      expect(conn).to have_received(:wait_until_ready)
    end

    it "announces success at info level" do
      driver.create(state)

      expect(logged(:info)).to match(/Vagrant instance <suitey-fooos-99> created\.$/)
    end

    describe "the commands it runs" do
      it "runs vagrant up with --no-provision by default" do
        commands = stub_run_command!

        driver.create(state)

        expect(commands).to include("vagrant up --no-provision --provider virtualbox")
      end

      it "omits --no-provision when :provision is set" do
        config[:provision] = true
        commands = stub_run_command!

        driver.create(state)

        expect(commands).to include("vagrant up --provider virtualbox")
      end

      it "passes a custom provider to vagrant up" do
        config[:provider] = "bananas"
        commands = stub_run_command!

        driver.create(state)

        expect(commands).to include("vagrant up --no-provision --provider bananas")
      end

      it "lets vagrant pick the provider when :provider is explicitly cleared" do
        config[:provider] = nil
        commands = stub_run_command!

        driver.create(state)

        expect(commands).to include("vagrant up --no-provision")
        expect(commands).to include("vagrant box outdated --box fooos-99")
      end

      it "runs the pre-create command before vagrant up" do
        config[:pre_create_command] = "echo heya"
        commands = stub_run_command!

        driver.create(state)

        expect(commands.index("echo heya")).to be < commands.index { |c| c.start_with?("vagrant up") }
      end

      it "runs the pre-create command from the kitchen root, not the vagrant root" do
        config[:pre_create_command] = "echo heya"
        cwd = nil
        allow(driver).to receive(:run_command) do |cmd, options|
          cwd = options[:cwd] if cmd == "echo heya"
          ""
        end

        driver.create(state)

        expect(cwd).to eq(kitchen_root)
      end

      it "updates the box first when :box_auto_update is enabled" do
        config[:box_auto_update] = true
        commands = stub_run_command!

        driver.create(state)

        expect(commands).to include("vagrant box update --box fooos-99 --provider virtualbox")
      end

      it "tolerates updating a box that has never been downloaded" do
        config[:box_auto_update] = true
        allow(driver).to receive(:run_command) do |cmd, _|
          if cmd.include?("box update")
            raise Kitchen::ShellOut::ShellCommandFailed, "The box 'fooos-99' does not exist"
          end

          ""
        end

        expect { driver.create(state) }.not_to raise_error
      end

      it "re-raises any other failure from the box update" do
        config[:box_auto_update] = true
        allow(driver).to receive(:run_command) do |cmd, _|
          raise Kitchen::ShellOut::ShellCommandFailed, "disk full" if cmd.include?("box update")

          ""
        end

        expect { driver.create(state) }
          .to raise_error(Kitchen::ShellOut::ShellCommandFailed, /disk full/)
      end

      it "prunes older boxes when :box_auto_prune is enabled" do
        config[:box_auto_prune] = true
        commands = stub_run_command!

        driver.create(state)

        expect(commands).to include(
          "vagrant box prune --force --keep-active-boxes --name fooos-99 --provider virtualbox"
        )
      end

      it "does not update or prune by default" do
        commands = stub_run_command!

        driver.create(state)

        expect(commands).not_to include(a_string_matching(/box (update|prune)/))
      end
    end

    describe "state from vagrant ssh-config" do
      let(:ssh_config) do
        <<~OUTPUT
          Host hehe
            HostName 192.168.32.64
            User vagrant
            Port 2022
            UserKnownHostsFile /dev/null
            StrictHostKeyChecking no
            PasswordAuthentication no
            IdentityFile /path/to/private_key
            IdentitiesOnly yes
            LogLevel FATAL
        OUTPUT
      end

      before do
        allow(transport).to receive(:name).and_return("Coolness")
        allow(driver).to receive(:run_command) do |cmd, _|
          cmd == "vagrant ssh-config" ? ssh_config : ""
        end
      end

      it "records the hostname" do
        driver.create(state)

        expect(state).to include(hostname: "192.168.32.64")
      end

      it "records the port" do
        driver.create(state)

        expect(state).to include(port: "2022")
      end

      it "records the username" do
        driver.create(state)

        expect(state).to include(username: "vagrant")
      end

      it "records the identity file" do
        driver.create(state)

        expect(state).to include(ssh_key: "/path/to/private_key")
      end

      it "records no password when ssh-config offers none" do
        driver.create(state)

        expect(state).not_to have_key(:password)
      end

      it "records a password when ssh-config offers one" do
        ssh_config << "  Password yep\n"

        driver.create(state)

        expect(state).to include(password: "yep")
      end

      it "records no proxy command when ssh-config offers none" do
        driver.create(state)

        expect(state).not_to have_key(:proxy_command)
      end

      it "records a proxy command when ssh-config offers one" do
        ssh_config << "  ProxyCommand echo proxy\n"

        driver.create(state)

        expect(state).to include(proxy_command: "echo proxy")
      end
    end

    describe "state from vagrant winrm-config" do
      let(:winrm_config) do
        <<~OUTPUT
          Host hehe
            HostName 192.168.32.64
            User vagrant
            Password yep
            Port 9999
            RDPPort 5555
        OUTPUT
      end

      before do
        allow(transport).to receive(:name).and_return("WinRM")
        allow(driver).to receive(:run_command) do |cmd, _|
          cmd == "vagrant winrm-config" ? winrm_config : ""
        end
      end

      it "asks winrm-config rather than ssh-config" do
        commands = []
        allow(driver).to receive(:run_command) do |cmd, _|
          commands << cmd
          cmd == "vagrant winrm-config" ? winrm_config : ""
        end

        driver.create(state)

        expect(commands).to include("vagrant winrm-config")
        expect(commands).not_to include("vagrant ssh-config")
      end

      it "records the hostname, port, username and password" do
        driver.create(state)

        expect(state).to include(
          hostname: "192.168.32.64", port: "9999", username: "vagrant", password: "yep"
        )
      end

      it "records the RDP port" do
        driver.create(state)

        expect(state).to include(rdp_port: "5555")
      end
    end

    describe "when running under WSL" do
      before do
        env["WSL_DISTRO_NAME"] = "Ubuntu"
        allow(transport).to receive(:name).and_return("Coolness")
        allow(driver).to receive(:run_command) do |cmd, _|
          next "" unless cmd == "vagrant ssh-config"

          "Host hehe\n  HostName 10.0.0.1\n  IdentityFile C:/Users/Bob/.vagrant.d/key\n"
        end
      end

      it "translates the Windows identity file path into a WSL path" do
        driver.create(state)

        expect(state[:ssh_key]).to eq("/mnt/c/users/bob/.vagrant.d/key")
      end

      it "leaves other values untranslated" do
        driver.create(state)

        expect(state[:hostname]).to eq("10.0.0.1")
      end
    end
  end

  describe "the outdated box check" do
    include_context "with a real kitchen root"

    def create_with_outdated_output(output)
      allow(driver).to receive(:run_command) do |cmd, _|
        cmd.include?("box outdated") ? output : ""
      end
      driver.create(state)
    end

    it "warns when vagrant reports a newer version" do
      create_with_outdated_output(<<~OUTPUT)
        Checking if box 'fooos-99' version '202112.19.0' is up to date...
        A newer version of the box 'fooos-99' for provider 'virtualbox' is
        available! You currently have version '202112.19.0'. The latest is version
        '202401.31.0'.
      OUTPUT

      expect(logged(:warn)).to match(/A new version of the 'fooos-99' box is available!/)
      expect(logged(:warn)).to match(/Run `vagrant box update --box fooos-99` to update\./)
    end

    it "includes both versions in the warning when it can parse them" do
      create_with_outdated_output(
        "The box is outdated. Current: v1.2.3, Latest: v4.5.6\n"
      )

      expect(logged(:warn)).to match(/Current: 1\.2\.3, Latest: 4\.5\.6/)
    end

    it "reports whole versions from vagrant's prose output, not just the first segment" do
      create_with_outdated_output(<<~OUTPUT)
        A newer version of the box 'fooos-99' for provider 'virtualbox' is
        available! You currently have version '202112.19.0'. The latest is version
        '202401.31.0'.
      OUTPUT

      expect(logged(:warn)).to match(/Current: 202112\.19\.0, Latest: 202401\.31\.0/)
    end

    it "does not drag trailing punctuation into the version numbers" do
      create_with_outdated_output("Box is outdated. Current: 1.2.3. Latest: 4.5.6.\n")

      expect(logged(:warn)).to match(/Current: 1\.2\.3, Latest: 4\.5\.6\./)
    end

    it "still warns when it cannot parse the versions" do
      create_with_outdated_output("This box is outdated.\n")

      expect(logged(:warn)).to match(/A new version of the 'fooos-99' box is available!/)
      expect(logged(:warn)).not_to match(/Current:/)
    end

    it "stays quiet when the box is current" do
      create_with_outdated_output("You're running the latest version of this box.\n")

      expect(logged(:warn)).to be_empty
    end

    it "asks vagrant about the configured provider" do
      commands = stub_run_command!

      driver.create(state)

      expect(commands).to include("vagrant box outdated --box fooos-99 --provider virtualbox")
    end

    it "is skipped entirely when :box_auto_update is enabled, to save a round trip" do
      config[:box_auto_update] = true
      commands = stub_run_command!

      driver.create(state)

      expect(commands).not_to include(a_string_matching(/box outdated/))
    end

    it "degrades to a debug message when the box is not downloaded yet" do
      allow(driver).to receive(:run_command) do |cmd, _|
        raise Kitchen::ShellOut::ShellCommandFailed, "Box not found" if cmd.include?("box outdated")

        ""
      end

      expect { driver.create(state) }.not_to raise_error
      expect(debug_lines).to match(/Unable to check if box is outdated/)
    end
  end

  describe "#destroy" do
    include_context "with a real kitchen root"

    before do
      FileUtils.mkdir_p(vagrant_root)
      state[:hostname] = "hosta"
    end

    it "runs vagrant destroy" do
      commands = stub_run_command!

      driver.destroy(state)

      expect(commands).to include("vagrant destroy -f")
    end

    # Vagrant refuses to run without a Vagrantfile, even to destroy.
    it "re-creates the Vagrantfile so vagrant destroy has something to work with" do
      driver.destroy(state)

      expect(debug_lines).to match(/Creating Vagrantfile for <suitey-fooos-99> /)
    end

    it "closes the transport connection before destroying" do
      conn = instance_double(Kitchen::Transport::Dummy::Connection)
      allow(transport).to receive(:connection).with(state).and_return(conn)
      allow(conn).to receive(:close)

      driver.destroy(state)

      expect(conn).to have_received(:close)
    end

    it "removes the vagrant root directory" do
      driver.destroy(state)

      expect(File).not_to be_directory(vagrant_root)
    end

    it "clears :hostname from state" do
      driver.destroy(state)

      expect(state).not_to have_key(:hostname)
    end

    it "announces success at info level" do
      driver.destroy(state)

      expect(logged(:info)).to match(/Vagrant instance <suitey-fooos-99> destroyed\.$/)
    end

    it "does nothing at all when the instance was never created" do
      state.delete(:hostname)
      commands = stub_run_command!

      driver.destroy(state)

      expect(commands).to be_empty
      expect(File).to be_directory(vagrant_root)
    end
  end

  describe "#status" do
    include_context "with a real kitchen root"

    let(:machine_readable) do
      "1700000000,default,metadata,provider,virtualbox\n" \
      "1700000000,default,provider-name,virtualbox\n" \
      "1700000000,default,state,running\n" \
      "1700000000,default,state-human-short,running\n"
    end

    before { state[:hostname] = "hosta" }

    def with_vagrantfile!
      FileUtils.mkdir_p(vagrant_root)
      FileUtils.touch(File.join(vagrant_root, "Vagrantfile"))
    end

    it "reports an unknown status before the instance is created" do
      state.delete(:hostname)

      expect(driver.status(state)).to include(live: nil, state: "unknown")
    end

    it "reports an unknown status when there is no Vagrantfile to ask about" do
      expect(driver.status(state)).to include(state: "unknown")
    end

    it "reports a running machine as live" do
      with_vagrantfile!
      stub_run_command!(/status --machine-readable/ => machine_readable)

      expect(driver.status(state)).to include(
        live: true, state: "running", source: "driver",
        resource_id: "suitey-fooos-99"
      )
    end

    it "stamps when the check happened" do
      with_vagrantfile!
      stub_run_command!(/status --machine-readable/ => machine_readable)

      expect(driver.status(state)[:checked_at]).to match(/\A\d{4}-\d{2}-\d{2}T/)
    end

    it "reports a halted machine as not live" do
      with_vagrantfile!
      stub_run_command!(
        /status --machine-readable/ => "1700000000,default,state,poweroff\n"
      )

      expect(driver.status(state)).to include(live: false, state: "poweroff")
    end

    it "reports a destroyed machine as not_created rather than guessing" do
      with_vagrantfile!
      stub_run_command!(
        /status --machine-readable/ => "1700000000,default,state,not_created\n"
      )

      expect(driver.status(state)).to include(live: false, state: "not_created")
    end

    it "reports an unknown status when the output carries no state row" do
      with_vagrantfile!
      stub_run_command!(
        /status --machine-readable/ => "1700000000,default,provider-name,virtualbox\n"
      )

      expect(driver.status(state)).to include(state: "unknown")
    end

    it "reports an unknown status when vagrant fails, and says why in debug" do
      with_vagrantfile!
      allow(driver).to receive(:run_command).and_raise(Kitchen::ShellOut::ShellCommandFailed.new("boom"))

      expect(driver.status(state)).to include(state: "unknown")
      expect(logged(:debug)).to match(/Could not read the Vagrant machine state/)
    end
  end

  describe "#doctor" do
    include_context "with a real kitchen root"

    # doctor reports through warn; collect the messages so the assertions are
    # about what it found rather than how it was printed. Referencing `driver`
    # is what installs the context's modern-vagrant stub.
    def doctor_messages
      messages = []
      allow(driver).to receive(:warn) { |m| messages << m }
      [driver.doctor({}), messages]
    end

    it "passes on a workable host" do
      found, messages = doctor_messages

      expect(found).to be(false)
      expect(messages).to be_empty
    end

    it "says which vagrant it found, so a pass is informative" do
      driver.doctor({})

      expect(logged(:info)).to match(/vagrant 2\.4\.1 found at vagrant/)
    end

    it "reports a vagrant older than the driver needs" do
      # Building `driver` is what stubs a modern vagrant and caches the version
      # on the class, so an old version has to be installed after that, with the
      # cache cleared, or the context's stub wins.
      driver
      Kitchen::Driver::Vagrant.send(:vagrant_version=, nil)
      with_unsupported_vagrant

      found, messages = doctor_messages

      expect(found).to be(true)
      expect(messages.join("\n")).to match(/older than the 2\.4\.0 this driver needs/)
    end

    it "reports a vagrant that is not installed" do
      allow(driver).to receive(:vagrant_version)
        .and_raise(Kitchen::UserError.new("Vagrant 2.4.0 or higher is not installed."))

      found, messages = doctor_messages

      expect(found).to be(true)
      expect(messages.join("\n")).to match(/is not installed/)
    end

    it "reports a vagrant invocation that fails for any other reason" do
      allow(driver).to receive(:vagrant_version)
        .and_raise(StandardError.new("permission denied"))

      found, messages = doctor_messages

      expect(found).to be(true)
      expect(messages.join("\n"))
        .to match(/Could not run vagrant --version: permission denied/)
    end

    it "accepts vagrantfiles entries that are there" do
      extra = File.join(kitchen_root, "extra.rb")
      FileUtils.touch(extra)
      config[:vagrantfiles] = [extra]

      found, messages = doctor_messages

      expect(found).to be(false)
      expect(messages).to be_empty
    end

    it "reports a vagrantfile_erb template that is not there" do
      config[:vagrantfile_erb] = "/nope/Vagrantfile.erb"

      found, messages = doctor_messages

      expect(found).to be(true)
      expect(messages.join("\n")).to match(/vagrantfile_erb .*Vagrantfile.erb does not exist/)
    end

    it "reports an extra vagrantfiles entry that is not there" do
      config[:vagrantfiles] = ["/nope/extra.rb"]

      found, messages = doctor_messages

      expect(found).to be(true)
      expect(messages.join("\n")).to match(/vagrantfiles entry .*extra.rb does not exist/)
    end

    it "reports a synced_folders source that is not there" do
      config[:synced_folders] = [["/nope/src", "/vagrant/dst"]]

      found, messages = doctor_messages

      expect(found).to be(true)
      expect(messages.join("\n"))
        .to match(/synced_folders source .*src \(mounted at .*dst\) does not exist/)
    end

    it "accepts a synced_folders source that exists" do
      config[:synced_folders] = [[kitchen_root, "/vagrant/dst"]]

      found, messages = doctor_messages

      expect(found).to be(false)
      expect(messages).to be_empty
    end
  end

  describe "#package" do
    include_context "with a real kitchen root"

    before { state[:hostname] = "hosta" }

    it "refuses to package an instance that was never created" do
      state.delete(:hostname)

      expect { driver.package(state) }
        .to raise_error(Kitchen::UserError, /Vagrant instance not created!/)
    end

    it "packages into a box named after the instance, in the working directory" do
      commands = stub_run_command!

      driver.package(state)

      expect(commands)
        .to include("vagrant package --output #{File.join(Dir.pwd, "suitey-fooos-99.box")}")
    end

    it "warns that the default key will be baked into the box" do
      driver.package(state)

      expect(logged(:warn)).to match(/Disable vagrant ssh key replacement to preserve the default key!/)
    end

    it "stays quiet when key replacement is already disabled" do
      config[:ssh] = { insert_key: false }

      driver.package(state)

      expect(logged(:warn)).to be_empty
    end

    it "destroys the instance once the box has been written" do
      commands = stub_run_command!

      driver.package(state)

      expect(commands.index { |c| c.start_with?("vagrant package") })
        .to be < commands.index("vagrant destroy -f")
    end

    it "closes the transport connection before packaging" do
      conn = instance_double(Kitchen::Transport::Dummy::Connection)
      allow(transport).to receive(:connection).with(state).and_return(conn)
      allow(conn).to receive(:close)

      driver.package(state)

      expect(conn).to have_received(:close).at_least(:once)
    end
  end

  describe "#wsl?" do
    it "detects WSL from WSL_DISTRO_NAME" do
      env["WSL_DISTRO_NAME"] = "Ubuntu"

      expect(driver.send(:wsl?)).to be(true)
    end

    it "detects WSL from VAGRANT_WSL_ENABLE_WINDOWS_ACCESS" do
      env["VAGRANT_WSL_ENABLE_WINDOWS_ACCESS"] = "1"

      expect(driver.send(:wsl?)).to be(true)
    end

    it "detects WSL1 from /proc/version" do
      allow(File).to receive(:exist?).with("/proc/version").and_return(true)
      allow(File).to receive(:read).with("/proc/version")
        .and_return("Linux version 4.4.0-19041-Microsoft")

      expect(driver.send(:wsl?)).to be(true)
    end

    it "detects WSL2 from /proc/version" do
      allow(File).to receive(:exist?).with("/proc/version").and_return(true)
      allow(File).to receive(:read).with("/proc/version")
        .and_return("Linux version 5.10.16.3-microsoft-standard-WSL2")

      expect(driver.send(:wsl?)).to be(true)
    end

    it "is false on a plain Linux kernel" do
      allow(File).to receive(:exist?).with("/proc/version").and_return(true)
      allow(File).to receive(:read).with("/proc/version")
        .and_return("Linux version 5.4.0-42-generic")

      expect(driver.send(:wsl?)).to be(false)
    end

    it "is false when /proc/version does not exist" do
      allow(File).to receive(:exist?).with("/proc/version").and_return(false)

      expect(driver.send(:wsl?)).to be(false)
    end

    it "is false rather than exploding when the probe raises" do
      allow(File).to receive(:exist?).and_raise(StandardError)

      expect(driver.send(:wsl?)).to be(false)
    end
  end

  describe "#windows_to_wsl_path" do
    it "maps C: onto /mnt/c" do
      expect(driver.send(:windows_to_wsl_path, "C:/Users/username/.vagrant.d/key"))
        .to eq("/mnt/c/users/username/.vagrant.d/key")
    end

    it "maps any drive letter" do
      expect(driver.send(:windows_to_wsl_path, "D:/Projects/key")).to eq("/mnt/d/projects/key")
    end

    it "accepts a lowercase drive letter" do
      expect(driver.send(:windows_to_wsl_path, "c:/path/to/key")).to eq("/mnt/c/path/to/key")
    end

    it "leaves a Unix path alone" do
      path = "/home/user/.vagrant.d/insecure_private_key"

      expect(driver.send(:windows_to_wsl_path, path)).to eq(path)
    end

    it "leaves a relative path alone" do
      path = ".vagrant/machines/default/virtualbox/private_key"

      expect(driver.send(:windows_to_wsl_path, path)).to eq(path)
    end
  end

  describe "#vagrant_root" do
    it "namespaces the instance under .kitchen/kitchen-vagrant" do
      expect(driver.send(:vagrant_root))
        .to eq("/kroot/.kitchen/kitchen-vagrant/suitey-fooos-99")
    end

    it "is nil before an Instance is attached, since the name is unknown" do
      expect(driver_with_no_instance.send(:vagrant_root)).to be_nil
    end
  end
end
