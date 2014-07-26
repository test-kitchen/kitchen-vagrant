# -*- encoding: utf-8 -*-
#
# Author:: Salim Afiune (<salim@afiunemaya.com.mx>)
#
# Copyright (C) 2014, Salim Afiune
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

require 'fileutils'
require 'rubygems/version'

require 'kitchen'
require 'kitchen/driver/vagrant_common'
# Useful VBox Machine Class
require 'kitchen/provider/machine'

module Kitchen

  module Driver

    # VagrantWindows driver for Kitchen using [WinRM] protocol.
    # It communicates to Vagrant via the CLI.
    #
    # @author Salim Afiune <salim@afiunemaya.com.mx>
    #
    # @todo Vagrant installation check and version will be placed into any
    #   dependency hook checks when feature is released
    class VagrantWindows < Kitchen::Driver::WinRMBase

      default_config :customize, {}
      default_config :network, []
      default_config :synced_folders, []
      default_config :pre_create_command, nil

      default_config :vagrantfile_erb,
        File.join(File.dirname(__FILE__), "../../../templates/Vagrantfile.erb")

      default_config :provider,
        ENV.fetch('VAGRANT_DEFAULT_PROVIDER', "virtualbox")

      default_config :vm_hostname do |driver|
        "#{driver.instance.name}.vagrantup.com"
      end

      default_config :box do |driver|
        "opscode-#{driver.instance.platform.name}"
      end

      default_config :box_url do |driver|
        driver.default_box_url
      end

      required_config :box

      no_parallel_for :create, :destroy

      def create(state)
        create_vagrantfile
        run_pre_create_command
        cmd = "vagrant up --no-provision"
        cmd += " --provider=#{config[:provider]}" if config[:provider]
        run cmd
        set_winrm_state(state)
        info("Vagrant instance #{instance.to_str} created.")
      end

      def converge(state)
        create_vagrantfile
        refresh_winrm_forwarded_port(state)
        super
      end

      def setup(state)
        create_vagrantfile
        refresh_winrm_forwarded_port(state)
        super
      end

      def verify(state)
        create_vagrantfile
        refresh_winrm_forwarded_port(state)
        super
      end

      def destroy(state)
        return if state[:hostname].nil?

        create_vagrantfile
        @vagrantfile_created = false
        run "vagrant destroy -f"
        FileUtils.rm_rf(vagrant_root)
        info("Vagrant instance #{instance.to_str} destroyed.")
        state.delete(:hostname)
      end

      def verify_dependencies
        check_vagrant_version
      end

      def instance=(instance)
        @instance = instance
        resolve_config!
      end

      def default_box_url
        bucket = config[:provider]
        bucket = 'vmware' if config[:provider] =~ /^vmware_(.+)$/

        "https://opscode-vm-bento.s3.amazonaws.com/vagrant/#{bucket}/" +
          "opscode_#{instance.platform.name}_chef-provisionerless.box"
      end

      protected

      include Kitchen::Driver::VagrantCommon
      
      def set_winrm_state(state)
        hash = vagrant_ssh_config

        state[:hostname] = hash["HostName"]
        state[:username] = config[:username] if config[:username]
        state[:password] = config[:password] if config[:password]
        refresh_winrm_forwarded_port(state)
      end

      # Getting WinRM forwarded_port from Provider
      #
      # Working with: VirtualBox
      def refresh_winrm_forwarded_port(state)
        case config[:provider]
        when "virtualbox"
          Provider::VirtualBox::Machine.new(vagrant_root) do |machine|
            state[:port] = machine.host_port(5985)
          end
        end
      end
    end
  end
end
