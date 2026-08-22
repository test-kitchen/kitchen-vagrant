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

RSpec.describe "Kitchen::Driver::VAGRANT_VERSION" do
  subject(:version) { Kitchen::Driver::VAGRANT_VERSION }

  # release-please rewrites this constant, and the gemspec reads it to set the
  # gem version -- so it has to stay parseable by RubyGems.
  it "is a valid RubyGems version" do
    expect { Gem::Version.new(version) }.not_to raise_error
  end

  it "is frozen, since it is shared by every driver instance" do
    expect(version).to be_frozen
  end

  it "matches the version release-please tracks in its manifest" do
    manifest = JSON.parse(File.read(File.expand_path("../../../.release-please-manifest.json", __dir__)))

    expect(manifest["."]).to eq(version)
  end
end
