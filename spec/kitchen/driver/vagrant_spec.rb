require 'kitchen/driver/vagrant'
require 'yaml'

module Kitchen

  module Driver

    class Testable < Kitchen::Driver::Vagrant

      def initialize(config, ssh_config = {})
        super(config)
        @ssh_config = ssh_config
      end

      def create(state)
        set_state(state)
      end

      protected

      def vagrant_ssh_config
        @ssh_config
      end

      def refresh_forwarded_port(state)
      end
    end
  end
end

describe Kitchen::Driver::Vagrant do
  let(:vagrant_ssh_config) {{
    'Port' => 22,
    'HostName' => "hostname",
    'User' => "user",
    'IdentityFile' => "key"
  }}

  subject do
    parsed = Kitchen::Util.symbolized_hash(YAML.load(yaml))
    transport = parsed[:transport][:name]
    instance = double(
      transport: Kitchen::Transport.for_plugin(transport, parsed),
      logger: Logger.new(STDOUT)
    )
    driver = Kitchen::Driver::Testable.new(parsed[:driver], vagrant_ssh_config)
    driver.instance = instance
    driver
  end

  context "using ssh" do
    let(:vagrant_ssh_config) {{
      'Port' => 8888,
      'HostName' => "hostname",
      'User' => "user",
      'IdentityFile' => "key"
    }}
    let(:yaml) do
      <<-EOS
        transport:
          name: ssh
        driver:
          box: mybox
      EOS
    end

    it "uses ssh_config from vagrant" do
      state = {}
      subject.create(state)

      expect(state[:port]).to eq 8888
    end
  end

  context "using winrm" do
    context "forwarding to default guest port" do
      let(:yaml) do
        <<-EOS
          transport:
            name: winrm
          driver:
            box: mybox
            network:
            - ["forwarded_port", {guest: 5985, host: 55985}]
        EOS
      end

      it "sets the port to the forwarded port" do
        state = {}
        subject.create(state)

        expect(state[:port]).to eq 55985
      end
    end

    context "using a custom port" do
      let(:yaml) do
        <<-EOS
          transport:
            name: winrm
          driver:
            box: mybox
            port: 9999
        EOS
      end

      it "sets the port to the custom port" do
        state = {}
        subject.create(state)

        expect(state[:port]).to eq 9999
      end
    end

    context "forwarding to a custom guest_port" do
      let(:yaml) do
        <<-EOS
          transport:
            name: winrm
          driver:
            box: mybox
            guest_port: 7777
            network:
            - ["forwarded_port", {guest: 7777, host: 33333}]
        EOS
      end

      it "sets the port to the forwarded port" do
        state = {}
        subject.create(state)

        expect(state[:port]).to eq 33333
      end
    end

    context "specifying a custom guest_port with no forwarding" do
      let(:yaml) do
        <<-EOS
          transport:
            name: winrm
          driver:
            box: mybox
            guest_port: 7777
        EOS
      end

      it "sets the port to the default port" do
        state = {}
        subject.create(state)

        expect(state[:port]).to eq 5985
      end
    end

    context "no network config" do
      let(:yaml) do
        <<-EOS
          transport:
            name: winrm
          driver:
            box: mybox
        EOS
      end

      it "sets the port to the default port" do
        state = {}
        subject.create(state)

        expect(state[:port]).to eq 5985
      end
    end
  end
end
