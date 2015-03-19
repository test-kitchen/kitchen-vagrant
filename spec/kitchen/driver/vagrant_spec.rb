# -*- encoding: utf-8 -*-
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

require_relative "../../spec_helper"

require "logger"
require "stringio"

require "kitchen/driver/vagrant"
require "kitchen/provisioner/dummy"
require "kitchen/transport/dummy"
require "kitchen/verifier/dummy"

describe Kitchen::Driver::Vagrant do

  let(:logged_output) { StringIO.new }
  let(:logger)        { Logger.new(logged_output) }
  let(:config)        { { :kitchen_root => "/kroot" } }
  let(:platform)      { Kitchen::Platform.new(:name => "fooos-99") }
  let(:suite)         { Kitchen::Suite.new(:name => "suitey") }
  let(:verifier)      { Kitchen::Verifier::Dummy.new }
  let(:provisioner)   { Kitchen::Provisioner::Dummy.new }
  let(:transport)     { Kitchen::Transport::Dummy.new }
  let(:state_file)    { double("state_file") }
  let(:state)         { Hash.new }
  let(:env)           { Hash.new }

  let(:driver_object) { Kitchen::Driver::Vagrant.new(config) }

  let(:driver) do
    d = driver_object
    instance
    d
  end

  let(:instance) do
    Kitchen::Instance.new(
      :verifier => verifier,
      :driver => driver_object,
      :logger => logger,
      :suite => suite,
      :platform => platform,
      :provisioner => provisioner,
      :transport => transport,
      :state_file => state_file
    )
  end

  before { stub_const("ENV", env) }

  describe "configuration" do

    it "sets :box based on the platform name by default" do
      expect(driver[:box]).to eq("opscode-fooos-99")
    end

    it "sets :box to a custom value" do
      config[:box] = "booya"

      expect(driver[:box]).to eq("booya")
    end

    it "sets :box_check_update to nil by default" do
      expect(driver[:box_check_update]).to eq(nil)
    end

    it "sets :box_check_update to a custom value" do
      config[:box_check_update] = true

      expect(driver[:box_check_update]).to eq(true)
    end

    it "sets :box_version to nil by default" do
      expect(driver[:box_version]).to eq(nil)
    end

    it "sets :box_version to a custom value" do
      config[:box_version] = "1.2.3"

      expect(driver[:box_version]).to eq("1.2.3")
    end

    it "sets :customize to an empty hash by default" do
      expect(driver[:customize]).to eq({})
    end

    it "sets :customize to a custom value" do
      config[:customize] = { :a => "b", :c => { :d => "e" } }

      expect(driver[:customize]).to eq(:a => "b", :c => { :d => "e" })
    end

    it "sets :gui to nil by default" do
      expect(driver[:gui]).to eq(nil)
    end

    it "sets :network to an empty array by default" do
      expect(driver[:network]).to eq([])
    end

    it "sets :network to a custom value" do
      config[:network] = [
        ["forwarded_port", :guest => 80, :host => 8080]
      ]

      expect(driver[:network]).to eq([
        ["forwarded_port", :guest => 80, :host => 8080]
      ])
    end

    it "sets :pre_create_command to nil by default" do
      expect(driver[:pre_create_command]).to eq(nil)
    end

    it "sets :pre_create_command to a custom value" do
      config[:pre_create_command] = "execute yo"

      expect(driver[:pre_create_command]).to eq("execute yo")
    end

    it "replaces {{vagrant_root}} in :pre_create_command" do
      config[:pre_create_command] = "{{vagrant_root}}/candy"

      expect(driver[:pre_create_command]).to eq(
        "/kroot/.kitchen/kitchen-vagrant/kitchen-kroot-suitey-fooos-99/candy"
      )
    end

    it "sets :provision to false by default" do
      expect(driver[:provision]).to eq(false)
    end

    it "sets :provision to a custom value" do
      config[:provision] = true

      expect(driver[:provision]).to eq(true)
    end

    it "sets :provider to virtualbox by default" do
      expect(driver[:provider]).to eq("virtualbox")
    end

    it "sets :provider to the value of VAGRANT_DEFAULT_PROVIDER from ENV" do
      env["VAGRANT_DEFAULT_PROVIDER"] = "vcool"

      expect(driver[:provider]).to eq("vcool")
    end

    it "sets :provider to a custom value" do
      config[:provider] = "mything"

      expect(driver[:provider]).to eq("mything")
    end

    it "sets :ssh to an empty hash by default" do
      expect(driver[:ssh]).to eq({})
    end

    it "sets :ssh to a custom value" do
      config[:ssh] = { :a => "b", :c => { :d => "e" } }

      expect(driver[:ssh]).to eq(:a => "b", :c => { :d => "e" })
    end

    it "sets :synced_folders to an empty array by default" do
      expect(driver[:synced_folders]).to eq([])
    end

    it "sets :synced_folders to a custom value" do
      config[:synced_folders] = [
        ["/host_path", "/vm_path", "create: true, type: :nfs"]
      ]

      expect(driver[:synced_folders]).to eq([
        ["/host_path", "/vm_path", "create: true, type: :nfs"]
      ])
    end

    it "replaces %{instance_name} with instance name in :synced_folders" do
      config[:synced_folders] = [
        ["/root/%{instance_name}", "/vm_path", "stuff"]
      ]

      expect(driver[:synced_folders]).to eq([
        ["/root/suitey-fooos-99", "/vm_path", "stuff"]
      ])
    end

    it "expands source paths relative to :kitchen_root in :synced_folders" do
      config[:synced_folders] = [
        ["./a", "/vm_path", "stuff"]
      ]

      expect(driver[:synced_folders]).to eq([
        ["/kroot/a", "/vm_path", "stuff"]
      ])
    end

    it "sets options to 'nil' if not set in :synced_folders entry" do
      config[:synced_folders] = [
        ["/host_path", "/vm_path", nil]
      ]

      expect(driver[:synced_folders]).to eq([
        ["/host_path", "/vm_path", "nil"]
      ])
    end

    it "sets :vagrantfile_erb to a default" do
      expect(driver[:vagrantfile_erb]).to match(
        %r{/kitchen-vagrant/templates/Vagrantfile\.erb$}
      )
    end

    it "sets :vagrantfile_erb to a default value" do
      config[:vagrantfile_erb] = "/a/Vagrantfile.erb"

      expect(driver[:vagrantfile_erb]).to eq("/a/Vagrantfile.erb")
    end

    it "expands path for :vagrantfile_erb" do
      config[:vagrantfile_erb] = "Yep.erb"

      expect(driver[:vagrantfile_erb]).to eq("/kroot/Yep.erb")
    end

    it "sets :vagrantfiles to an empty array by default" do
      expect(driver[:vagrantfiles]).to eq([])
    end

    it "sets and expands paths in :vagrantfiles" do
      config[:vagrantfiles] = %W[one two three]

      expect(driver[:vagrantfiles]).to eq(
        %W[/kroot/one /kroot/two /kroot/three]
      )
    end

    context "for unix os_types" do

      before { allow(platform).to receive(:os_type).and_return("unix") }

      it "sets :vm_hostname to the instance name by default" do
        expect(driver[:vm_hostname]).to eq("suitey-fooos-99")
      end

      it "sets :vm_hostname to a custom value" do
        config[:vm_hostname] = "okay"

        expect(driver[:vm_hostname]).to eq("okay")
      end
    end

    context "for windows os_types" do

      before { allow(platform).to receive(:os_type).and_return("windows") }

      it "sets :vm_hostname to nil by default" do
        expect(driver[:vm_hostname]).to eq(nil)
      end

      it "sets :vm_hostname to a custom value, truncated to 12 chars" do
        config[:vm_hostname] = "this-is-a-pretty-long-name-ya-think"

        expect(driver[:vm_hostname]).to eq("this-is-a--k")
      end
    end

    context "for non-WinRM-based transports" do

      before { allow(transport).to receive(:name).and_return("Coolness") }

      it "sets :username to nil by default" do
        expect(driver[:username]).to eq(nil)
      end

      it "sets :password to nil by default" do
        expect(driver[:password]).to eq(nil)
      end
    end

    context "for WinRM-based transports" do

      before { allow(transport).to receive(:name).and_return("WinRM") }

      it "sets :username to vagrant by default" do
        expect(driver[:username]).to eq("vagrant")
      end

      it "sets :password to vagrant by default" do
        expect(driver[:password]).to eq("vagrant")
      end
    end

    context "with old versions of Vagrant" do

      before { with_old_vagrant }

      it "sets :box_url to a default based platform" do
        expect(driver[:box_url]).to eq(
          "https://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/" \
          "opscode_fooos-99_chef-provisionerless.box"
        )
      end

      it "sets :box_url to a default based on provider" do
        config[:provider] = "vcool"

        expect(driver[:box_url]).to eq(
          "https://opscode-vm-bento.s3.amazonaws.com/vagrant/vcool/" \
          "opscode_fooos-99_chef-provisionerless.box"
        )
      end

      it "sets :box_url to a default for vmware-based providers" do
        config[:provider] = "vmware_awesometown"

        expect(driver[:box_url]).to eq(
          "https://opscode-vm-bento.s3.amazonaws.com/vagrant/vmware/" \
          "opscode_fooos-99_chef-provisionerless.box"
        )
      end
    end

    context "with modern versions of Vagrant" do

      before { with_modern_vagrant }

      it "sets :box_url to nil" do
        expect(driver[:box_url]).to eq(nil)
      end
    end
  end

  describe "#verify_dependencies" do

    it "passes for supported versions of Vagrant" do
      with_modern_vagrant

      driver.verify_dependencies
    end

    it "raises a UserError for unsupported versions of Vagrant" do
      with_unsupported_vagrant

      expect { driver.verify_dependencies }.to raise_error(
        Kitchen::UserError, /Please upgrade to version 1.1.0 or higher/
      )
    end

    it "raises a UserError for a missing Vagrant command" do
      allow(driver).to receive(:run_command).
        with("vagrant --version", any_args).and_raise(Errno::ENOENT)

      expect { driver.verify_dependencies }.to raise_error(
        Kitchen::UserError, /Vagrant 1.1.0 or higher is not installed/
      )
    end
  end

  describe "#create" do

    let(:cmd) { driver.create(state) }

    let(:vagrant_root) do
      File.join(%W[
        #{@dir} .kitchen kitchen-vagrant
        kitchen-#{File.basename(@dir)}-suitey-fooos-99
      ])
    end

    before do
      @dir = Dir.mktmpdir("kitchen_root")
      config[:kitchen_root] = @dir

      allow(driver).to receive(:run_command).and_return("")
      with_modern_vagrant
    end

    after do
      FileUtils.remove_entry_secure(@dir)
    end

    it "logs a message on debug level for creating the Vagrantfile" do
      cmd

      expect(logged_output.string).to match(
        /^D, .+ DEBUG -- : Creating Vagrantfile for \<suitey-fooos-99\> /
      )
    end

    it "creates a Vagrantfile in the vagrant root directory" do
      cmd

      expect(File.exist?(File.join(vagrant_root, "Vagrantfile"))).to eq(true)
    end

    it "calls Transport's #wait_until_ready" do
      conn = double("connection")
      allow(transport).to receive(:connection).with(state).and_return(conn)
      expect(conn).to receive(:wait_until_ready)

      cmd
    end

    it "logs the Vagrantfile contents on debug level" do
      cmd

      expect(debug_lines).to match(Regexp.new(<<-REGEXP.gsub(/^ {8}/, "")))
        ------------
        Vagrant.configure\("2"\) do \|c\|
        .*
        end
        ------------
      REGEXP
    end

    it "raises ActionFailed if a custom Vagrantfile template was not found" do
      config[:vagrantfile_erb] = "/a/bunch/of/nope"

      expect { cmd }.to raise_error(
        Kitchen::ActionFailed, /^Could not find Vagrantfile template/
      )
    end

    it "runs the pre create command, if set" do
      config[:pre_create_command] = "echo heya"
      expect(driver).to receive(:run_command).with("echo heya", any_args)

      cmd
    end

    it "runs vagrant up with --no-provision if :provision is falsey" do
      config[:provision] = false
      expect(driver).to receive(:run_command).
        with("vagrant up --no-provision --provider virtualbox", any_args)

      cmd
    end

    it "runs vagrant up without --no-provision if :provision is truthy" do
      config[:provision] = true
      expect(driver).to receive(:run_command).
        with("vagrant up --provider virtualbox", any_args)

      cmd
    end

    it "runs vagrant up with a custom provider if :provider is set" do
      config[:provider] = "bananas"
      expect(driver).to receive(:run_command).
        with("vagrant up --no-provision --provider bananas", any_args)

      cmd
    end

    describe "for state" do

      let(:output) do
        <<-OUTPUT.gsub(/^ {10}/, "")
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
        allow(driver).to receive(:run_command).
          with("vagrant ssh-config", any_args).and_return(output)
      end

      it "sets :hostname from ssh-config" do
        cmd

        expect(state).to include(:hostname => "192.168.32.64")
      end

      context "for non-WinRM-based transports" do

        before { allow(transport).to receive(:name).and_return("Coolness") }

        it "sets :username from ssh-config" do
          cmd

          expect(state).to include(:username => "vagrant")
        end

        it "sets :ssh_key from ssh-config" do
          cmd

          expect(state).to include(:ssh_key => "/path/to/private_key")
        end

        it "sets :port from ssh-config" do
          cmd

          expect(state).to include(:port => "2022")
        end

        it "does not set :proxy_command by default" do
          cmd

          expect(state.keys).to_not include(:proxy_command)
        end

        it "sets :proxy_command if ProxyCommand is in ssh-config" do
          output.concat("  ProxyCommand echo proxy\n")
          cmd

          expect(state).to include(:proxy_command => "echo proxy")
        end
      end

      context "for WinRM-based transports" do

        before { allow(transport).to receive(:name).and_return("WinRM") }

        it "sets :username from config" do
          config[:username] = "winuser"
          cmd

          expect(state).to include(:username => "winuser")
        end

        it "sets :password from config" do
          config[:password] = "mysecret"
          cmd

          expect(state).to include(:password => "mysecret")
        end
      end
    end

    it "logs a message on info level" do
      cmd

      expect(logged_output.string).to match(
        /I, .+ INFO -- : Vagrant instance \<suitey-fooos-99\> created\.$/
      )
    end
  end

  describe "#destroy" do

    let(:cmd) { driver.destroy(state) }

    let(:vagrant_root) do
      File.join(%W[
        #{@dir} .kitchen kitchen-vagrant
        kitchen-#{File.basename(@dir)}-suitey-fooos-99
      ])
    end

    before do
      @dir = Dir.mktmpdir("kitchen_root")
      config[:kitchen_root] = @dir

      allow(driver).to receive(:run_command).and_return("")
      with_modern_vagrant

      FileUtils.mkdir_p(vagrant_root)
      state[:hostname] = "hosta"
    end

    after do
      FileUtils.remove_entry_secure(@dir)
    end

    it "logs a message on debug level for creating the Vagrantfile" do
      cmd

      expect(logged_output.string).to match(
        /^D, .+ DEBUG -- : Creating Vagrantfile for \<suitey-fooos-99\> /
      )
    end

    it "logs the Vagrantfile contents on debug level" do
      cmd

      expect(debug_lines).to match(Regexp.new(<<-REGEXP.gsub(/^ {8}/, "")))
        ------------
        Vagrant.configure\("2"\) do \|c\|
        .*
        end
        ------------
      REGEXP
    end

    it "does not run vagrant destroy if :hostname is not present in state" do
      state.delete(:hostname)
      expect(driver).to_not receive(:run_command).
        with("vagrant destroy -f", any_args)

      cmd
    end

    it "runs vagrant destroy" do
      expect(driver).to receive(:run_command).
        with("vagrant destroy -f", any_args)

      cmd
    end

    it "deletes the vagrant root directory" do
      expect(File.directory?(vagrant_root)).to eq(true)
      cmd
      expect(File.directory?(vagrant_root)).to eq(false)
    end

    it "logs a message on info level" do
      cmd

      expect(logged_output.string).to match(
        /I, .+ INFO -- : Vagrant instance \<suitey-fooos-99\> destroyed\.$/
      )
    end

    it "deletes :hostname from state" do
      cmd

      expect(state.keys).to_not include(:hostname)
    end
  end

  describe "Vagrantfile" do

    let(:cmd) { driver.create(state) }

    let(:vagrant_root) do
      File.join(%W[
        #{@dir} .kitchen kitchen-vagrant
        kitchen-#{File.basename(@dir)}-suitey-fooos-99
      ])
    end

    before do
      @dir = Dir.mktmpdir("kitchen_root")
      config[:kitchen_root] = @dir

      allow(driver).to receive(:run_command).and_return("")
      with_modern_vagrant
    end

    after do
      FileUtils.remove_entry_secure(@dir)
    end

    it "disables the vagrant-berkshelf plugin is present" do
      cmd

      expect(vagrantfile).to match(regexify(
        "c.berkshelf.enabled = false " \
        "if Vagrant.has_plugin?(\"vagrant-berkshelf\")"
      ))
    end

    it "sets the vm.box" do
      cmd

      expect(vagrantfile).to match(regexify(%{c.vm.box = "opscode-fooos-99"}))
    end

    it "sets the vm.hostname" do
      config[:vm_hostname] = "charlie"
      cmd

      expect(vagrantfile).to match(regexify(%{c.vm.hostname = "charlie"}))
    end

    it "disables the /vagrant synced folder by default" do
      cmd

      expect(vagrantfile).to match(regexify(
        %{c.vm.synced_folder ".", "/vagrant", disabled: true}
      ))
    end

    it "creates an empty provider block by default" do
      config[:provider] = "wowza"
      cmd

      expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {6}/, "").chomp))
        c.vm.provider :wowza do |p|
        end
      RUBY
    end

    it "requires no Vagrantfiles by default" do
      cmd

      expect(vagrantfile).to_not match(regexify("require"))
    end

    it "requires each entry in :vagranfiles" do
      config[:vagrantfiles] = %W[/a /b /c]
      cmd

      expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {8}/, "").chomp))
        require "/a"
        require "/b"
        require "/c"
      RUBY
    end

    it "sets no vm.box_url if missing" do
      config[:box_url] = nil
      cmd

      expect(vagrantfile).to_not match(regexify(%{c.vm.box_url}, :partial))
    end

    it "sets vm.box_url if :box_url is set" do
      config[:box_url] = "dat.url"
      cmd

      expect(vagrantfile).to match(regexify(%{c.vm.box_url = "dat.url"}))
    end

    it "sets no vm.box_version if missing" do
      config[:box_version] = nil
      cmd

      expect(vagrantfile).to_not match(regexify(%{c.vm.box_version}, :partial))
    end

    it "sets vm.box_version if :box_version is set" do
      config[:box_version] = "a.b.c"
      cmd

      expect(vagrantfile).to match(regexify(%{c.vm.box_version = "a.b.c"}))
    end

    it "sets no vm.box_check_update if missing" do
      config[:box_check_update] = nil
      cmd

      expect(vagrantfile).to_not match(
        regexify(%{c.vm.box_check_update}, :partial)
      )
    end

    it "sets vm.box_check_update if :box_check_update is set" do
      config[:box_check_update] = "um"
      cmd

      expect(vagrantfile).to match(regexify(%{c.vm.box_check_update = "um"}))
    end

    it "sets no vm.communicator if missing" do
      config[:communicator] = nil
      cmd

      expect(vagrantfile).to_not match(regexify(%{c.vm.communicator}, :partial))
    end

    it "sets vm.communicator if :communicator is set" do
      config[:communicator] = "wat"
      cmd

      expect(vagrantfile).to match(regexify(%{c.vm.communicator = "wat"}))
    end

    it "sets no vm.guest if missing" do
      config[:guest] = nil
      cmd

      expect(vagrantfile).to_not match(regexify(%{c.vm.guest}, :partial))
    end

    it "sets vm.guest if :guest is set" do
      config[:guest] = "mac"
      cmd

      expect(vagrantfile).to match(regexify(%{c.vm.guest = "mac"}))
    end

    it "sets no ssh.username if missing" do
      config[:username] = nil
      cmd

      expect(vagrantfile).to_not match(regexify(%{c.ssh.username}, :partial))
    end

    it "sets ssh.username if :username is set" do
      config[:username] = "jdoe"
      cmd

      expect(vagrantfile).to match(regexify(%{c.ssh.username = "jdoe"}))
    end

    it "sets no ssh.password if missing" do
      config[:password] = nil
      cmd

      expect(vagrantfile).to_not match(regexify(%{c.ssh.password}, :partial))
    end

    it "sets ssh.password if :password is set" do
      config[:password] = "okay"
      cmd

      expect(vagrantfile).to match(regexify(%{c.ssh.password = "okay"}))
    end

    it "sets no ssh.private_key_path if missing" do
      config[:ssh_key] = nil
      cmd

      expect(vagrantfile).to_not match(
        regexify(%{c.ssh.private_key_path}, :partial)
      )
    end

    it "sets ssh.private_key_path if :ssh_key is set" do
      config[:ssh_key] = "okay"
      cmd

      expect(vagrantfile).to match(regexify(%{c.ssh.private_key_path = "okay"}))
    end

    it "adds a vm.ssh line for each key/value pair in :ssh" do
      config[:ssh] = {
        :username => %{"jdoe"},
        :password => %{"secret"},
        :private_key_path => %{"/key"}
      }
      cmd

      expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {6}/, "").chomp))
        c.ssh.username = "jdoe"
        c.ssh.password = "secret"
        c.ssh.private_key_path = "/key"
      RUBY
    end

    it "adds a vm.network line for each element in :network" do
      config[:network] = [
        ["forwarded_port", { :guest => 80, :host => 8080 }],
        ["private_network", { :ip => "192.168.33.33" }]
      ]
      cmd

      expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {6}/, "").chomp))
        c.vm.network(:forwarded_port, {:guest=>80, :host=>8080})
        c.vm.network(:private_network, {:ip=>"192.168.33.33"})
      RUBY
    end

    it "adds a vm.synced_folder line for each element in :synced_folders" do
      config[:synced_folders] = [
        ["/a/b", "/opt/instance_data", "nil"],
        ["/host_path", "/vm_path", "create: true, type: :nfs"]
      ]
      cmd

      expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {6}/, "").chomp))
        c.vm.synced_folder "/a/b", "/opt/instance_data", nil
        c.vm.synced_folder "/host_path", "/vm_path", create: true, type: :nfs
      RUBY
    end

    context "for virtualbox provider" do

      before { config[:provider] = "virtualbox" }

      it "adds a line for each element in :customize" do
        config[:customize] = {
          :a_key => "some value",
          :something => "else"
        }
        cmd

        expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {8}/, "").chomp))
          c.vm.provider :virtualbox do |p|
            p.customize ["modifyvm", :id, "--a_key", "some value"]
            p.customize ["modifyvm", :id, "--something", "else"]
          end
        RUBY
      end

      it "does not set :gui to nil" do
        config[:gui] = nil
        cmd

        expect(vagrantfile).to_not match(regexify(%{p.gui = }, :partial))
      end

      it "sets :gui to false if set" do
        config[:gui] = false
        cmd

        expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {8}/, "").chomp))
          c.vm.provider :virtualbox do |p|
            p.gui = false
          end
        RUBY
      end

      it "sets :gui to true if set" do
        config[:gui] = true
        cmd

        expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {8}/, "").chomp))
          c.vm.provider :virtualbox do |p|
            p.gui = true
          end
        RUBY
      end
    end

    context "for parallels provider" do

      before { config[:provider] = "parallels" }

      it "adds a line for each element in :customize" do
        config[:customize] = {
          :a_key => "some value",
          :something => "else"
        }
        cmd

        expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {8}/, "").chomp))
          c.vm.provider :parallels do |p|
            p.customize ["set", :id, "--a-key", "some value"]
            p.customize ["set", :id, "--something", "else"]
          end
        RUBY
      end
    end

    context "for rackspace provider" do

      before { config[:provider] = "rackspace" }

      it "adds a line for each element in :customize" do
        config[:customize] = {
          :a_key => "some value",
          :something => "else"
        }
        cmd

        expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {8}/, "").chomp))
          c.vm.provider :rackspace do |p|
            p.a_key = "some value"
            p.something = "else"
          end
        RUBY
      end
    end

    context "for softlayer provider" do

      before { config[:provider] = "softlayer" }

      it "adds a line for each element in :customize" do
        config[:customize] = {
          :a_key => "some value",
          :something => "else"
        }
        cmd

        expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {8}/, "").chomp))
          c.vm.provider :softlayer do |p|
            p.a_key = "some value"
            p.something = "else"
          end
        RUBY
      end
    end

    context "for libvirt provider" do

      before { config[:provider] = "libvirt" }

      it "adds a line for each element in :customize" do
        config[:customize] = {
          :a_key => "some value",
          :something => "else"
        }
        cmd

        expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {8}/, "").chomp))
          c.vm.provider :libvirt do |p|
            p.a_key = some value
            p.something = else
          end
        RUBY
      end
    end

    context "for vmware_* providers" do

      before { config[:provider] = "vmware_desktop" }

      it "does not set :gui to nil" do
        config[:gui] = nil
        cmd

        expect(vagrantfile).to_not match(regexify(%{p.gui = }, :partial))
      end

      it "sets :gui to false if set" do
        config[:gui] = false
        cmd

        expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {8}/, "").chomp))
          c.vm.provider :vmware_desktop do |p|
            p.gui = false
          end
        RUBY
      end

      it "sets :gui to true if set" do
        config[:gui] = true
        cmd

        expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {8}/, "").chomp))
          c.vm.provider :vmware_desktop do |p|
            p.gui = true
          end
        RUBY
      end

      it "adds a line for each element in :customize" do
        config[:customize] = {
          :a_key => "some value",
          :something => "else"
        }
        cmd

        expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {8}/, "").chomp))
          c.vm.provider :vmware_desktop do |p|
            p.vmx["a_key"] = "some value"
            p.vmx["something"] = "else"
          end
        RUBY
      end

      it "converts :memory into :memsize" do
        config[:customize] = {
          :memory => "222"
        }
        cmd

        expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {8}/, "").chomp))
          c.vm.provider :vmware_desktop do |p|
            p.vmx["memsize"] = "222"
          end
        RUBY
      end

      it "skips :memory if key :memsize exists" do
        config[:customize] = {
          :memory => "222",
          :memsize => "444"
        }
        cmd

        expect(vagrantfile).to match(regexify(<<-RUBY.gsub(/^ {8}/, "").chomp))
          c.vm.provider :vmware_desktop do |p|
            p.vmx["memsize"] = "444"
          end
        RUBY
      end
    end
  end

  def debug_lines
    regex = %r{^D, .* : }
    logged_output.string.lines.
      select { |l| l =~ regex }.map { |l| l.sub(regex, "") }.join
  end

  def with_modern_vagrant
    allow(driver).to receive(:run_command).
      with("vagrant --version", any_args).and_return("Vagrant 1.7.2")
  end

  def with_old_vagrant
    allow(driver).to receive(:run_command).
      with("vagrant --version", any_args).and_return("Vagrant 1.4.5")
  end

  def with_unsupported_vagrant
    allow(driver).to receive(:run_command).
      with("vagrant --version", any_args).and_return("Vagrant 1.0.5")
  end

  def regexify(str, line = :whole_line)
    r = Regexp.escape(str)
    r = "^\s*#{r}$" if line == :whole_line
    Regexp.new(r)
  end

  def vagrantfile
    IO.read(File.join(vagrant_root, "Vagrantfile"))
  end
end
