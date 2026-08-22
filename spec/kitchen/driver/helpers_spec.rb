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

require "base64"
require "open3"

# HypervHelpers is only ever mixed into the Vagrant driver, so it is exercised
# through the driver rather than through a synthetic host class.
RSpec.describe Kitchen::Driver::HypervHelpers do
  include_context "vagrant driver"

  subject(:helpers) { driver }

  describe "#encode_command" do
    # This spec file requires "base64" so it can decode assertions, which would
    # mask a missing require in the library itself. Loading the library in a
    # pristine subprocess is the only honest way to check that it declares its
    # own dependencies -- and since Ruby 3.4, base64 is a bundled gem that is
    # not loaded for you.
    it "works in a process where nothing else has loaded base64" do
      script = <<~RUBY
        require "kitchen/driver/helpers"
        klass = Class.new { include Kitchen::Driver::HypervHelpers }
        print klass.new.encode_command("Get-VMSwitch")
      RUBY
      output, status = Open3.capture2e(RbConfig.ruby, "-I", File.expand_path("../../../lib", __dir__), "-e", script)

      expect(status).to be_success, "expected the library to load base64 itself, got:\n#{output}"
      expect(output).to eq("Get-VMSwitch".encode("UTF-16LE").then { |s| Base64.strict_encode64(s) })
    end

    it "base64-encodes the script as UTF-16LE, which is what -EncodedCommand expects" do
      encoded = helpers.encode_command("Get-VMSwitch")

      expect(Base64.strict_decode64(encoded).force_encoding("UTF-16LE"))
        .to eq("Get-VMSwitch".encode("UTF-16LE"))
    end

    it "produces base64 without embedded newlines" do
      long_script = "Get-VMSwitch -Name #{"a" * 200}"

      expect(helpers.encode_command(long_script)).not_to include("\n")
    end

    it "round-trips non-ASCII characters" do
      encoded = helpers.encode_command("Write-Output 'café'")

      expect(Base64.strict_decode64(encoded).force_encoding("UTF-16LE").encode("UTF-8"))
        .to eq("Write-Output 'café'")
    end
  end

  describe "#is_64bit?" do
    it "is true when the OS reports AMD64 and Ruby is 64-bit" do
      env["PROCESSOR_ARCHITECTURE"] = "AMD64"
      allow(helpers).to receive(:ruby_64bit?).and_return(true)

      expect(helpers.is_64bit?).to be(true)
    end

    it "prefers PROCESSOR_ARCHITEW6432, which is set for WOW64 processes" do
      env["PROCESSOR_ARCHITEW6432"] = "AMD64"
      env["PROCESSOR_ARCHITECTURE"] = "x86"
      allow(helpers).to receive(:ruby_64bit?).and_return(true)

      expect(helpers.is_64bit?).to be(true)
    end

    it "is false for a 32-bit Ruby on a 64-bit OS" do
      env["PROCESSOR_ARCHITECTURE"] = "AMD64"
      allow(helpers).to receive(:ruby_64bit?).and_return(false)

      expect(helpers.is_64bit?).to be(false)
    end

    it "is false when the architecture is unknown" do
      allow(helpers).to receive(:ruby_64bit?).and_return(true)

      expect(helpers.is_64bit?).to be(false)
    end
  end

  describe "#is_32bit?" do
    it "is true for a 32-bit Ruby on a non-AMD64 OS" do
      env["PROCESSOR_ARCHITECTURE"] = "x86"
      allow(helpers).to receive(:ruby_64bit?).and_return(false)

      expect(helpers.is_32bit?).to be(true)
    end

    it "is false for a 32-bit Ruby on a 64-bit OS, which is the WOW64 case" do
      env["PROCESSOR_ARCHITECTURE"] = "AMD64"
      allow(helpers).to receive(:ruby_64bit?).and_return(false)

      expect(helpers.is_32bit?).to be(false)
    end

    it "is false for a 64-bit Ruby" do
      env["PROCESSOR_ARCHITECTURE"] = "x86"
      allow(helpers).to receive(:ruby_64bit?).and_return(true)

      expect(helpers.is_32bit?).to be(false)
    end
  end

  describe "#powershell_64_bit" do
    it "uses System32 when the Ruby and OS bitness agree" do
      env["PROCESSOR_ARCHITECTURE"] = "AMD64"
      allow(helpers).to receive(:ruby_64bit?).and_return(true)

      expect(helpers.powershell_64_bit)
        .to eq('c:\windows\system32\windowspowershell\v1.0\powershell.exe')
    end

    it "uses Sysnative for a 32-bit Ruby on a 64-bit OS so it reaches the 64-bit PowerShell" do
      env["PROCESSOR_ARCHITECTURE"] = "AMD64"
      allow(helpers).to receive(:ruby_64bit?).and_return(false)

      expect(helpers.powershell_64_bit)
        .to eq('c:\windows\sysnative\windowspowershell\v1.0\powershell.exe')
    end
  end

  describe "#wrap_command" do
    before { env["PROCESSOR_ARCHITECTURE"] = "AMD64" }

    it "invokes PowerShell with a non-interactive, policy-bypassing, text-output command line" do
      wrapped = helpers.wrap_command("Get-VMSwitch")

      expect(wrapped).to start_with('c:\windows\system32\windowspowershell\v1.0\powershell.exe')
      expect(wrapped).to include("-noprofile")
      expect(wrapped).to include("-executionpolicy bypass")
      expect(wrapped).to include("-outputformat Text")
    end

    it "dot-sources the bundled hyperv.ps1 before the caller's script" do
      wrapped = helpers.wrap_command("Get-VMSwitch")
      encoded = wrapped[/-encodedcommand (\S+)/, 1]
      script = Base64.strict_decode64(encoded).force_encoding("UTF-16LE").encode("UTF-8")

      expect(script).to match(%r{\A\. \S+support/hyperv\.ps1;\nGet-VMSwitch\z})
    end

    it "points at a hyperv.ps1 that actually ships with the gem" do
      wrapped = helpers.wrap_command("Get-VMSwitch")
      encoded = wrapped[/-encodedcommand (\S+)/, 1]
      script = Base64.strict_decode64(encoded).force_encoding("UTF-16LE").encode("UTF-8")
      path = script[/\A\. (\S+hyperv\.ps1)/, 1]

      expect(File).to exist(path)
    end
  end

  describe "#run_ps" do
    before { env["PROCESSOR_ARCHITECTURE"] = "AMD64" }

    it "wraps the script and hands it to the command executor" do
      allow(helpers).to receive(:execute_command).and_return("name" => "Default Switch")

      helpers.run_ps("Get-VMSwitch")

      expect(helpers).to have_received(:execute_command)
        .with(a_string_including("-encodedcommand"), {})
    end

    it "passes options straight through to the executor" do
      allow(helpers).to receive(:execute_command)

      helpers.run_ps("Get-VMSwitch", cwd: "/somewhere")

      expect(helpers).to have_received(:execute_command)
        .with(anything, { cwd: "/somewhere" })
    end

    it "echoes rather than executes under :dry_run" do
      config[:dry_run] = true
      executed = nil
      allow(helpers).to receive(:execute_command) { |cmd, _| executed = cmd }

      helpers.run_ps("Get-VMSwitch")

      encoded = executed[/-encodedcommand (\S+)/, 1]
      script = Base64.strict_decode64(encoded).force_encoding("UTF-16LE").encode("UTF-8")

      expect(script).to end_with("echo Get-VMSwitch")
    end
  end

  describe "#execute_command" do
    let(:shell) { instance_double(Mixlib::ShellOut, run_command: nil, execution_time: 0.5) }

    before { allow(Mixlib::ShellOut).to receive(:new).and_return(shell) }

    it "parses the command's JSON output" do
      allow(shell).to receive_messages(error?: false, stdout: %({"Name":"Default Switch"}))

      expect(helpers.execute_command("whatever")).to eq("Name" => "Default Switch")
    end

    it "returns nil when the command produced no meaningful output" do
      allow(shell).to receive_messages(error?: false, stdout: "\n")

      expect(helpers.execute_command("whatever")).to be_nil
    end

    it "raises with stderr when the command fails" do
      allow(shell).to receive_messages(error?: true, stderr: "Get-VMSwitch : Access denied")

      expect { helpers.execute_command("whatever") }
        .to raise_error(RuntimeError, /Access denied/)
    end

    it "forwards options to Mixlib::ShellOut" do
      allow(shell).to receive_messages(error?: false, stdout: "")

      helpers.execute_command("whatever", timeout: 90)

      expect(Mixlib::ShellOut).to have_received(:new).with("whatever", { timeout: 90 })
    end
  end

  describe "#sanitize_stdout" do
    it "drops the PowerShell prompt lines that pollute captured output" do
      raw = "PS C:\\Users\\vagrant> Get-VMSwitch\n{\"Name\":\"Default Switch\"}\nPS C:\\Users\\vagrant>"

      expect(helpers.sanitize_stdout(raw)).to eq(%({"Name":"Default Switch"}))
    end

    it "leaves prompt-free output untouched" do
      expect(helpers.sanitize_stdout("{\"a\":1}\n{\"b\":2}")).to eq("{\"a\":1}\n{\"b\":2}")
    end

    it "handles empty output" do
      expect(helpers.sanitize_stdout("")).to eq("")
    end
  end

  describe "#hyperv_switch" do
    it "returns the name of the default switch" do
      allow(helpers).to receive(:run_ps).and_return("Name" => "Default Switch")

      expect(helpers.hyperv_switch).to eq("Default Switch")
    end

    it "raises when PowerShell returned nothing" do
      allow(helpers).to receive(:run_ps).and_return(nil)

      expect { helpers.hyperv_switch }.to raise_error(/Failed to find a default VM Switch/)
    end

    it "raises when the returned object has no Name" do
      allow(helpers).to receive(:run_ps).and_return("Id" => "abc")

      expect { helpers.hyperv_switch }.to raise_error(/Failed to find a default VM Switch/)
    end

    it "raises when the switch name is blank" do
      allow(helpers).to receive(:run_ps).and_return("Name" => "")

      expect { helpers.hyperv_switch }.to raise_error(/Failed to find a default VM Switch/)
    end
  end

  describe "#hyperv_default_switch_ps" do
    it "asks for JSON so the result can be parsed" do
      expect(helpers.hyperv_default_switch_ps).to include("ConvertTo-Json")
    end

    it "passes KITCHEN_HYPERV_SWITCH through when the user pinned a switch" do
      env["KITCHEN_HYPERV_SWITCH"] = "External VM Switch"

      expect(helpers.hyperv_default_switch_ps).to include("Get-DefaultVMSwitch External VM Switch")
    end

    it "asks for whatever the helper script considers the default when unpinned" do
      expect(helpers.hyperv_default_switch_ps).to match(/Get-DefaultVMSwitch\s+\|/)
    end
  end

  describe "#ruby_array_to_ps_array" do
    it "renders an empty PowerShell array for nil" do
      expect(helpers.send(:ruby_array_to_ps_array, nil)).to eq("@()")
    end

    it "renders an empty PowerShell array for an empty list" do
      expect(helpers.send(:ruby_array_to_ps_array, [])).to eq("@()")
    end

    it "renders a populated PowerShell array" do
      expect(helpers.send(:ruby_array_to_ps_array, %w{a b})).to eq(%{@("a", "b")})
    end
  end
end
