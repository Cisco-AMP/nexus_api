require 'lib/setup_api'

RSpec.describe NexusAPI do
  describe 'Assets Endpoint' do
    include_context 'setup NexusAPI::API'
    let(:repository) { 'repository' }

    describe '#list_assets' do
      let(:url_params) { "assets?repository=#{repository}" }
      let(:team_config) { double }

      before(:each) do
        api.team_config = team_config
      end

      it 'sends :get_response from assets with a repository to the NexusConnection instance' do
        expect(api.connection).to receive(:get_response).with(hash_including(:endpoint => url_params))
        api.list_assets(repository: repository)
      end

      it 'sends the repo in the team config when not specified' do
        allow(team_config).to receive(:assets_repository).and_return(repository)
        expect(api.connection).to receive(:get_response).with(hash_including(:endpoint => url_params))
        api.list_assets
      end

      it 'sends the repo in the team config when nil is specified' do
        allow(team_config).to receive(:assets_repository).and_return(repository)
        expect(api.connection).to receive(:get_response).with(hash_including(:endpoint => url_params))
        api.list_assets(repository: nil)
      end

      it 'a passed in repo overrides the default in the team config' do
        allow(team_config).to receive(:assets_repository).and_return('repo_to_override')
        expect(api.connection).to receive(:get_response).with(hash_including(:endpoint => url_params))
        api.list_assets(repository: repository)
      end

      it 'sends :get_response from assets with pagination defaulted to false to the NexusConnection instance' do
        expect(api.connection).to receive(:get_response).with(hash_including(paginate: false))
        api.list_assets(repository: repository)
      end

      it 'sends :get_response from assets with pagination set to true to the NexusConnection instance' do
        expect(api.connection).to receive(:get_response).with(hash_including(paginate: true))
        api.list_assets(repository: repository, paginate: true)
      end
    end

    describe '#list_all_assets' do
      it 'paginates automatically' do
        first_page = [1,2]
        second_page = [3,4]
        expect(api).to receive(:paginate?).and_return(true, false)
        expect(api).to receive(:list_assets).and_return(first_page, second_page)
        expect(api.list_all_assets(repository: repository)).to eq(first_page + second_page)
      end
    end

    describe '#list_asset' do
      it 'sends :get_response from assets with an asset ID to the NexusConnection instance' do
        expect(api.connection).to receive(:get_response).with(hash_including(:endpoint =>'assets/id'))
        api.list_asset(id: 'id')
      end
    end
  end
end