#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Matches a rendered Vagrantfile that contains `expected` as one or more
# complete lines, ignoring the leading indentation the ERb template emits.
#
#   expect(vagrantfile).to declare(%{c.vm.box = "bento/ubuntu-24.04"})
#
# Failure output prints the whole rendered file, because when a template
# assertion fails what you always want to see next is what was actually
# rendered.
RSpec::Matchers.define :declare do |expected|
  def normalize(text)
    text.to_s.lines.map(&:rstrip).reject(&:empty?).map(&:strip)
  end

  match do |actual|
    haystack = normalize(actual)
    needle = normalize(expected)
    haystack.each_cons([needle.size, 1].max).include?(needle)
  end

  failure_message do |actual|
    "expected the Vagrantfile to declare:\n\n#{expected}\n\nbut it rendered as:\n\n#{actual}"
  end

  failure_message_when_negated do |actual|
    "expected the Vagrantfile not to declare:\n\n#{expected}\n\nbut it rendered as:\n\n#{actual}"
  end
end

# Renders the Vagrantfile template in isolation.
#
# The old specs drove `driver.create(state)` end to end just to read the file
# it wrote to a temp dir. Rendering `render_template` directly keeps template
# specs pure: no filesystem, no fake `vagrant up`, no transport handshake --
# only config in, Vagrantfile out.
RSpec.shared_context "renders a Vagrantfile" do
  include_context "vagrant driver"

  subject(:vagrantfile) { driver.send(:render_template) }
end
