require 'lib/setup_api'

RSpec.describe NexusAPI do
  describe 'Tags Endpoint' do
    include_context 'setup NexusAPI::API'

    let(:name) { 'name' }

    describe 'tag commands' do
      let(:tag_endpoint) { 'tags' }

      describe '#list_tags' do
        it 'sends :get_response tags to the NexusConnection instance' do
          expect(api.connection).to receive(:get_response).with(endpoint: tag_endpoint, paginate: anything)
          api.list_tags
        end

        it 'sends :get_response tags with pagination defaulted to false to the NexusConnection instance' do
          expect(api.connection).to receive(:get_response).with(endpoint: instance_of(String), paginate: false)
          api.list_tags
        end

        it 'sends :get_response tags with pagination set to true to the NexusConnection instance' do
          expect(api.connection).to receive(:get_response).with(endpoint: instance_of(String), paginate: true)
          api.list_tags(paginate: true)
        end
      end

      describe '#create_tag' do
        let(:name_parameter) { JSON.dump({'name' => name}) }

        it 'sends :post tags to the NexusConnection instance' do
          expect(api.connection).to receive(:post).with(endpoint: tag_endpoint, parameters: anything)
          api.create_tag(name: name)
        end

        it 'sends a tag name as a JSON parameter' do
          expect(api.connection).to receive(:post).with(endpoint: anything, parameters: name_parameter)
          api.create_tag(name: name)
        end
      end

      describe '#delete_tag' do
        it 'sends :delete tags with a tag name to the NexusConnection instance' do
          expect(api.connection).to receive(:delete).with(endpoint: "#{tag_endpoint}/#{name}")
           api.delete_tag(name: name)
        end
      end
    end

    describe 'tag associate commands' do
      let(:repository) { 'assets_repo' }
      let(:sha1) { 'sha1' }
      let(:team_config) { double }
      before(:each) { api.team_config = team_config }

      describe '#associate_tag' do
        let(:url_params) { "tags/associate/#{name}?wait=true&repository=#{repository}&sha1=#{sha1}" }

        it 'sends :post tags associate with a tag name to the NexusConnection instance' do
          expect(api.connection).to receive(:post).with(endpoint: url_params)
          api.associate_tag(name: name, sha1: sha1, repository: repository)
        end

        it 'sends the repo in the team config when not specified' do
          allow(team_config).to receive(:tag_repository).and_return(repository)
          expect(api.connection).to receive(:post).with(endpoint: url_params)
          api.associate_tag(name: name, sha1: sha1)
        end

        it 'sends the repo in the team config when nil is specified' do
          allow(team_config).to receive(:tag_repository).and_return(repository)
          expect(api.connection).to receive(:post).with(endpoint: url_params)
          api.associate_tag(name: name, sha1: sha1)
        end

        it 'a passed in repo overrides the default in the team config' do
          allow(team_config).to receive(:tag_repository).and_return('repo_to_override')
          expect(api.connection).to receive(:post).with(endpoint: url_params)
          api.associate_tag(name: name, sha1: sha1, repository: repository)
        end
      end

      describe '#delete_associated_tag' do
        let(:url_params) { "tags/associate/#{name}?repository=#{repository}&sha1=#{sha1}" }

        it 'sends :delete tags associate with a tag name to the NexusConnection instance' do
          expect(api.connection).to receive(:delete).with(endpoint: url_params)
          api.delete_associated_tag(name: name, sha1: sha1, repository: repository)
        end

        it 'sends the repo in the team config when not specified' do
          allow(team_config).to receive(:tag_repository).and_return(repository)
          expect(api.connection).to receive(:delete).with(endpoint: url_params)
          api.delete_associated_tag(name: name, sha1: sha1)
        end

        it 'sends the repo in the team config when nil is specified' do
          allow(team_config).to receive(:tag_repository).and_return(repository)
          expect(api.connection).to receive(:delete).with(endpoint: url_params)
          api.delete_associated_tag(name: name, sha1: sha1, repository: nil)
        end

        it 'a passed in repo overrides the default in the team config' do
          allow(team_config).to receive(:tag_repository).and_return('repo_to_override')
          expect(api.connection).to receive(:delete).with(endpoint: url_params)
          api.delete_associated_tag(name: name, sha1: sha1, repository: repository)
        end
      end
    end
  end
end