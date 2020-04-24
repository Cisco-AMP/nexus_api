require 'lib/setup_api'

RSpec.describe NexusAPI do
  describe 'Script Endpoint' do
    include_context 'setup NexusAPI::API'

    let(:script_endpoint) { 'script' }
    let(:script_name) { 'name' }

    describe '#list_scripts' do
      it 'sends :get_response from script to the NexusConnection instance' do
        expect(api.connection).to receive(:get_response).with(endpoint: script_endpoint)
        api.list_scripts
      end
    end

    describe '#upload_script' do
      before(:each) do
        allow(File).to receive(:read).and_return(script_name)
      end

      it 'sends :post script to the NexusConnection instance' do
        expect(api.connection).to receive(:post)
        api.upload_script(filename: script_name)
      end

      it 'takes a filename and passes the file contents as a parameter' do
        expect(api.connection).to receive(:post).with(endpoint: script_endpoint, parameters: script_name)
        api.upload_script(filename: script_name)
      end
    end

    describe '#delete_script' do
      it 'sends :delete script with a script name to the NexusConnection instance' do
        expect(api.connection).to receive(:delete).with(endpoint: "#{script_endpoint}/#{script_name}")
        api.delete_script(name: script_name)
      end
    end

    describe '#run_script' do
      it 'sends :post script run with a script name to the NexusConnection instance' do
        expect(api.connection).to receive(:post).with(endpoint: "#{script_endpoint}/#{script_name}/run", headers: instance_of(Hash))
        api.run_script(name: script_name)
      end

      it 'uses a Plaintext content type' do
        expect(api.connection).to receive(:post).with(endpoint: anything, headers: {'Content-Type' => 'text/plain'})
        api.run_script(name: script_name)
      end
    end
  end
end
