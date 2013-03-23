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
        network_block(arr)
        provider_block(arr)
        chef_block(arr)
        berkshelf_block(arr)
        arr << %{end}
        arr.join("\n")
      end

      private

      attr_reader :instance, :config

      def common_block(arr)
        arr << %{  c.vm.box = "#{config[:box]}"}
        arr << %{  c.vm.box_url = "#{config[:box_url]}"} if config[:box_url]
        arr << %{  c.vm.hostname = "#{instance.name}.vagrantup.com"}
      end

      def network_block(arr)
        Array(config[:network]).each do |network_options|
          options = Array(network_options.dup)
          type = options.shift
          arr << %{  c.vm.network(:#{type}, #{options.join(", ")})}
        end
      end

      def provider_block(arr)
        arr << %{  c.vm.provider :virtualbox do |p|}
          config[:customize].each do |key, value|
            arr << %{    p.customize ["modifyvm", :id, "--#{key}", #{value}]}
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
        if instance.suite.roles_path
          arr << %{    chef.roles_path = "#{instance.suite.roles_path}"}
        end
        arr << %{  end}
      end

      def berkshelf_block(arr)
        if File.exists?(berksfile)
          arr << %{  c.berkshelf.berksfile_path = "#{berksfile}"}
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
    end
  end
end
