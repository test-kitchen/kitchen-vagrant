# -*- encoding: utf-8 -*-
ignore %r{^\.gem/}

def rubocop_opts
  { :all_on_start => false, :keep_failed => false, :cli => "-r finstyle" }
end

group :red_green_refactor, :halt_on_fail => true do
  guard :rubocop, rubocop_opts do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end
