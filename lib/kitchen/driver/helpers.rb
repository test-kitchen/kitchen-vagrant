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

require "mixlib/shellout"
require "fileutils"
require "json"

module Kitchen
  module Driver
    module HypervHelpers
      def encode_command(script)
        encoded_script = script.encode("UTF-16LE", "UTF-8")
        Base64.strict_encode64(encoded_script)
      end

      def is_64bit?
        os_arch = ENV["PROCESSOR_ARCHITEW6432"] || ENV["PROCESSOR_ARCHITECTURE"]
        ruby_arch = ["foo"].pack("p").size == 4 ? 32 : 64
        os_arch == "AMD64" && ruby_arch == 64
      end

      def is_32bit?
        os_arch = ENV["PROCESSOR_ARCHITEW6432"] || ENV["PROCESSOR_ARCHITECTURE"]
        ruby_arch = ["foo"].pack("p").size == 4 ? 32 : 64
        os_arch != "AMD64" && ruby_arch == 32
      end

      def powershell_64_bit
        if is_64bit? || is_32bit?
          'c:\windows\system32\windowspowershell\v1.0\powershell.exe'
        else
          'c:\windows\sysnative\windowspowershell\v1.0\powershell.exe'
        end
      end

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
      # @see Kitchen::ShellOut.run_command
      # @api private
      def run_ps(cmd, options = {})
        cmd = "echo #{cmd}" if config[:dry_run]
        debug("Preparing to run: ")
        debug("  #{cmd}")
        wrapped_command = wrap_command cmd
        execute_command wrapped_command, options
      end

      def execute_command(cmd, options = {})
        debug("#Local Command BEGIN (#{cmd})")
        sh = Mixlib::ShellOut.new(cmd, options)
        sh.run_command
        debug("Local Command END #{Util.duration(sh.execution_time)}")
        raise "Failed: #{sh.stderr}" if sh.error?
        stdout = sanitize_stdout(sh.stdout)
        JSON.parse(stdout) if stdout.length > 2
      end

      def sanitize_stdout(stdout)
        stdout.split("\n").select { |s| !s.start_with?("PS") }.join("\n")
      end

      def hyperv_switch
        default_switch_object = run_ps hyperv_default_switch_ps
        if default_switch_object.nil? ||
            !default_switch_object.key?("Name") ||
            default_switch_object["Name"].empty?
          raise "Failed to find a default VM Switch."
        end
        default_switch_object["Name"]
      end

      def hyperv_default_switch_ps
        <<-VMSWITCH
          Get-DefaultVMSwitch #{ENV['KITCHEN_HYPERV_SWITCH']} | ConvertTo-Json
        VMSWITCH
      end

      private

      def ruby_array_to_ps_array(list)
        return "@()" if list.nil? || list.empty?
        list.to_s.tr("[]", "()").prepend("@")
      end
    end
  end
end
