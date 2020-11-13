require "bundler/gem_tasks"

require "rspec/core/rake_task"
desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/**/*_spec.rb"
end

desc "Run all test suites"
task test: [:spec]

require "chefstyle"
require "rubocop/rake_task"
RuboCop::RakeTask.new(:style) do |task|
  task.options << "--display-cop-names"
end

desc "Run all quality tasks"
task quality: %i{style stats}

task default: %i{test quality}
