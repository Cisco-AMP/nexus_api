require 'lib/setup_api'

RSpec.describe NexusAPI do
  describe 'Status Endpoint' do
    include_context 'setup NexusAPI::API'

    describe '#status' do
      it 'sends :get status to the NexusConnection instance' do
        expect(api.connection).to receive(:get).with(endpoint: 'status')
        api.status
      end
    end

    describe '#status_writable' do
      it 'sends :get status writable to the NexusConnection instance' do
        expect(api.connection).to receive(:get).with(endpoint: 'status/writable')
        api.status_writable
      end
    end
  end
end