# Chef InSpec test for kitchen-vagrant

# The Chef InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

user_name = os.windows? ? "Administrator" : "root"
describe user(user_name) do
  it { should exist }
end
