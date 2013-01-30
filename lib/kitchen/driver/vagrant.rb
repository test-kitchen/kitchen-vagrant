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

require 'kitchen'

module Kitchen

  module Driver

    # Vagrant driver for Kitchen. It communicates to Vagrant via the CLI.
    #
    # @author Fletcher Nichol <fnichol@nichol.ca>
    class Vagrant < Kitchen::Driver::SSHBase

      default_config :customize, {:memory => '256'}

      no_parallel_for :create, :destroy

      def create(state)
        # @todo Vagrantfile setup will be placed in any dependency hook
        #   checks when feature is released
        vagrantfile = File.join(config[:kitchen_root], "Vagrantfile")
        create_vagrantfile(vagrantfile) unless File.exists?(vagrantfile)

        state[:hostname] = instance.name
        run "vagrant up #{state[:hostname]} --no-provision"
        info("Vagrant instance <#{state[:hostname]}> created.")
      end

      def converge(state)
        run "vagrant provision #{state[:hostname]}"
      end

      def destroy(state)
        return if state[:hostname].nil?

        run "vagrant destroy #{state[:hostname]} -f"
        info("Vagrant instance <#{state[:hostname]}> destroyed.")
        state.delete(:hostname)
      end

      def login_command(state)
        %W{vagrant ssh #{state[:hostname]}}
      end

      protected

      def ssh(ssh_args, cmd)
        run %{vagrant ssh #{ssh_args.first} --command '#{cmd}'}
      end

      def run(cmd)
        cmd = "echo #{cmd}" if config[:dry_run]
        run_command(cmd)
      end

      def create_vagrantfile(vagrantfile)
        File.open(vagrantfile, "wb") { |f| f.write(vagrantfile_contents) }
      end

      def vagrantfile_contents
        arr = []
        arr << %{require 'kitchen/vagrant'}
        if File.exists?(File.join(config[:kitchen_root], "Berksfile"))
          arr << %{require 'berkshelf/vagrant'}
        end
        arr << %{}
        arr << %{Vagrant::Config.run do |config|}
        arr << %{  Kitchen::Vagrant.define_vms(config)}
        arr << %{end\n}
        arr.join("\n")
      end
    end
  end
end
