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

# Builds a fully wired `Kitchen::Driver::Vagrant` attached to a real
# `Kitchen::Instance`.
#
# Every collaborator is a real Test Kitchen object (the `Dummy` transport,
# provisioner and verifier ship with test-kitchen precisely for this), so the
# specs exercise the driver's genuine interaction with Kitchen rather than a
# hand-rolled imitation of it. The only thing stubbed by default is the shell:
# `#run_command` is intercepted per-example so nothing ever shells out.
RSpec.shared_context "vagrant driver" do
  let(:logged_output) { StringIO.new }
  let(:logger)        { Logger.new(logged_output) }
  let(:config)        { { kitchen_root: "/kroot" } }
  let(:platform)      { Kitchen::Platform.new(name: "fooos-99") }
  let(:suite)         { Kitchen::Suite.new(name: "suitey") }
  let(:verifier)      { Kitchen::Verifier::Dummy.new }
  let(:provisioner)   { Kitchen::Provisioner::Dummy.new }
  let(:transport)     { Kitchen::Transport::Dummy.new }
  let(:state)         { {} }
  let(:lifecycle_hooks) { Kitchen::LifecycleHooks.new(config, state) }
  let(:state_file)    { instance_double(Kitchen::StateFile) }
  let(:env)           { {} }

  let(:driver_object) { Kitchen::Driver::Vagrant.new(config) }

  # Instantiating the Instance is what triggers `finalize_config!` on the
  # driver, so anything that reads finalized config must reference `driver`
  # (not `driver_object`) to force that to have happened.
  let(:driver) do
    d = driver_object
    instance
    d
  end

  let(:driver_with_no_instance) { driver_object }

  let(:instance) do
    Kitchen::Instance.new(
      verifier: verifier,
      driver: driver_object,
      logger: logger,
      suite: suite,
      platform: platform,
      provisioner: provisioner,
      lifecycle_hooks: lifecycle_hooks,
      transport: transport,
      state_file: state_file
    )
  end

  # Commands the driver believed it was running, in order. Populated by
  # `stub_run_command!`.
  let(:run_commands) { [] }

  # Replaces the driver's shell-out with a recorder. Returns the recorded
  # command list. `responses` maps a Regexp (or String) matched against the
  # command to the stdout the fake shell should return.
  def stub_run_command!(responses = {})
    allow(driver).to receive(:run_command) do |cmd, _options = {}|
      run_commands << cmd
      _, output = responses.find { |pattern, _| pattern === cmd } # rubocop:disable Style/CaseEquality
      output.to_s
    end
    run_commands
  end

  # Pretends `vagrant --version` reported `version`. Stubbed on
  # `driver_object` because `verify_dependencies` may run before an Instance
  # is attached.
  def with_vagrant_version(version)
    allow(driver_object).to receive(:run_command)
      .with("vagrant --version", any_args).and_return("Vagrant #{version}")
  end

  def with_modern_vagrant
    with_vagrant_version("2.4.1")
  end

  def with_unsupported_vagrant
    with_vagrant_version("1.0.5")
  end

  # The lines the driver logged at `level`, with the logger preamble stripped.
  # Asserting on these instead of the raw log keeps failure output readable.
  def logged(level)
    preamble = /\A\w, \[[^\]]+\]\s+#{level.to_s.upcase} -- : /
    logged_output.string.lines.grep(preamble).map { |l| l.sub(preamble, "") }.join
  end

  def debug_lines
    logged(:debug)
  end

  # The environment is stubbed wholesale so that a developer's real
  # VAGRANT_* variables can never leak into an assertion.
  before { stub_const("ENV", env) }

  # `vagrant_version` memoizes onto the driver *class*, which would otherwise
  # bleed between examples.
  after { Kitchen::Driver::Vagrant.send(:vagrant_version=, nil) }
end

# Gives the driver a real, disposable :kitchen_root so the specs that genuinely
# touch the filesystem (create/destroy) do so somewhere safe.
RSpec.shared_context "with a real kitchen root" do
  include_context "vagrant driver"

  let(:kitchen_root) { @kitchen_root ||= Dir.mktmpdir("kitchen_root") }

  let(:vagrant_root) do
    File.join(kitchen_root, ".kitchen", "kitchen-vagrant", "suitey-fooos-99")
  end

  # The shell stubs live in the `driver` let rather than a `before` hook so
  # that referencing them does not force `finalize_config!` to run early --
  # examples must stay free to adjust `config` in their own body.
  let(:driver) do
    d = driver_object
    instance
    allow(d).to receive(:run_command).and_return("")
    with_modern_vagrant
    d
  end

  before { config[:kitchen_root] = kitchen_root }

  after do
    FileUtils.remove_entry_secure(@kitchen_root) if @kitchen_root && File.exist?(@kitchen_root)
  end
end
