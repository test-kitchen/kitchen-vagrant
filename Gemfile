source "https://rubygems.org"

# Specify your gem"s dependencies in kitchen-vagrant.gemspec
gemspec

if ENV['CHEF_TEST_KITCHEN_ENTERPRISE']
  gem "chef-test-kitchen-enterprise", git: "https://github.com/chef/test-kitchen", branch: "main"
end

group :test do
  gem "rake"
  gem "kitchen-inspec"
  gem "rspec", "~> 3.2"
end

group :debug do
  gem "pry"
end

group :cookstyle do
  gem "cookstyle"
end
