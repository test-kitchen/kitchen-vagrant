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

require 'jamie'

module Jamie

  module Driver

    # Vagrant driver for Jamie. It communicates to Vagrant via the CLI.
    #
    # @author Fletcher Nichol <fnichol@nichol.ca>
    class Vagrant < Jamie::Driver::SSHBase

      default_config 'memory', '256'

      def create(instance, state)
        state['hostname'] = instance.name
        run_command "vagrant up #{state['hostname']} --no-provision"
      end

      def converge(instance, state)
        run_command "vagrant provision #{state['hostname']}"
      end

      def destroy(instance, state)
        return if state['hostname'].nil?

        run_command "vagrant destroy #{state['hostname']} -f"
        state.delete('hostname')
      end

      protected

      def load_state(instance)
        vagrantfile = File.join(config['jamie_root'], "Vagrantfile")
        create_vagrantfile(vagrantfile) unless File.exists?(vagrantfile)
        super
      end

      def ssh(ssh_args, cmd)
        run_command %{vagrant ssh #{ssh_args.first} --command '#{cmd}'}
      end

      def create_vagrantfile(vagrantfile)
        File.open(vagrantfile, "wb") { |f| f.write(vagrantfile_contents) }
      end

      def vagrantfile_contents
        arr = []
        arr << %{require 'jamie/vagrant'}
        if File.exists?(File.join(config['jamie_root'], "Berksfile"))
          arr << %{require 'berkshelf/vagrant'}
        end
        arr << %{}
        arr << %{Vagrant::Config.run do |config|}
        arr << %{  Jamie::Vagrant.define_vms(config)}
        arr << %{end\n}
        arr.join("\n")
      end
    end
  end
end
