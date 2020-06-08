require 'lib/setup_api'

RSpec.describe NexusAPI do
  describe 'Tags Endpoint' do
    include_context 'setup NexusAPI::API'

    let(:tag) { 'tag' }

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

      describe '#list_all_tags' do
        it 'paginates automatically' do
          first_page = [1,2]
          second_page = [3,4]
          expect(api).to receive(:paginate?).and_return(true, false)
          expect(api).to receive(:list_tags).and_return(first_page, second_page)
          expect(api.list_all_tags).to eq(first_page + second_page)
        end
      end

      describe '#create_tag' do
        let(:name_parameter) { JSON.dump({'name' => tag}) }

        it 'sends :post tags to the NexusConnection instance' do
          expect(api.connection).to receive(:post).with(endpoint: tag_endpoint, parameters: anything)
          api.create_tag(name: tag)
        end

        it 'sends a tag name as a JSON parameter' do
          expect(api.connection).to receive(:post).with(endpoint: anything, parameters: name_parameter)
          api.create_tag(name: tag)
        end
      end

      describe '#delete_tag' do
        it 'sends :delete tags with a tag name to the NexusConnection instance' do
          expect(api.connection).to receive(:delete).with(endpoint: "#{tag_endpoint}/#{tag}")
           api.delete_tag(name: tag)
        end
      end
    end

    describe 'tag associate commands' do
      let(:team_config) { double }
      let(:sha1) { 'sha1' }
      let(:repository) { 'repository' }
      let(:tag_to_find) { 'tag_to_find' }
      before(:each) { api.team_config = team_config }

      def mock_request(type, url)
        stub_request(type, url).with(headers: { 'Content-Type'=>'application/json' })
        yield
        expect(a_request(type, url)).to have_been_made
      end

      describe '#associate_tag' do
        let(:base) { "#{BASE_URL}/v1/tags/associate/#{tag}?wait=true" }
        let(:full_url) { "#{base}&repository=#{repository}&sha1=#{sha1}&tag=#{tag_to_find}" }

        it 'sends a post to v1/tags/associate with a tag name, SHA1, repository, and tag' do
          mock_request(:post, full_url) do
            api.associate_tag(name: tag, sha1: sha1, repository: repository, tag: tag_to_find)
          end
        end

        it 'sends a post to v1/tags/associate with a tag name and SHA1' do
          allow(team_config).to receive(:tag_repository).and_return(nil)
          url = "#{base}&sha1=#{sha1}"
          mock_request(:post, url) { api.associate_tag(name: tag, sha1: sha1) }
        end

        it 'sends a post to v1/tags/associate with a tag name and repository' do
          url = "#{base}&repository=#{repository}"
          mock_request(:post, url) { api.associate_tag(name: tag, repository: repository) }
        end

        it 'sends a post to v1/tags/associate with a tag name and tag' do
          allow(team_config).to receive(:tag_repository).and_return(nil)
          url = "#{base}&tag=#{tag_to_find}"
          mock_request(:post, url) { api.associate_tag(name: tag, tag: tag_to_find) }
        end

        it 'sends the repo in the team config when not specified' do
          allow(team_config).to receive(:tag_repository).and_return(repository)
          mock_request(:post, full_url) { api.associate_tag(name: tag, sha1: sha1, tag: tag_to_find) }
        end

        it 'sends the repo in the team config when nil is specified' do
          allow(team_config).to receive(:tag_repository).and_return(repository)
          mock_request(:post, full_url) do
            api.associate_tag(name: tag, sha1: sha1, repository: nil, tag: tag_to_find)
          end
        end

        it 'a passed in repo overrides the default in the team config' do
          allow(team_config).to receive(:tag_repository).and_return('repo_to_override')
          mock_request(:post, full_url) do
            api.associate_tag(name: tag, sha1: sha1, repository: repository, tag: tag_to_find)
          end
        end

        it 'does not send a sha1 if none is specified anywhere' do
          url = "#{base}&repository=#{repository}&tag=#{tag_to_find}"
          mock_request(:post, url) do
            api.associate_tag(name: tag, repository: repository, tag: tag_to_find)
          end
        end

        it 'does not send a repo if none is specified anywhere' do
          allow(team_config).to receive(:tag_repository).and_return(nil)
          url = "#{base}&sha1=#{sha1}&tag=#{tag_to_find}"
          mock_request(:post, url) do
            api.associate_tag(name: tag, sha1: sha1, repository: nil, tag: tag_to_find)
          end
        end

        it 'does not send a tag if none is specified anywhere' do
          url = "#{base}&sha1=#{sha1}&repository=#{repository}"
          mock_request(:post, url) { api.associate_tag(name: tag, sha1: sha1, repository: repository) }
        end

        it 'returns false when not enough arguments are provided' do
          allow(team_config).to receive(:tag_repository).and_return(nil)
          expect(api.associate_tag(name: tag)).to be(false)
        end

        it 'prints an error when not enough arguments are provided' do
          allow(team_config).to receive(:tag_repository).and_return(nil)
          expect { api.associate_tag(name: tag) }.to output(/ERROR/).to_stdout
        end
      end

      describe '#delete_associated_tag' do
        let(:base) { "#{BASE_URL}/v1/tags/associate/#{tag}?" }
        let(:full_url) { "#{base}repository=#{repository}&sha1=#{sha1}&tag=#{tag_to_find}" }

        it 'sends a delete to v1/tags/associate with a tag name, SHA1, repository, and tag' do
          mock_request(:delete, full_url) do
            api.delete_associated_tag(name: tag, sha1: sha1, repository: repository, tag: tag_to_find)
          end
        end

        it 'sends a delete to v1/tags/associate with a tag name and SHA1' do
          allow(team_config).to receive(:tag_repository).and_return(nil)
          url = "#{base}&sha1=#{sha1}"
          mock_request(:delete, url) { api.delete_associated_tag(name: tag, sha1: sha1) }
        end

        it 'sends a delete to v1/tags/associate with a tag name and repository' do
          url = "#{base}&repository=#{repository}"
          mock_request(:delete, url) { api.delete_associated_tag(name: tag, repository: repository) }
        end

        it 'sends a delete to v1/tags/associate with a tag name and tag' do
          allow(team_config).to receive(:tag_repository).and_return(nil)
          url = "#{base}&tag=#{tag_to_find}"
          mock_request(:delete, url) { api.delete_associated_tag(name: tag, tag: tag_to_find) }
        end

        it 'sends the repo in the team config when not specified' do
          allow(team_config).to receive(:tag_repository).and_return(repository)
          mock_request(:delete, full_url) do
            api.delete_associated_tag(name: tag, sha1: sha1, tag: tag_to_find)
          end
        end

        it 'sends the repo in the team config when nil is specified' do
          allow(team_config).to receive(:tag_repository).and_return(repository)
          mock_request(:delete, full_url) do
            api.delete_associated_tag(name: tag, sha1: sha1, repository: nil, tag: tag_to_find)
          end
        end

        it 'a passed in repo overrides the default in the team config' do
          allow(team_config).to receive(:tag_repository).and_return('repo_to_override')
          mock_request(:delete, full_url) do
            api.delete_associated_tag(name: tag, sha1: sha1, repository: repository, tag: tag_to_find)
          end
        end

        it 'does not send a sha1 if none is specified anywhere' do
          url = "#{base}&repository=#{repository}&tag=#{tag_to_find}"
          mock_request(:delete, url) do
            api.delete_associated_tag(name: tag, repository: repository, tag: tag_to_find)
          end
        end

        it 'does not send a repo if none is specified anywhere' do
          url = "#{base}sha1=#{sha1}&tag=#{tag_to_find}"
          allow(team_config).to receive(:tag_repository).and_return(nil)
          mock_request(:delete, url) do
            api.delete_associated_tag(name: tag, sha1: sha1, repository: nil, tag: tag_to_find)
          end
        end

        it 'does not send a tag if none is specified anywhere' do
          url = "#{base}&sha1=#{sha1}&repository=#{repository}"
          mock_request(:delete, url) do
            api.delete_associated_tag(name: tag, sha1: sha1, repository: repository)
          end
        end

        it 'returns false when not enough arguments are provided' do
          allow(team_config).to receive(:tag_repository).and_return(nil)
          expect(api.delete_associated_tag(name: tag)).to be(false)
        end

        it 'prints an error when not enough arguments are provided' do
          allow(team_config).to receive(:tag_repository).and_return(nil)
          expect { api.delete_associated_tag(name: tag) }.to output(/ERROR/).to_stdout
        end
      end
    end
  end
end