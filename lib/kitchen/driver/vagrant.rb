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
require 'rubygems/version'

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

      required_config :box

      no_parallel_for :create, :destroy

      def create(state)
        create_vagrantfile
        run "vagrant up --no-provision"
        set_ssh_state(state)
        info("Vagrant instance #{instance.to_str} created.")
      end

      def converge(state)
        create_vagrantfile
        ssh_args = build_ssh_args(state)
        install_omnibus(ssh_args) if config[:require_chef_omnibus]
        run "vagrant provision"
      end

      def setup(state)
        create_vagrantfile
        super
      end

      def verify(state)
        create_vagrantfile
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
        check_berkshelf_plugin
      end

      protected

      WEBSITE = "http://downloads.vagrantup.com/"
      MIN_VER = "1.1.0"

      def run(cmd, options = {})
        cmd = "echo #{cmd}" if config[:dry_run]
        run_command(cmd, { :cwd => vagrant_root }.merge(options))
      end

      def silently_run(cmd)
        run_command(cmd,
          :live_stream => nil, :quiet => logger.debug? ? false : true)
      end

      def vagrant_root
        @vagrant_root ||= File.join(
          config[:kitchen_root], %w{.kitchen kitchen-vagrant}, instance.name
        )
      end

      def create_vagrantfile
        return if @vagrantfile_created

        vagrantfile = File.join(vagrant_root, "Vagrantfile")
        debug("Creating Vagrantfile for #{instance.to_str} (#{vagrantfile})")
        FileUtils.mkdir_p(vagrant_root)
        File.open(vagrantfile, "wb") { |f| f.write(creator.render) }
        @vagrantfile_created = true
      end

      def creator
        Kitchen::Vagrant::VagrantfileCreator.new(instance, config)
      end

      def set_ssh_state(state)
        hash = vagrant_ssh_config

        state[:hostname] = hash["HostName"]
        state[:username] = hash["User"]
        state[:ssh_key] = hash["IdentityFile"]
        state[:port] = hash["Port"]
      end

      def vagrant_ssh_config
        output = run("vagrant ssh-config", :live_stream => nil)
        lines = output.split("\n").map do |line|
          tokens = line.strip.partition(" ")
          [tokens.first, tokens.last.gsub(/"/, '')]
        end
        Hash[lines]
      end

      def vagrant_version
        version_string = silently_run("vagrant --version")
        version_string = version_string.chomp.split(" ").last
      rescue Errno::ENOENT
        raise UserError, "Vagrant #{MIN_VER} or higher is not installed." +
          " Please download a package from #{WEBSITE}."
      end

      def check_vagrant_version
        version = vagrant_version
        if Gem::Version.new(version) < Gem::Version.new(MIN_VER)
          raise UserError, "Detected an old version of Vagrant (#{version})." +
            " Please upgrade to version #{MIN_VER} or higher from #{WEBSITE}."
        end
      end

      def check_berkshelf_plugin
        if File.exists?(File.join(config[:kitchen_root], "Berksfile"))
          plugins = silently_run("vagrant plugin list").split("\n")
          if ! plugins.find { |p| p =~ /^vagrant-berkshelf\b/ }
            raise UserError, "Detected a Berksfile but the vagrant-berkshelf" +
              " plugin was not found in Vagrant. Please run:" +
              " `vagrant plugin install vagrant-berkshelf' and retry."
          end
        end
      end
    end
  end
end
