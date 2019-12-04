require 'lib/setup_api'

RSpec.describe NexusAPI do
  describe 'Repositories Endpoint' do
    include_context 'setup NexusAPI::API'

    describe '#list_repositories' do
      it 'sends :get_response from repositories to the NexusConnection instance' do
        expect(api.connection).to receive(:get_response).with(endpoint: 'repositories')
        api.list_repositories
      end
    end

    describe '#list_repository_names' do
      it 'expects an array of hashes and returns an array of names' do
        hashes = [{'name'=>'repo1'}, {'name'=>'repo2'}]
        names  = ['repo1', 'repo2']
        expect(api).to receive(:list_repositories).and_return(hashes)
        expect(api.list_repository_names).to eq(names)
      end
    end
  end
end