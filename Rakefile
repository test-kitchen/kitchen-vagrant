require "bundler/gem_tasks"
require 'cane/rake_task'
require 'tailor/rake_task'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:test)

desc "Run cane to check quality metrics"
Cane::RakeTask.new

Tailor::RakeTask.new do |task|
  task.file_set('lib/**/*.rb', 'code')
end

desc "Display LOC stats"
task :stats do
  puts "\n## Production Code Stats"
  sh "countloc -r lib/kitchen"
end

desc "Run all quality tasks"
task :quality => [:cane, :tailor, :stats, :test]

task :default => [ :quality ]
