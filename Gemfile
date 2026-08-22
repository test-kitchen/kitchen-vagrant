source "https://rubygems.org"

# Specify your gem"s dependencies in kitchen-vagrant.gemspec
gemspec development_group: :test
group :test do
  gem "rake"
  gem "rspec", "~> 3.2"
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
