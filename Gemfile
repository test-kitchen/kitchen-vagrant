source "https://rubygems.org"

# Specify your gem"s dependencies in kitchen-vagrant.gemspec
gemspec development_group: :test
group :test do
  gem "rake"
  gem "rspec", "~> 3.13"
  gem "simplecov", "~> 1.0", require: false
  gem "simplecov-lcov", "~> 0.8", require: false
end

group :docs do
  gem "yard", "~> 0.9"
end

group :integration do
  gem "cinc-auditor-bin", source: "https://rubygems.cinc.sh"
  gem "kitchen-cinc-auditor", git: "https://github.com/test-kitchen/kitchen-cinc-auditor.git"
end

group :debug do
  gem "pry"
end

group :cookstyle do
  gem "cookstyle"
end
