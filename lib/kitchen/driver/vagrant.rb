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

require "erb" unless defined?(Erb)
require "fileutils" unless defined?(FileUtils)
require "rubygems/version"
# :nocov:
# Chefstyle's Chef/Ruby/UnlessDefinedRequire wants this guard, but the guard's
# other branch is unreachable: kitchen has already loaded "time" by here. The
# repo enforces a branch-coverage floor, so exclude the line rather than let
# the two rules fight.
require "time" unless defined?(Time.now.iso8601)
# :nocov:

require "kitchen"
require_relative "vagrant_version"
require_relative "helpers"

module Kitchen

  module Driver

    # Vagrant driver for Kitchen. It communicates to Vagrant via the CLI.
    #
    # @author Fletcher Nichol <fnichol@nichol.ca>
    class Vagrant < Kitchen::Driver::Base
      # Machine states Vagrant reports for a box that is up and reachable.
      #
      # @return [Array<String>]
      LIVE_STATES = %w{running}.freeze

      include ShellOut
      include Kitchen::Driver::HypervHelpers

      kitchen_driver_api_version 2

      plugin_version Kitchen::Driver::VAGRANT_VERSION

      default_config(:box, &:default_box)
      required_config :box

      default_config :box_check_update, nil

      default_config :box_auto_update, nil

      default_config :box_auto_prune, nil

      default_config :box_download_insecure, nil

      default_config :box_download_ca_cert, nil

      default_config(:box_url, &:default_box_url)

      default_config :box_version, nil

      default_config :box_arch, nil

      default_config :boot_timeout, nil

      default_config :customize, {}

      default_config :gui, nil

      default_config :linked_clone, nil

      default_config :network, []

      default_config :pre_create_command, nil

      default_config :provision, false

      default_config :provider do |_|
        ENV.fetch("VAGRANT_DEFAULT_PROVIDER", "virtualbox")
      end

      default_config :ssh, {}

      default_config :synced_folders, []

      default_config :env, []

      default_config :use_cached_chef_client, false

      default_config :vagrant_binary, "vagrant"

      default_config :vagrantfile_erb,
        File.join(File.dirname(__FILE__), "../../../templates/Vagrantfile.erb")
      expand_path_for :vagrantfile_erb

      default_config :vagrantfiles, []
      expand_path_for :vagrantfiles

      default_config(:vm_hostname) do |driver|
        driver.windows_os? ? nil : "#{driver.instance.name}.vagrantup.com"
      end

      default_config(:cache_directory) do |driver|
        driver.windows_os? ? "/omnibus/cache" : "/tmp/omnibus/cache"
      end

      # for use with vagrant on WSL
      user_home = ENV["VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH"].nil? ? "~" : ENV["VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH"]

      default_config :kitchen_cache_directory,
        File.expand_path("#{user_home}/.kitchen/cache")

      default_config :cachier, nil

      no_parallel_for :create, :destroy

      # Creates a Vagrant VM instance.
      #
      # @param state [Hash] mutable instance state
      # @raise [ActionFailed] if the action could not be completed
      def create(state)
        create_vagrantfile
        run_pre_create_command
        check_box_outdated
        run_box_auto_update
        run_box_auto_prune
        run_vagrant_up
        update_state(state)
        instance.transport.connection(state).wait_until_ready
        info("Vagrant instance #{instance.to_str} created.")
      end

      # The box this Instance should use when the user has not named one.
      #
      # Platforms the Bento project builds are mapped onto their `bento/`
      # box; anything else is assumed to name a box directly.
      #
      # @return [String,nil] the Vagrant box for this Instance
      def default_box
        if bento_box?(instance.platform.name)
          "bento/#{instance.platform.name}"
        else
          instance.platform.name
        end
      end

      # The box URL this Instance should use when the user has not named one.
      #
      # Always nil: modern Vagrant resolves boxes through Vagrant Cloud, so an
      # explicit URL is only needed for privately hosted boxes.
      #
      # @return [String,nil] the Vagrant box URL for this Instance
      def default_box_url
        nil
      end

      # Destroys an instance.
      #
      # @param state [Hash] mutable instance state
      # @raise [ActionFailed] if the action could not be completed
      def destroy(state)
        return if state[:hostname].nil?

        create_vagrantfile
        @vagrantfile_created = false
        instance.transport.connection(state).close
        run("#{config[:vagrant_binary]} destroy -f")
        FileUtils.rm_rf(vagrant_root)
        info("Vagrant instance #{instance.to_str} destroyed.")
        state.delete(:hostname)
      end

      # Packages a created instance into a redistributable `.box` file in the
      # current working directory, then destroys the instance.
      #
      # @param state [Hash] mutable instance state
      # @raise [UserError] if the instance has not been created
      # @raise [ActionFailed] if the action could not be completed
      def package(state)
        if state[:hostname].nil?
          raise UserError, "Vagrant instance not created!"
        end

        unless config[:ssh] && config[:ssh][:insert_key] == false
          m = "Disable vagrant ssh key replacement to preserve the default key!"
          warn(m)
        end
        instance.transport.connection(state).close
        box_name = File.join(Dir.pwd, instance.name + ".box")
        run("#{config[:vagrant_binary]} package --output #{box_name}")
        destroy(state)
      end

      # Reports what Vagrant currently thinks of the machine.
      #
      # @param state [Hash] instance state naming the machine
      # @return [Hash] a Test Kitchen status hash, or the base implementation's
      #   answer when there is nothing to ask Vagrant about
      def status(state)
        return super unless state[:hostname]

        machine_state = vagrant_machine_state
        return super unless machine_state

        {
          live: LIVE_STATES.include?(machine_state),
          state: machine_state,
          source: "driver",
          resource_id: instance.name,
          message: "Vagrant reports the machine as #{machine_state}",
          checked_at: Time.now.utc.iso8601,
        }
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
        finalize_vm_hostname!
        finalize_box_auto_update!
        finalize_box_auto_prune!
        finalize_pre_create_command!
        finalize_synced_folders!
        finalize_ca_cert!
        finalize_network!
        self
      end

      # Performs whatever tests that may be required to ensure that this driver
      # will be able to function in the current environment. This may involve
      # checking for the presence of certain directories, software installed,
      # etc.
      #
      # @raise [UserError] if the driver will not be able to perform or if a
      #   documented dependency is missing from the system
      def verify_dependencies
        super
        if Gem::Version.new(vagrant_version) < Gem::Version.new(MIN_VER.dup)
          raise UserError, "Detected an old version of Vagrant " \
            "(#{vagrant_version})." \
            " Please upgrade to version #{MIN_VER} or higher from #{WEBSITE}."
        end
      end

      # @return [TrueClass,FalseClass] whether or not the transport's name
      #   implies a WinRM-based transport
      # @api private
      def winrm_transport?
        instance.transport.name.downcase =~ /win_?rm/
      end

      # The guest-side directory that the host's omnibus package cache should
      # be shared into, so repeated converges do not re-download packages.
      #
      # @return [String,false] the guest path, or false if caching does not
      #   apply to this box and provider combination
      def cache_directory
        if enable_cache?
          config[:cache_directory]
        else
          false
        end
      end

      protected

      # Where users are pointed when Vagrant is missing or too old.
      WEBSITE = "https://developer.hashicorp.com/vagrant/install".freeze

      # The oldest Vagrant this driver supports.
      MIN_VER = "2.4.0".freeze

      class << self
        # @return [String] the version of Vagrant installed on the workstation
        # @api private
        attr_accessor :vagrant_version
      end

      # Returns whether or not a platform name could have a corresponding Bento
      # box produced by the Bento project.
      # (https://github.com/chef/bento).
      #
      # @param name [String] a Test Kitchen platform name
      # @return [TrueClass,FalseClass] whether or not the name could be a Bento
      #   box
      # @api private
      def bento_box?(name)
        name =~ /^(centos|debian|fedora|freebsd|opensuse|ubuntu|oracle|oraclelinux|hardenedbsd|amazonlinux|almalinux|rockylinux|springdalelinux)-/
      end

      # Returns whether or not the we expect the box to work with shared folders
      # by matching against a whitelist of bento boxes.
      #
      # Providers without usable shared folder support are excluded outright,
      # whatever the box.
      #
      # @param box [String] the Vagrant box name
      # @return [TrueClass,FalseClass] whether or not the box should work with
      #   shared folders
      # @api private
      def safe_share?(box)
        return false if /(hyperv|libvirt|qemu|utm)/.match?(config[:provider])

        box =~ %r{^bento/(centos|debian|fedora|opensuse|ubuntu|oracle|oraclelinux|amazonlinux|almalinux|rockylinux|springdalelinux)-}
      end

      # Return true if we found the criteria to enable the cache_directory
      # functionality.
      #
      # @return [TrueClass,FalseClass] whether the package cache should be
      #   shared into the guest
      # @api private
      def enable_cache?
        return false unless config[:cache_directory]
        return true if safe_share?(config[:box])
        return true if config[:use_cached_chef_client]

        # Otherwise
        false
      end

      # Renders and writes out a Vagrantfile dedicated to this instance. A
      # no-op if this action has already written one.
      #
      # @return [void]
      # @api private
      def create_vagrantfile
        return if @vagrantfile_created

        vagrantfile = File.join(vagrant_root, "Vagrantfile")
        debug("Creating Vagrantfile for #{instance.to_str} (#{vagrantfile})")
        FileUtils.mkdir_p(vagrant_root)
        File.open(vagrantfile, "wb") { |f| f.write(render_template) }
        debug_vagrantfile(vagrantfile)
        @vagrantfile_created = true
      end

      # Logs the Vagrantfile's contents to the debug log level.
      #
      # @param vagrantfile [String] path to the Vagrantfile
      # @return [void]
      # @api private
      def debug_vagrantfile(vagrantfile)
        return unless logger.debug?

        debug("------------")
        IO.read(vagrantfile).each_line { |l| debug("#{l.chomp}") }
        debug("------------")
      end

      # Expands `:box_download_ca_cert` relative to the kitchen root, so a
      # `.kitchen.yml` can refer to a cert alongside itself.
      #
      # @return [void]
      # @api private
      def finalize_ca_cert!
        unless config[:box_download_ca_cert].nil?
          config[:box_download_ca_cert] = File.expand_path(
            config[:box_download_ca_cert], config[:kitchen_root]
          )
        end
      end

      # Replaces a truthy `:box_auto_update` with the `vagrant box update`
      # command line that {#run_box_auto_update} should run. A falsey value is
      # left alone so that `box_auto_update: false` stays disabled.
      #
      # @return [void]
      # @api private
      def finalize_box_auto_update!
        return unless config[:box_auto_update]

        cmd = "#{config[:vagrant_binary]} box update --box #{config[:box]}"
        cmd += " --architecture #{config[:box_arch]}" if config[:box_arch]
        cmd += " --provider #{config[:provider]}" if config[:provider]
        cmd += " --insecure" if config[:box_download_insecure]
        config[:box_auto_update] = cmd
      end

      # Replaces a truthy `:box_auto_prune` with the `vagrant box prune`
      # command line that {#run_box_auto_prune} should run. A falsey value is
      # left alone so that `box_auto_prune: false` stays disabled.
      #
      # @return [void]
      # @api private
      def finalize_box_auto_prune!
        return unless config[:box_auto_prune]

        cmd = "#{config[:vagrant_binary]} box prune --force --keep-active-boxes --name #{config[:box]}"
        cmd += " --provider #{config[:provider]}" if config[:provider]
        config[:box_auto_prune] = cmd
      end

      # Replaces any `{{vagrant_root}}` tokens in the pre create command.
      #
      # @api private
      def finalize_pre_create_command!
        return if config[:pre_create_command].nil?

        config[:pre_create_command] = config[:pre_create_command]
          .gsub("{{vagrant_root}}", vagrant_root)
      end

      # Formats synced folder options for use in the Vagrantfile.
      # Accepts either a Hash (converts to Ruby hash syntax) or a String (returns as-is).
      # Supports SMB options like smb_username, smb_password, etc.
      #
      # @param options [Hash, String, nil] synced folder options
      # @return [String] formatted options string for Vagrantfile
      # @api private
      def format_synced_folder_options(options)
        return "nil" if options.nil?
        return options if options.is_a?(String)

        # Convert Hash to Ruby hash literal syntax
        if options.is_a?(Hash)
          options.map { |k, v| "#{k}: #{v.inspect}" }.join(", ")
        else
          options.to_s
        end
      end

      # Formats network options for use in the Vagrantfile.
      #
      # Accepts either a Hash (rendered as Ruby keyword syntax) or a String
      # (passed through as-is, which is what {#finalize_network!} produces).
      #
      # @param options [Hash,String,#to_s] network options
      # @return [String] formatted options string for Vagrantfile
      # @api private
      def format_network_options(options)
        return options if options.is_a?(String)
        return options.map { |k, v| "#{k}: #{v.inspect}" }.join(", ") if options.is_a?(Hash)

        options.to_s
      end

      # Normalises every `:synced_folders` entry: expands the host path
      # against the kitchen root, substitutes `%{instance_name}` tokens, and
      # formats the options for the template.
      #
      # @return [void]
      # @api private
      def finalize_synced_folders!
        config[:synced_folders] = config[:synced_folders]
          .map do |source, destination, options|
            [
              File.expand_path(
                source.gsub("%{instance_name}", instance.name),
                config[:kitchen_root]
              ),
              destination.gsub("%{instance_name}", instance.name),
              format_synced_folder_options(options),
            ]
          end
        add_extra_synced_folders!
      end

      # Shares the host's omnibus package cache into the guest so a converge
      # does not re-download packages it already has.
      #
      # @return [void]
      # @api private
      def add_extra_synced_folders!
        if cache_directory
          FileUtils.mkdir_p(local_kitchen_cache)
          config[:synced_folders].push([
            local_kitchen_cache,
            cache_directory,
            "create: true",
          ])
        end
      end

      # Truncates an over-long `:vm_hostname` on Windows guests, where the
      # NetBIOS name is capped at 15 characters. The final character of the
      # original is kept as a suffix so that names which differ only in their
      # tail do not collapse onto each other.
      #
      # @return [void]
      # @api private
      def finalize_vm_hostname!
        string = config[:vm_hostname]

        if windows_os? && string.is_a?(String) && string.size > 15
          config[:vm_hostname] = "#{string[0...12]}-#{string[-1]}"
        end
      end

      # Gives a Hyper-V instance a default `public_network` bridged onto the
      # switch named by `KITCHEN_HYPERV_SWITCH`, or whichever switch
      # {HypervHelpers#hyperv_switch} considers best. Instances that already
      # configure a network, and every other provider, are left alone.
      #
      # @return [void]
      # @api private
      def finalize_network!
        return unless config[:provider] == "hyperv" && config[:network].empty?

        # Deliberately a new Array rather than a push: `default_config` hands
        # every instance the *same* Array object, so mutating it in place would
        # leak this network into every other instance in the process.
        config[:network] = [["public_network", %{bridge: "#{hyperv_switch}"}]]
      end

      # Renders the Vagrantfile ERb template.
      #
      # @return [String] the contents for a Vagrantfile
      # @raise [ActionFailed] if the Vagrantfile template was not found
      # @api private
      def render_template
        template = File.expand_path(
          config[:vagrantfile_erb], config[:kitchen_root]
        )

        if File.exist?(template)
          ERB.new(IO.read(template)).result(binding).gsub(/^\s*$\n/, "")
        else
          raise ActionFailed, "Could not find Vagrantfile template #{template}"
        end
      end

      # Asks Vagrant for the machine state.
      #
      # `--machine-readable` is parsed rather than the human output because the
      # human wording is localised and reworded between Vagrant releases, while
      # the machine format is a stable comma-separated
      # `timestamp,target,type,data` and the `state` row carries the raw value
      # (`running`, `poweroff`, `not_created`, ...).
      #
      # @return [String, nil] the machine state, or nil when there is no
      #   Vagrantfile to ask about, the command fails, or no state row is found
      # @api private
      def vagrant_machine_state
        return nil unless File.exist?(File.join(vagrant_root, "Vagrantfile"))

        output = run("#{config[:vagrant_binary]} status --machine-readable")
        parse_machine_state(output)
      rescue ::StandardError => e
        debug("Could not read the Vagrant machine state: #{e.message}")
        nil
      end

      # Pulls the `state` row out of Vagrant's machine-readable output.
      #
      # @param output [String] the raw `--machine-readable` output
      # @return [String, nil] the state value, or nil when no state row is present
      # @api private
      def parse_machine_state(output)
        output.to_s.each_line do |line|
          fields = line.strip.split(",")
          return fields[3] if fields[2] == "state" && fields[3]
        end
        nil
      end

      # Convenience method to run a command locally.
      #
      # @param cmd [String] command to run locally
      # @param options [Hash] options hash
      # @see Kitchen::ShellOut.run_command
      # @api private
      def run(cmd, options = {})
        cmd = "echo #{cmd}" if config[:dry_run]
        run_command(cmd, { cwd: vagrant_root }.merge(options))
      end

      # Delegates to Kitchen::ShellOut.run_command, overriding some default
      # options:
      #
      # * `:use_sudo` defaults to the value of `config[:use_sudo]` in the
      #   Driver object
      # * `:log_subject` defaults to a String representation of the Driver's
      #   class name
      #
      # Since vagrant does not support being run through bundler, we escape
      # any bundler environment should we detect one.  Otherwise, subcommands
      # will inherit our bundled environment.
      # @see https://github.com/test-kitchen/kitchen-vagrant/issues/190
      # @param cmd [String] command to run locally
      # @param options [Hash] options hash
      # @return [String] the standard output of the command
      # @see Kitchen::ShellOut#run_command
      # rubocop:disable Metrics/CyclomaticComplexity
      def run_command(cmd, options = {})
        merged = {
          use_sudo: config[:use_sudo],
          log_subject: name,
          environment: {},
        }.merge(options)

        # Attempt to extract bundler and associated GEM related values.
        # TODO: To this accurately, we'd need to create a test-kitchen
        # launch wrapper that serializes the existing environment before
        # bundler touches it so that we can go back to it. Since that is
        # "A Hard Problem"(TM), we simply blow away all known bundler
        # related changes.
        env = merged[:environment]
        %w{BUNDLE_BIN_PATH BUNDLE_GEMFILE GEM_HOME GEM_PATH GEM_ROOT RUBYLIB
           RUBYOPT _ORIGINAL_GEM_PATH}.each do |var|
             env[var] = nil
           end

        # Altering the path seems to break vagrant. When the :environment
        # is passed to a windows process with a PATH, Vagrant's batch installer
        # (https://github.com/mitchellh/vagrant-installers/blob/master/substrate
        # /modules/vagrant_installer/templates/windows_vagrant.bat.erb)
        # does not effectively prepend the vagrant ruby path in a persistent
        # manner which causes vagrant to use the same ruby as test-kitchen and
        # then the environment is essentially corrupted leading to many errors
        # and despair
        unless windows_host?
          gem_home = ENV["GEM_HOME"]
          if gem_home && (env["PATH"] || ENV["PATH"])
            env["PATH"] ||= ENV["PATH"].dup if ENV["PATH"]
            gem_bin = File.join(gem_home, "bin") + File::PATH_SEPARATOR
            env["PATH"][gem_bin] = "" if env["PATH"].include?(gem_bin)
          end
        end

        super(cmd, merged)
      end
      # rubocop:enable Metrics/CyclomaticComplexity

      # Check if a newer version of the vagrant box is available and warn the
      # user. Skipped when `:box_auto_update` is on, since the update happens
      # regardless.
      #
      # @return [void]
      # @api private
      def check_box_outdated
        # Skip if box_auto_update is enabled (they'll get the update anyway)
        return if config[:box_auto_update]

        cmd = "#{config[:vagrant_binary]} box outdated --box #{config[:box]}"
        cmd += " --provider #{config[:provider]}" if config[:provider]

        begin
          output = run_silently(cmd)
          warn_if_outdated(output)
        rescue Kitchen::ShellOut::ShellCommandFailed => e
          # If the box isn't installed yet or there's an error checking, silently continue
          # This can happen on first run before the box is downloaded
          debug("Unable to check if box is outdated: #{e.message}")
        end
      end

      # Parse vagrant box outdated output and warn if a new version is available
      #
      # @param output [String] output from vagrant box outdated command
      # @return [void]
      # @api private
      def warn_if_outdated(output)
        return unless box_is_outdated?(output)

        current_version = extract_current_version(output)
        latest_version = extract_latest_version(output)

        warning_msg = "A new version of the '#{config[:box]}' box is available!"
        if current_version && latest_version
          warning_msg += " Current: #{current_version}, Latest: #{latest_version}."
        end
        warning_msg += " Run `vagrant box update --box #{config[:box]}` to update."

        warn(warning_msg)
      end

      # Check if the vagrant box outdated output indicates an outdated box
      #
      # @param output [String] output from vagrant box outdated command
      # @return [Boolean] true if box is outdated
      # @api private
      def box_is_outdated?(output)
        # Check for various output patterns indicating an outdated box
        # Use include? instead of complex regexes to avoid ReDoS vulnerabilities
        output_downcase = output.downcase
        output_downcase.include?("is outdated") ||
          output_downcase.include?("newer version") && output_downcase.include?("available") ||
          output_downcase.include?("newer version of the box")
      end

      # Characters that may legitimately appear inside a box version. Vagrant
      # quotes versions in prose ("version '202401.31.0'.") and separates them
      # with punctuation in tabular output ("Current: 1.2.3, Latest: 4.5.6"),
      # so the version has to end on an alphanumeric to avoid swallowing the
      # trailing quote, comma or full stop.
      VERSION_PATTERN = /v?(\w[\w.+-]*\w|\w)/

      # Extract current version from vagrant box outdated output
      #
      # @param output [String] output from vagrant box outdated command
      # @return [String, nil] current version or nil if not found
      # @api private
      def extract_current_version(output)
        extract_version(output, /Current:\s+/i, /currently have version\s+'?/i)
      end

      # Extract latest version from vagrant box outdated output
      #
      # @param output [String] output from vagrant box outdated command
      # @return [String, nil] latest version or nil if not found
      # @api private
      def extract_latest_version(output)
        extract_version(output, /Latest:\s+/i, /latest is version\s+'?/i)
      end

      # Finds the first version number that follows any of the given prefixes.
      #
      # @param output [String] output from vagrant box outdated command
      # @param prefixes [Array<Regexp>] prefixes to look for, in priority order
      # @return [String, nil] the version, or nil if no prefix matched
      # @api private
      def extract_version(output, *prefixes)
        prefixes.each do |prefix|
          match = output.match(/#{prefix.source}#{VERSION_PATTERN.source}/i)
          return match[1] if match
        end
        nil
      end

      # Runs the `vagrant box update` command built by
      # {#finalize_box_auto_update!}, if any.
      #
      # A box that has never been downloaded cannot be updated; that specific
      # failure is expected on a first run and is swallowed.
      #
      # @return [void]
      # @raise [Kitchen::ShellOut::ShellCommandFailed] for any other failure
      # @api private
      def run_box_auto_update
        if config[:box_auto_update]
          begin
            run(config[:box_auto_update])
          rescue Kitchen::ShellOut::ShellCommandFailed => e
            # If the box has never been downloaded, the update command will fail with this message.
            # Just ignore it and move on. Re-raise all other errors.
            raise e unless e.message.match?(/The box '.*' does not exist/m)
          end
        end
      end

      # Runs the `vagrant box prune` command built by
      # {#finalize_box_auto_prune!}, if any.
      #
      # @return [void]
      # @api private
      def run_box_auto_prune
        if config[:box_auto_prune]
          run(config[:box_auto_prune])
        end
      end

      # Runs `:pre_create_command`, if set, from the kitchen root -- before
      # `vagrant up`, so it can prepare anything the Vagrantfile depends on.
      #
      # @return [void]
      # @api private
      def run_pre_create_command
        if config[:pre_create_command]
          run(config[:pre_create_command], cwd: config[:kitchen_root])
        end
      end

      # Runs a local command without streaming the stdout to the logger.
      #
      # @param cmd [String] command to run locally
      # @param options [Hash] options hash
      # @return [String] the standard output of the command
      # @api private
      def run_silently(cmd, options = {})
        merged = {
          live_stream: nil, quiet: (logger.debug? ? false : true)
        }.merge(options)
        run(cmd, merged)
      end

      # Runs the `vagrant up` command locally.
      #
      # @return [void]
      # @api private
      def run_vagrant_up
        cmd = "#{config[:vagrant_binary]} up"
        cmd += " --no-provision" unless config[:provision]
        cmd += " --provider #{config[:provider]}" if config[:provider]
        run(cmd)
      end

      # Records the connection details Vagrant reports for the new machine
      # into the instance state, so the transport can reach it.
      #
      # @param state [Hash] mutable instance state
      # @return [void]
      # @api private
      def update_state(state)
        hash = winrm_transport? ? vagrant_config(:winrm) : vagrant_config(:ssh)

        state[:hostname] = hash["HostName"]
        state[:port] = hash["Port"]
        state[:username] = hash["User"]
        state[:password] = hash["Password"] if hash["Password"]
        state[:ssh_key] = hash["IdentityFile"] if hash["IdentityFile"]
        state[:proxy_command] = hash["ProxyCommand"] if hash["ProxyCommand"]
        state[:rdp_port] = hash["RDPPort"] if hash["RDPPort"]
      end

      # @return [String] full absolute path to the kitchen cache directory
      # @api private
      def local_kitchen_cache
        @local_kitchen_cache ||= config[:kitchen_cache_directory]
      end

      # @return [String] full local path to the directory containing the
      #   instance's Vagrantfile
      # @api private
      def vagrant_root
        if !@vagrant_root && !instance.nil?
          @vagrant_root = File.join(
            config[:kitchen_root], %w{.kitchen kitchen-vagrant},
            "#{instance.name}"
          )
        end
        @vagrant_root
      end

      # @return [true,false] whether or not we're running in WSL
      # @api private
      def wsl?
        # Check for WSL via environment variables
        return true if ENV["WSL_DISTRO_NAME"]
        return true if ENV["VAGRANT_WSL_ENABLE_WINDOWS_ACCESS"]

        # Check for WSL via /proc/version
        if File.exist?("/proc/version")
          version_content = File.read("/proc/version")
          return true if version_content.match?(/microsoft|wsl/i)
        end

        false
      rescue
        false
      end

      # Converts a Windows path to a WSL path
      # @param path [String] Windows path (e.g., "C:/Users/...")
      # @return [String] WSL path (e.g., "/mnt/c/users/...")
      # @api private
      def windows_to_wsl_path(path)
        # Only convert if it looks like a Windows path
        if path.match?(%r{^[A-Za-z]:/})
          # Convert C:/path to /mnt/c/path
          path.gsub(/^([A-Za-z]):/, '/mnt/\1').downcase
        else
          path
        end
      end

      # @param type [Symbol] either `:ssh` or `:winrm`
      # @return [Hash] key/value pairs resulting from parsing a
      #   `vagrant ssh-config` or `vagrant winrm-config` local command
      #   invocation
      # @api private
      def vagrant_config(type)
        lines = run_silently("#{config[:vagrant_binary]} #{type}-config")
          .split("\n").map do |line|
            tokens = line.strip.partition(" ")
            value = tokens.last.delete('"')
            # Convert Windows paths to WSL paths when running in WSL
            value = windows_to_wsl_path(value) if wsl? && tokens.first == "IdentityFile"
            [tokens.first, value]
          end
        Hash[lines]
      end

      # @return [String] version of Vagrant
      # @raise [UserError] if the `vagrant` command can not be found locally
      # @api private
      def vagrant_version
        self.class.vagrant_version ||= run_silently(
          "#{config[:vagrant_binary]} --version", cwd: Dir.pwd
        )
          .chomp.split(" ").last
      rescue Errno::ENOENT
        raise UserError, "Vagrant #{MIN_VER} or higher is not installed." \
          " Please download a package from #{WEBSITE}."
      end

      # @return [true,false] whether or not the host is windows
      #
      # @api private
      def windows_host?
        RbConfig::CONFIG["host_os"] =~ /mswin|mingw/
      end
    end
  end
end
