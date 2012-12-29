require "bundler/gem_tasks"
require 'cane/rake_task'
require 'tailor/rake_task'

desc "Run cane to check quality metrics"
Cane::RakeTask.new do |cane|
  cane.abc_exclude = %w(
    Jamie::Vagrant.define_vagrant_vm
  )
end

Tailor::RakeTask.new

desc "Display LOC stats"
task :stats do
  puts "\n## Production Code Stats"
  sh "countloc -r lib/jamie"
end

task :default => [ :cane, :tailor, :stats ]
