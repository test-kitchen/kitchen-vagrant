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

require "fileutils"
require "rubygems/version"

require "kitchen"

module Kitchen

  module Driver

    # Vagrant driver for Kitchen. It communicates to Vagrant via the CLI.
    #
    # @author Fletcher Nichol <fnichol@nichol.ca>
    class Vagrant < Kitchen::Driver::SSHBase

      default_config :box do |driver|
        "opscode-#{driver.instance.platform.name}"
      end
      required_config :box

      default_config :box_check_update, nil

      default_config(:box_url) { |driver| driver.default_box_url }

      default_config :box_version, nil

      default_config :customize, {}

      default_config :network, []

      default_config :pre_create_command, nil

      default_config :provision, false

      default_config :provider,
        ENV.fetch("VAGRANT_DEFAULT_PROVIDER", "virtualbox")

      default_config :ssh, {}

      default_config :synced_folders, []

      default_config :vagrantfile_erb,
        File.join(File.dirname(__FILE__), "../../../templates/Vagrantfile.erb")
      expand_path_for :vagrantfile_erb

      default_config :vagrantfiles, []

      default_config(:vm_hostname) { |driver| driver.instance.name }

      no_parallel_for :create, :destroy

      # Converges a running instance.
      #
      # @param state [Hash] mutable instance and driver state
      # @raise [ActionFailed] if the action could not be completed
      def converge(state)
        create_vagrantfile
        super
      end

      # Creates a Vagrant VM instance.
      #
      # @param state [Hash] mutable instance and driver state
      # @raise [ActionFailed] if the action could not be completed
      def create(state)
        create_vagrantfile
        run_pre_create_command
        cmd = "vagrant up"
        cmd += " --no-provision" unless config[:provision]
        cmd += " --provider=#{config[:provider]}" if config[:provider]
        run cmd
        update_ssh_state(state)
        info("Vagrant instance #{instance.to_str} created.")
      end

      # @return [String,nil] the Vagrant box URL for this Instance
      def default_box_url
        # No default neede for 1.5 onwards - Vagrant Cloud only needs a box name
        return if Gem::Version.new(vagrant_version) >= Gem::Version.new(1.5)

        bucket = config[:provider]
        bucket = "vmware" if config[:provider] =~ /^vmware_(.+)$/

        "https://opscode-vm-bento.s3.amazonaws.com/vagrant/#{bucket}/" \
          "opscode_#{instance.platform.name}_chef-provisionerless.box"
      end

      # Destroys an instance.
      #
      # @param state [Hash] mutable instance and driver state
      # @raise [ActionFailed] if the action could not be completed
      def destroy(state)
        return if state[:hostname].nil?

        create_vagrantfile
        @vagrantfile_created = false
        run "vagrant destroy -f"
        FileUtils.rm_rf(vagrant_root)
        info("Vagrant instance #{instance.to_str} destroyed.")
        state.delete(:hostname)
      end

      # A lifecycle method that should be invoked when the object is about
      # ready to be used. A reference to an Instance is required as
      # configuration dependant data may be access through an Instance. This
      # also acts as a hook point where the object may wish to perform other
      # last minute checks, validations, or configuration expansions.
      #
      # @param instance [Instance] an associated instance
      # @return [self] itself, for use in chaining
      # @raise [ClientError] if instance parameter is nil
      def finalize_config!(instance)
        super
        resolve_config!
        self
      end

      # Sets up an instance.
      #
      # @param state [Hash] mutable instance and driver state
      # @raise [ActionFailed] if the action could not be completed
      def setup(state)
        create_vagrantfile
        super
      end

      # Verifies a converged instance.
      #
      # @param state [Hash] mutable instance and driver state
      # @raise [ActionFailed] if the action could not be completed
      def verify(state)
        create_vagrantfile
        super
      end

      # Performs whatever tests that may be required to ensure that this driver
      # will be able to function in the current environment. This may involve
      # checking for the presence of certain directories, software installed,
      # etc.
      #
      # @raise [UserError] if the driver will not be able to perform or if a
      #   documented dependency is missing from the system
      def verify_dependencies
        if Gem::Version.new(vagrant_version) < Gem::Version.new(MIN_VER)
          raise UserError, "Detected an old version of Vagrant " \
            "(#{vagrant_version})." \
            " Please upgrade to version #{MIN_VER} or higher from #{WEBSITE}."
        end
      end

      protected

      WEBSITE = "http://www.vagrantup.com/downloads.html".freeze
      MIN_VER = "1.1.0".freeze

      def create_vagrantfile
        return if @vagrantfile_created

        finalize_synced_folder_config
        expand_vagrantfile_paths

        vagrantfile = File.join(vagrant_root, "Vagrantfile")
        debug("Creating Vagrantfile for #{instance.to_str} (#{vagrantfile})")
        FileUtils.mkdir_p(vagrant_root)
        File.open(vagrantfile, "wb") { |f| f.write(render_template) }
        debug_vagrantfile(vagrantfile)
        @vagrantfile_created = true
      end

      def debug_vagrantfile(vagrantfile)
        if logger.debug?
          debug("------------")
          IO.read(vagrantfile).each_line { |l| debug("#{l.chomp}") }
          debug("------------")
        end
      end

      def expand_vagrantfile_paths
        config[:vagrantfiles].map! do |vagrantfile|
          File.absolute_path(vagrantfile)
        end
      end

      def finalize_synced_folder_config
        config[:synced_folders].map! do |source, destination, options|
          [
            File.expand_path(
              source.gsub("%{instance_name}", instance.name),
              config[:kitchen_root]
            ),
            destination.gsub("%{instance_name}", instance.name),
            options || "nil"
          ]
        end
      end

      def render_template
        if File.exist?(template)
          ERB.new(IO.read(template)).result(binding).gsub(%r{^\s*$\n}, "")
        else
          raise ActionFailed, "Could not find Vagrantfile template #{template}"
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

      def run(cmd, options = {})
        cmd = "echo #{cmd}" if config[:dry_run]
        run_command(cmd, { :cwd => vagrant_root }.merge(options))
      end

      def run_pre_create_command
        if config[:pre_create_command]
          run(config[:pre_create_command], :cwd => config[:kitchen_root])
        end
      end

      def silently_run(cmd)
        run_command(cmd,
          :live_stream => nil, :quiet => logger.debug? ? false : true)
      end

      def template
        File.expand_path(config[:vagrantfile_erb], config[:kitchen_root])
      end

      def update_ssh_state(state)
        hash = vagrant_ssh_config

        state[:hostname] = hash["HostName"]
        state[:username] = hash["User"]
        state[:ssh_key] = hash["IdentityFile"]
        state[:port] = hash["Port"]
        state[:proxy_command] = hash["ProxyCommand"] if hash["ProxyCommand"]
      end

      def vagrant_root
        @vagrant_root ||= File.join(
          config[:kitchen_root], %w[.kitchen kitchen-vagrant],
          "kitchen-#{File.basename(config[:kitchen_root])}-#{instance.name}"
        )
      end

      def vagrant_ssh_config
        output = run("vagrant ssh-config", :live_stream => nil)
        lines = output.split("\n").map do |line|
          tokens = line.strip.partition(" ")
          [tokens.first, tokens.last.gsub(/"/, "")]
        end
        Hash[lines]
      end

      def vagrant_version
        @version ||= silently_run("vagrant --version").chomp.split(" ").last
      rescue Errno::ENOENT
        raise UserError, "Vagrant #{MIN_VER} or higher is not installed." \
          " Please download a package from #{WEBSITE}."
      end
    end
  end
end
