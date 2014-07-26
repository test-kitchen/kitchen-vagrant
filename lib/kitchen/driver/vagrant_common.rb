module Kitchen
  module Driver
    module VagrantCommon

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

        finalize_synced_folder_config

        vagrantfile = File.join(vagrant_root, "Vagrantfile")
        debug("Creating Vagrantfile for #{instance.to_str} (#{vagrantfile})")
        FileUtils.mkdir_p(vagrant_root)
        File.open(vagrantfile, "wb") { |f| f.write(render_template) }
        debug_vagrantfile(vagrantfile)
        @vagrantfile_created = true
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
        if File.exists?(template)
          ERB.new(IO.read(template)).result(binding).gsub(%r{^\s*$\n}, '')
        else
          raise ActionFailed, "Could not find Vagrantfile template #{template}"
        end
      end

      def template
        File.expand_path(config[:vagrantfile_erb], config[:kitchen_root])
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
