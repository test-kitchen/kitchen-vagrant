# -*- encoding: utf-8 -*-
ignore %r{^\.gem/}

def rspec_opts
  { :cmd => "bundle exec rspec" }
end

def rubocop_opts
  { :all_on_start => false, :keep_failed => false, :cli => "-r finstyle" }
end

group :red_green_refactor, :halt_on_fail => true do
  guard :rspec, rspec_opts do
    watch(%r{^spec/(.*)_spec\.rb})
    watch(%r{^lib/(.*)([^/]+)\.rb})   { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^spec/spec_helper\.rb})  { "spec" }
  end

  guard :rubocop, rubocop_opts do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end
