require 'kitchen/provider/virtualbox/machine'

class DummyShellOut
  attr_accessor :data
  def stdout
    data
  end
end

describe Kitchen::Provider::VirtualBox::Machine do
  let(:uuid) { "19262da0-4890-4f58-9fab-954e379dac15"}
  let(:vagrant_root) {
    File.join(File.expand_path(__FILE__), %w{.kitchen kitchen-vagrant},
          "kitchen-dummy-instance"
        )
  }

  context "providing a non existing vm" do
    context "using vagrant_root" do
      let(:machine) do
        Kitchen::Provider::VirtualBox::Machine.new(vagrant_root)
      end

      it "will raise a RuntimeError" do
        expect{machine}.to raise_error(
          RuntimeError,
          'Missing Virtual Box Machine. Run `kitchen create` and retry.'
        )
      end
    end

    context "using uuid" do
      let(:machine) do
        Kitchen::Provider::VirtualBox::Machine.new(vagrant_root, uuid)
      end

      it "will raise an exception" do
        expect{machine}.to raise_error
      end
    end
  end

  context "providing an existing vm" do
    before do
      allow_any_instance_of(Kitchen::Provider::VirtualBox::Machine)
        .to receive(:exists?)
        .and_return(true)
    end
    let(:machine) do
      Kitchen::Provider::VirtualBox::Machine.new(vagrant_root, uuid)
    end
    let(:port_data) do
      dummy_shellout = DummyShellOut.new
      dummy_shellout.data = [
        'nic1="nat"', 'nic2="none"', 'nic3="none"', 'nic4="none"',
        'Forwarding(0)="other,tcp,127.0.0.1,4321,,1234"',
        'Forwarding(0)="ssh,tcp,127.0.0.1,2222,,22"',
        'Forwarding(0)="rdp,tcp,127.0.0.1,9999,,3389"',
        'Forwarding(0)="winrm,tcp,127.0.0.1,55986,,5986"',
      ].join("\n")
      dummy_shellout
    end

    it "creates a machine object" do
      expect(machine.class).to be Kitchen::Provider::VirtualBox::Machine
    end

    it "validate execute method works" do
      # Mock get_vboxmanage_path to be empty and run plain commands
      allow(machine).to receive(:get_vboxmanage_path).and_return('')
      shellout = machine.execute('echo', 'This', 'works', 'awesome')
      expect(shellout.exitstatus).to eq 0
      expect(shellout.stdout).to eq "This works awesome\n"
    end

    context "validating host_port" do
      before do
        allow_any_instance_of(Kitchen::Provider::VirtualBox::Machine)
          .to receive(:execute)
          .with('showvminfo', uuid, '--machinereadable')
          .and_return(port_data)
      end

      context "with a SSH port" do
        let(:port) { 22 }
        it "provide the actual forwarded_port" do
          expect(machine.host_port(port)).to eq 2222
        end
      end

      context "with a WINRM port" do
        let(:port) { 5986 }
        it "provide the actual forwarded_port" do
          expect(machine.host_port(port)).to eq 55986
        end
      end

      context "with a RDP port" do
        let(:port) { 3389 }
        it "provide the actual forwarded_port" do
          expect(machine.host_port(port)).to eq 9999
        end
      end
    end
  end
end
