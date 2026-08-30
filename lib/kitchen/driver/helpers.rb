#
# Author:: Steven Murawski <smurawski@chef.io>
# Copyright:: Copyright (c) 2015 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "base64" unless defined?(Base64)
require "mixlib/shellout" unless defined?(Mixlib::ShellOut)
require "fileutils" unless defined?(FileUtils)
require "json" unless defined?(JSON)

module Kitchen
  # Test Kitchen driver plugins.
  module Driver
    # Helpers for talking to Hyper-V from the Vagrant driver.
    #
    # Hyper-V has no command line interface of its own, so everything here
    # funnels through PowerShell: a script is wrapped so that it dot-sources
    # the bundled `support/hyperv.ps1`, base64-encoded for `-EncodedCommand`
    # (which sidesteps all shell quoting problems), executed, and its JSON
    # output parsed back into Ruby.
    #
    # The module expects to be mixed into a {Kitchen::Configurable} that also
    # provides {Kitchen::Logging}, which the Vagrant driver does.
    #
    # @author Steven Murawski <smurawski@chef.io>
    module HypervHelpers
      # Encodes a PowerShell script for `powershell.exe -EncodedCommand`.
      #
      # PowerShell requires UTF-16LE, not UTF-8, and strict (unwrapped) base64.
      #
      # @param script [String] a PowerShell script
      # @return [String] the script as single-line base64
      # @api private
      def encode_command(script)
        encoded_script = script.encode("UTF-16LE", "UTF-8")
        Base64.strict_encode64(encoded_script)
      end

      # The processor architecture Windows reports for this process.
      #
      # `PROCESSOR_ARCHITEW6432` is only set for a 32-bit process running under
      # WOW64, where it holds the *machine's* architecture while
      # `PROCESSOR_ARCHITECTURE` holds the emulated one -- so it wins when
      # present.
      #
      # @return [String,nil] e.g. `"AMD64"`, or nil off Windows
      # @api private
      def os_architecture
        ENV["PROCESSOR_ARCHITEW6432"] || ENV["PROCESSOR_ARCHITECTURE"]
      end

      # Whether the running Ruby is a 64-bit build, determined from the size of
      # a packed pointer.
      #
      # @return [true,false] whether this Ruby is 64-bit
      # @api private
      def ruby_64bit?
        ["foo"].pack("p").size != 4
      end

      # Whether both the OS and the running Ruby are 64-bit.
      #
      # @return [true,false] whether this is a 64-bit Ruby on a 64-bit Windows
      # @api private
      def is_64bit?
        os_architecture == "AMD64" && ruby_64bit?
      end

      # Whether both the OS and the running Ruby are 32-bit.
      #
      # Note this is deliberately *not* the negation of {#is_64bit?}: a 32-bit
      # Ruby on a 64-bit Windows (the WOW64 case) is neither.
      #
      # @return [true,false] whether this is a 32-bit Ruby on a 32-bit Windows
      # @api private
      def is_32bit?
        os_architecture != "AMD64" && !ruby_64bit?
      end

      # Path to a PowerShell that matches the machine's architecture.
      #
      # When Ruby and Windows agree on bitness, the real `System32` PowerShell
      # is correct. When they disagree -- a 32-bit Ruby on 64-bit Windows --
      # `System32` would be silently redirected by WOW64 to the 32-bit
      # PowerShell, which cannot see the Hyper-V cmdlets; `Sysnative` is the
      # alias that reaches the 64-bit one.
      #
      # @return [String] absolute path to powershell.exe
      # @api private
      def powershell_64_bit
        if is_64bit? || is_32bit?
          'c:\windows\system32\windowspowershell\v1.0\powershell.exe'
        else
          'c:\windows\sysnative\windowspowershell\v1.0\powershell.exe'
        end
      end

      # Builds a full `powershell.exe` command line that dot-sources the gem's
      # `support/hyperv.ps1` helper functions and then runs `script`.
      #
      # @param script [String] a PowerShell script
      # @return [String] a command line ready to hand to a shell
      # @api private
      def wrap_command(script)
        base_script_path = File.join(File.dirname(__FILE__), "/../../../support/hyperv.ps1")
        debug("Loading functions from #{base_script_path}")
        new_script = [ ". #{base_script_path}", "#{script}" ].join(";\n")
        debug("Wrapped script: #{new_script}")
        "#{powershell_64_bit} -noprofile -executionpolicy bypass" \
        " -encodedcommand #{encode_command new_script} -outputformat Text"
      end

      # Convenience method to run a powershell command locally.
      #
      # @param cmd [String] command to run locally
      # @param options [Hash] options hash
      # @return [Hash,nil] the parsed JSON the script emitted, if any
      # @see Kitchen::ShellOut#run_command
      # @api private
      def run_ps(cmd, options = {})
        cmd = "echo #{cmd}" if config[:dry_run]
        debug("Preparing to run: ")
        debug("  #{cmd}")
        wrapped_command = wrap_command cmd
        execute_command wrapped_command, options
      end

      # Runs a command locally and parses its output as JSON.
      #
      # @param cmd [String] command to run locally
      # @param options [Hash] options passed through to `Mixlib::ShellOut`
      # @return [Hash,Array,nil] the parsed output, or nil if there was none
      # @raise [RuntimeError] if the command exited non-zero
      # @api private
      def execute_command(cmd, options = {})
        debug("#Local Command BEGIN (#{cmd})")
        sh = Mixlib::ShellOut.new(cmd, options)
        sh.run_command
        debug("Local Command END #{Util.duration(sh.execution_time)}")
        raise "Failed: #{sh.stderr}" if sh.error?

        stdout = sanitize_stdout(sh.stdout)
        JSON.parse(stdout) if stdout.length > 2
      end

      # Strips the interactive prompt lines PowerShell interleaves with real
      # output, which would otherwise make the result unparseable as JSON.
      #
      # @param stdout [String] raw standard output
      # @return [String] output with `PS ...>` lines removed
      # @api private
      def sanitize_stdout(stdout)
        stdout.split("\n").select { |s| !s.start_with?("PS") }.join("\n")
      end

      # Asks Hyper-V for the virtual switch new VMs should be attached to.
      #
      # @return [String] the name of the switch
      # @raise [RuntimeError] if no usable switch could be determined
      # @api private
      def hyperv_switch
        default_switch_object = run_ps hyperv_default_switch_ps
        if default_switch_object.nil? ||
            !default_switch_object.key?("Name") ||
            default_switch_object["Name"].empty?
          raise "Failed to find a default VM Switch."
        end

        default_switch_object["Name"]
      end

      # The PowerShell that {#hyperv_switch} runs. Honours
      # `KITCHEN_HYPERV_SWITCH`; without it, `Get-DefaultVMSwitch` picks one.
      #
      # @return [String] a PowerShell script emitting a JSON switch object
      # @api private
      def hyperv_default_switch_ps
        <<-VMSWITCH
          Get-DefaultVMSwitch #{ENV["KITCHEN_HYPERV_SWITCH"]} | ConvertTo-Json
        VMSWITCH
      end

      private

      # Renders a Ruby Array as a PowerShell array literal.
      #
      # @param list [Array,nil] the values to render
      # @return [String] e.g. `@("a", "b")`, or `@()` when empty
      # @api private
      def ruby_array_to_ps_array(list)
        return "@()" if list.nil? || list.empty?

        list.to_s.tr("[]", "()").prepend("@")
      end
    end
  end
end
