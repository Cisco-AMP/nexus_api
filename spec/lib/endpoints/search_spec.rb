require 'lib/setup_api'

RSpec.describe NexusAPI do
  describe 'Search Endpoint' do
    include_context 'setup NexusAPI::API'

    describe '#search_asset' do
      describe 'with a team config' do
        let(:asset_name) { 'assets_name' }
        let(:repository) { 'assets_repo' }
        let(:url_params) { "search/assets?q=#{asset_name}&repository=#{repository}" }
        let(:team_config) { double }
        before(:each) { api.team_config = team_config }

        it 'sends :get_response from search with a repository to the NexusConnection instance' do
          expect(api.connection).to receive(:get_response).with(endpoint: url_params, paginate: anything)
          api.search_asset(name: asset_name, repository: repository)
        end

        it 'sends the repo in the team config when not specified' do
          allow(team_config).to receive(:search_repository).and_return(repository)
          expect(api.connection).to receive(:get_response).with(endpoint: url_params, paginate: anything)
          api.search_asset(name: asset_name)
        end

        it 'sends the repo in the team config when nil is specified' do
          allow(team_config).to receive(:search_repository).and_return(repository)
          expect(api.connection).to receive(:get_response).with(endpoint: url_params, paginate: anything)
          api.search_asset(name: asset_name, repository: nil)
        end

        it 'a passed in repo overrides the default in the team config' do
          allow(team_config).to receive(:search_repository).and_return('repo_to_override')
          expect(api.connection).to receive(:get_response).with(endpoint: url_params, paginate: anything)
          api.search_asset(name: asset_name, repository: repository)
        end

        it 'sends :get_response from search with pagination defaulted to false to the NexusConnection instance' do
          expect(api.connection).to receive(:get_response).with(endpoint: instance_of(String), paginate: false)
          api.search_asset(name: asset_name, repository: repository)
        end

        it 'sends :get_response from search with pagination set to true to the NexusConnection instance' do
          expect(api.connection).to receive(:get_response).with(endpoint: instance_of(String), paginate: true)
          api.search_asset(name: asset_name, repository: repository, paginate: true)
        end
      end

      describe '#search_all_assets' do
        let(:name) { 'name' }

        it 'paginates automatically' do
          first_page = [1,2]
          second_page = [3,4]
          expect(api).to receive(:paginate?).and_return(true, false)
          expect(api).to receive(:search_asset).and_return(first_page, second_page)
          expect(api.search_all_assets(name: name)).to eq(first_page + second_page)
        end
      end

      describe 'with different search terms' do
        let(:connection) { double }
        before(:each) { api.connection = connection }

        it 'builds a request with only a name by default' do
          request = 'search/assets?q=an_asset'
          expect(connection).to receive(:get_response).with(endpoint: request, :paginate=>false)
          api.search_asset(name: 'an_asset')
        end

        it 'builds a request with a format' do
          request = 'search/assets?q=an_asset&format=format'
          expect(connection).to receive(:get_response).with(endpoint: request, :paginate=>false)
          api.search_asset(name: 'an_asset', format: 'format')
        end

        it 'builds a request with a repository' do
          request = 'search/assets?q=an_asset&repository=repository'
          expect(connection).to receive(:get_response).with(endpoint: request, :paginate=>false)
          api.search_asset(name: 'an_asset', repository: 'repository')
        end

        it 'builds a request with a sha1' do
          request = 'search/assets?q=an_asset&sha1=sha1'
          expect(connection).to receive(:get_response).with(endpoint: request, :paginate=>false)
          api.search_asset(name: 'an_asset', sha1: 'sha1')
        end

        it 'builds a request with a version' do
          request = 'search/assets?q=an_asset&version=version'
          expect(connection).to receive(:get_response).with(endpoint: request, :paginate=>false)
          api.search_asset(name: 'an_asset', version: 'version')
        end

        it 'builds a request with all options' do
          request = 'search/assets?q=an_asset&format=format&repository=repository&sha1=sha1&version=version'
          expect(connection).to receive(:get_response).with(endpoint: request, :paginate=>false)
          api.search_asset(name: 'an_asset', format: 'format', repository: 'repository', sha1: 'sha1', version: 'version')
        end
      end
    end
  end
end