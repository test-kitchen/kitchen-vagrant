# -*- encoding: utf-8 -*-
#
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
#
# Copyright (C) 2013, Fletcher Nichol
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

module Kitchen

  module Vagrant

    # Class to render Vagrantfiles to be used by the Kitchen Vagrant driver.
    #
    # @author Fletcher Nichol <fnichol@nichol.ca>
    class VagrantfileCreator

      def initialize(instance, config)
        @instance = instance
        @config = config
      end

      def render
        arr = []
        arr << %{Vagrant.configure("2") do |c|}
        common_block(arr)
        guest_block(arr)
        network_block(arr)
        provider_block(arr)
        chef_block(arr) if config[:use_vagrant_provision]
        synced_folders_block(arr)
        arr << %{end}
        arr.join("\n")
      end

      private

      attr_reader :instance, :config

      def common_block(arr)
        arr << %{  c.vm.box = "#{config[:box]}"}
        arr << %{  c.vm.box_url = "#{config[:box_url]}"} if config[:box_url]
        arr << %{  c.vm.synced_folder ".", "/vagrant", disabled: true}
        if config[:ssh_key]
          arr << %{  c.ssh.private_key_path = "#{config[:ssh_key]}"}
        end
        arr << %{  c.vm.hostname = "#{instance.name}.vagrantup.com"}
        arr << %{  c.ssh.username = "#{config[:username]}"} if config[:username]
      end

      def guest_block(arr)
        if config[:guest]
          arr << %{  c.vm.guest = #{config[:guest]}}
        end
      end

      def network_block(arr)
        Array(config[:network]).each do |network_options|
          options = Array(network_options.dup)
          type = options.shift
          arr << %{  c.vm.network(:#{type}, #{options.join(", ")})}
        end
      end

      def provider_block(arr)
        arr << %{  c.vm.provider :#{provider} do |p|}
        case provider
        when 'virtualbox'
          virtualbox_customize(arr)
        when 'vmware_fusion', 'vmware_workstation'
          vmware_customize(arr)
        when 'rackspace'
          rackspace_customize(arr)
        end
        arr << %{  end}
      end

      def chef_block(arr)
        arr << %{  c.vm.provision :chef_solo do |chef|}
        arr << %{    chef.log_level = #{vagrant_logger_level}}
        arr << %{    chef.run_list = #{instance.run_list.inspect}}
        arr << %{    chef.json = #{instance.attributes.to_s}}
        if instance.suite.data_bags_path
          arr << %{    chef.data_bags_path = "#{instance.suite.data_bags_path}"}
        end
        if key_path
          arr << %{    chef.encrypted_data_bag_secret_key_path = "#{key_path}"}
        end
        if instance.suite.roles_path
          arr << %{    chef.roles_path = "#{instance.suite.roles_path}"}
        end
        arr << %{  end}
      end

      def synced_folders_block(arr)
        instance_name = instance.name
        config[:synced_folders].each do |source, destination, options|
          l_source = source.gsub("%{instance_name}", instance_name)
          l_destination = destination.gsub("%{instance_name}", instance_name)
          opt = (options.nil? ? '' : ", #{options}")
          arr << %{ c.vm.synced_folder "#{l_source}", "#{l_destination}"#{opt} }
        end
      end

      def vagrant_logger_level
        if instance.logger.debug?
          ":debug"
        elsif instance.logger.info?
          ":info"
        elsif instance.logger.error?
          ":error"
        elsif instance.logger.fatal?
          ":fatal"
        else
          ":info"
        end
      end

      def berksfile
        File.join(config[:kitchen_root], "Berksfile")
      end

      def provider
        config[:provider] || ENV['VAGRANT_DEFAULT_PROVIDER'] || 'virtualbox'
      end

      def virtualbox_customize(arr)
        config[:customize].each do |key, value|
          arr << %{    p.customize ["modifyvm", :id, "--#{key}", "#{value}"]}
        end
      end

      def vmware_customize(arr)
        config[:customize].each do |key, value|
          if key == :memory
            # XXX: This is kind of a hack to address the fact that
            # "memory" is a default attribute in our Vagrant driver.
            #
            # The VMware VMX format expects to see "memsize" instead of
            # just "memory" like Virtualbox would. So if "memsize" has
            # been specified we simply ignore the "memory" option.
            unless config[:customize].include?(:memsize)
              arr << %{    p.vmx["memsize"] = "#{value}"}
            end
          else
            arr << %{    p.vmx["#{key}"] = "#{value}"}
          end
        end
      end

      def rackspace_customize(arr)
        config[:customize].each do |key, value|
          arr << %{    p.#{key} = "#{value}"}
        end
      end

      def key_path
        return nil if instance.suite.encrypted_data_bag_secret_key_path.nil?

        File.join(
          config[:kitchen_root],
          instance.suite.encrypted_data_bag_secret_key_path
        )
      end
    end
  end
end
