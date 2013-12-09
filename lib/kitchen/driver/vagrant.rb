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

module Kitchen

  module Driver

    # Vagrant driver for Kitchen. It communicates to Vagrant via the CLI.
    #
    # @author Fletcher Nichol <fnichol@nichol.ca>
    #
    # @todo Vagrant installation check and version will be placed into any
    #   dependency hook checks when feature is released
    class Vagrant < Kitchen::Driver::SSHBase

      default_config :customize, { :memory => '256' }
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
        set_ssh_state(state)
        info("Vagrant instance #{instance.to_str} created.")
      end

      def converge(state)
        create_vagrantfile
        super
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

      def run_pre_create_command
        if config[:pre_create_command]
          run(config[:pre_create_command], :cwd => config[:kitchen_root])
        end
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
        File.open(vagrantfile, "wb") { |f| f.write(render_template) }
        debug_vagrantfile(vagrantfile)
        @vagrantfile_created = true
      end

      def render_template
        if File.exists?(template)
          ERB.new(IO.read(template)).result(binding).gsub(%r{^\s*$\n}, '')
        else
          raise ActionFailed, "Could not find Vagrantfile template #{template}"
        end
      end

      def template
        File.expand_path(config[:vagrantfile_erb], config[:kitchen_root])
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

      def debug_vagrantfile(vagrantfile)
        if logger.debug?
          debug("------------")
          IO.read(vagrantfile).each_line { |l| debug("#{l.chomp}") }
          debug("------------")
        end
      end

      def resolve_config!
        unless config[:vagrantfile_erb].nil?
          config[:vagrantfile_erb] =
            File.expand_path(config[:vagrantfile_erb], config[:kitchen_root])
        end
        unless config[:pre_create_command].nil?
          config[:pre_create_command] =
            config[:pre_create_command].gsub("{{vagrant_root}}", vagrant_root)
        end
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
    end
  end
end
