require 'nexus_api/cli_utils'
require 'nexus_api/cli_commands/script'
require 'lib/nexus_api/mock_cli_utils'

RSpec.describe NexusAPI::Script do
  before(:each) {
    @script = NexusAPI::Script.new
    @script.api = double
  }

  describe '#delete' do
    it 'sends the setup method from CLIUtils' do
      expect(@script).to receive(:setup)
      expect(@script.api).to receive(:delete_script)
      @script.delete
    end

    it 'sends the delete_script method to api' do
      expect(@script.api).to receive(:delete_script)
      @script.delete
    end

    it 'passes the flags set in Thor correctly to api' do
      name = 'script_name'
      expect(@script.api).to receive(:delete_script).with({ :name => name })
      flags = { :name => name }
      @script.options = flags
      @script.delete
    end
  end

  describe '#execute' do
    it 'sends the setup method from CLIUtils' do
      expect(@script).to receive(:setup)
      expect(@script.api).to receive(:run_script)
      @script.execute
    end

    it 'sends the run_script method to api' do
      expect(@script.api).to receive(:run_script)
      @script.execute
    end

    it 'passes the flags set in Thor correctly to api' do
      name = 'script_name'
      expect(@script.api).to receive(:run_script).with({ :name => name })
      flags = { :name => name }
      @script.options = flags
      @script.execute
    end
  end

  describe '#list' do
    describe 'with mock script' do
      let(:scripts) { [{'name' => 'script1'}] }
      before(:each) {
        expect(@script.api).to receive(:list_scripts).and_return(scripts)
      }

      it 'sends the list_scripts method to api' do
        @script.list
      end

      it 'prints the name of each script by default' do
        expect { @script.list }.to output("script1\n").to_stdout
      end

      it 'prints the full details of each script when the full option is set' do
        flags = {:full => true}
        @script.options = flags
        expect { @script.list }.to output("{\"name\"=>\"script1\"}\n").to_stdout
      end
    end

    it 'passes the flags set in Thor correctly to api' do
      expect(@script.api).to receive(:list_scripts).with(no_args)
      flags = { :full => true }
      @script.options = flags
      @script.list
    end
  end

  describe '#upload' do
    it 'sends the setup method from CLIUtils' do
      @script.options = {}
      expect(@script).to receive(:setup)
      expect(@script.api).to receive(:upload_script)
      @script.upload
    end

    it 'sends the upload_script method to api' do
      @script.options = {}
      expect(@script.api).to receive(:upload_script)
      @script.upload
    end

    it 'passes the flags set in Thor correctly to api' do
      filename = 'script_name'
      expect(@script.api).to receive(:upload_script).with({ :filename => filename })
      flags = { :filename => filename }
      @script.options = flags
      @script.upload
    end
  end

  describe 'component does not exist' do
    it 'catches Errno:ENOENT and returns a friendlier message' do
      file = 'fake_script_file'
      allow(@script.api).to receive(:upload_script).and_raise(Errno::ENOENT)
      @script.options = { :filename => file }
      failure_message = "Sending 'fake_script_file' to the 'scripts' repository in Nexus!\n'fake_script_file' does not exist locally.\n"
      expect { @script.upload }.to output(failure_message).to_stdout
    end
  end
end
