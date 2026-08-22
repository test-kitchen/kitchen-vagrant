require "bundler/gem_tasks"

require "rspec/core/rake_task"
desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = "spec/**/*_spec.rb"
end

begin
  require "cookstyle"
  require "rubocop/rake_task"
  # Chefstyle is applied via `inherit_gem` in .rubocop.yml rather than the
  # `--chefstyle` flag, which current Cookstyle releases no longer accept.
  RuboCop::RakeTask.new(:style) do |task|
    task.options += ["--display-cop-names", "--no-color"]
  end
rescue LoadError
  puts "cookstyle is not available. (sudo) gem install cookstyle to do style checking."
end

begin
  require "yard"

  YARD::Rake::YardocTask.new(:docs) do |t|
    t.stats_options = ["--list-undoc"]
  end

  namespace :docs do
    desc "Report YARD documentation coverage without generating docs"
    task :coverage do
      sh "yard stats --list-undoc"
    end

    desc "Generate docs and serve them at http://localhost:8808"
    task :serve do
      sh "yard server --reload"
    end

    desc "Remove generated documentation"
    task :clean do
      rm_rf "doc"
      rm_rf ".yardoc"
    end
  end
rescue LoadError
  puts "yard is not available. (sudo) gem install yard to generate documentation."
end

# Documentation is intentionally not part of the default task: it must never
# be able to fail a build. Run `rake docs` (or `rake docs:coverage`) directly.
task default: %i{test style}
