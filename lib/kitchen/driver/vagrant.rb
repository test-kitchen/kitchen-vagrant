# -*- encoding: utf-8 -*-
#
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
#
# Copyright (C) 2012, Fletcher Nichol
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

require 'kitchen'
require 'kitchen/vagrant/vagrantfile_creator'

module Kitchen

  module Driver

    # Vagrant driver for Kitchen. It communicates to Vagrant via the CLI.
    #
    # @author Fletcher Nichol <fnichol@nichol.ca>
    #
    # @todo Vagrant installation check and version will be placed into any
    #   dependency hook checks when feature is released
    class Vagrant < Kitchen::Driver::SSHBase

      default_config :customize, {:memory => '256'}

      no_parallel_for :create, :destroy

      def create(state)
        state[:hostname] = instance.name
        create_vagrantfile(state)
        run "vagrant up --no-provision"
        info("Vagrant instance <#{state[:hostname]}> created.")
      end

      def converge(state)
        create_vagrantfile(state)
        ssh_args = build_ssh_args(state)
        install_omnibus(ssh_args) if config[:require_chef_omnibus]
        run "vagrant provision"
      end

      def setup(state)
        create_vagrantfile(state)
        super
      end

      def verify(state)
        create_vagrantfile(state)
        super
      end

      def destroy(state)
        return if state[:hostname].nil?

        create_vagrantfile(state)
        run "vagrant destroy -f"
        FileUtils.rm_rf(vagrant_root)
        info("Vagrant instance <#{state[:hostname]}> destroyed.")
        state.delete(:hostname)
      end

      def login_command(state)
        create_vagrantfile(state)
        LoginCommand.new(%W{vagrant ssh}, :chdir => vagrant_root)
      end

      protected

      def ssh(ssh_args, cmd)
        run %{vagrant ssh --command '#{cmd}'}
      end

      def run(cmd)
        cmd = "echo #{cmd}" if config[:dry_run]
        run_command(cmd, :cwd => vagrant_root)
      end

      def vagrant_root
        @vagrant_root ||= File.join(
          config[:kitchen_root], %w{.kitchen kitchen-vagrant}, instance.name
        )
      end

      def create_vagrantfile(state)
        return if @vagrantfile_created

        vagrantfile = File.join(vagrant_root, "Vagrantfile")
        debug("Creating Vagrantfile for <#{state[:hostname]}> (#{vagrantfile})")
        FileUtils.mkdir_p(vagrant_root)
        File.open(vagrantfile, "wb") { |f| f.write(creator.render) }
        @vagrantfile_created = true
      end

      def creator
        Kitchen::Vagrant::VagrantfileCreator.new(instance, config)
      end
    end
  end
end
