#
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
#
# Copyright (C) 2015, Fletcher Nichol
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

require "simplecov"
require "simplecov-lcov"

SimpleCov::Formatter::LcovFormatter.config do |c|
  c.report_with_single_file = true
  c.single_report_path = "coverage/lcov.info"
end

SimpleCov.start do
  add_filter %r{^/spec/}
  add_group "Driver", "lib/kitchen/driver"
  enable_coverage :branch
  minimum_coverage line: 100, branch: 95
  formatter SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::LcovFormatter,
    ]
  )
end

require "logger" unless defined?(Logger)
require "stringio" unless defined?(StringIO)
require "securerandom" unless defined?(SecureRandom)

require "kitchen"
require "kitchen/driver/vagrant"
require "kitchen/driver/helpers"
require "kitchen/provisioner/dummy"
require "kitchen/transport/dummy"
require "kitchen/verifier/dummy"

Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.max_formatted_output_length = 2_000
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    # Fail fast when a double stubs a method the real object does not have.
    mocks.verify_partial_doubles = true
  end

  # `describe` and friends are only available on `RSpec`, never on `main` or
  # `Module`. Keeps the global namespace clean.
  config.disable_monkey_patching!

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Every example reports all of its failed expectations, not just the first.
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true unless meta.key?(:aggregate_failures)
  end

  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/examples.txt"

  # Ruby warnings from our transitive dependencies drown out our own.
  config.warnings = false

  config.default_formatter = "doc" if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed

  # Deprecations are bugs waiting to happen; make them loud.
  config.raise_errors_for_deprecations!
end
