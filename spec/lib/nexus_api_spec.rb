require 'lib/setup_api'

RSpec.describe NexusAPI do
  describe 'API' do
    include_context 'setup NexusAPI::API'

    it 'has a default config to read from' do
      expect(File.exist?(NexusAPI::API::TEAM_CONFIG)).to be(true)
    end

    describe '#get_asset_size' do
      it 'sends :content_length with an asset_url to the NexusConnection instance' do
        asset_url = 'asset_url'
        expect(api.connection).to receive(:content_length).with(asset_url: asset_url)
        api.get_asset_size(asset_url: asset_url)
      end
    end

    describe 'docker methods' do
      let(:image) { 'image' }
      let(:tag)   { 'tag' }

      describe '#docker_ready?' do
        it 'returns true if both docker pull and push endpoints are initialized' do
          expect(api.docker_ready?).to be true
        end

        describe 'when not initialized' do
          after(:each) do
            expect { @api.docker_ready? }.to raise_error('Docker push and pull endpoints not initialized!')
          end

          it 'throws an exception if docker pull endpoint is not initialized' do
            @api = NexusAPI::API.new(
              username: 'username',
              password: 'password',
              hostname: 'nexus_hostname',
              docker_push_hostname: 'push_url',
            )
          end

          it 'throws an exception if docker pull endpoint is not initialized' do
            @api = NexusAPI::API.new(
              username: 'username',
              password: 'password',
              hostname: 'nexus_hostname',
              docker_pull_hostname: 'pull_url',
            )
          end

          it 'throws an exception if docker pull endpoint is not initialized' do
            @api = NexusAPI::API.new(
              username: 'username',
              password: 'password',
              hostname: 'nexus_hostname',
            )
          end
        end
      end

      def mock_docker_not_ready
        expect(api).to receive(:docker_ready?).and_return(false)
      end

      describe '#download_docker_component' do
        it 'sends :download with an image and tag to the DockerManager instance' do
          expect(api.docker).to receive(:download).with(image_name: image, tag: tag)
          api.download_docker_component(image: image, tag: tag)
        end

        it 'does not send :download to the DockerManager instance if docker is uninitialized' do
          mock_docker_not_ready
          expect(api.docker).not_to receive(:download)
          api.download_docker_component(image: image, tag: tag)
        end
      end

      describe '#upload_docker_component' do
        it 'sends :upload with an image and tag to the DockerManager instance' do
          expect(api.docker).to receive(:upload).with(image_name: image, tag: tag)
          api.upload_docker_component(image: image, tag: tag)
        end

        it 'does not send :upload to the DockerManager instance if docker is uninitialized' do
          mock_docker_not_ready
          expect(api.docker).not_to receive(:upload)
          api.upload_docker_component(image: image, tag: tag)
        end
      end

      describe '#local_docker_image_exists?' do
        it 'sends :exists? with an image and tag to the DockerManager instance' do
          expect(api.docker).to receive(:exists?).with(image_name: image, tag: tag)
          api.local_docker_image_exists?(image: image, tag: tag)
        end

        it 'does not send :exists? to the DockerManager instance if docker is uninitialized' do
          mock_docker_not_ready
          expect(api.docker).not_to receive(:exists?)
          api.local_docker_image_exists?(image: image, tag: tag)
        end
      end

      describe '#delete_local_docker_image' do
        it 'sends :delete with an image and tag to the DockerManager instance' do
          expect(api.docker).to receive(:delete).with(image_name: image, tag: tag)
          api.delete_local_docker_image(image: image, tag: tag)
        end

        it 'does not send :delete to the DockerManager instance if docker is uninitialized' do
          mock_docker_not_ready
          expect(api.docker).not_to receive(:delete)
          api.delete_local_docker_image(image: image, tag: tag)
        end
      end
    end

    describe '#download' do
      let(:id) { 'id' }

      describe 'happy path' do
        let(:url) { 'path/url' }
        let(:response) { double }
        let(:asset) { {'downloadUrl'=>url} }

        before(:each) do
          expect(response).to receive(:body)
        end

        it 'sends :list_asset with an ID' do
          expect(api).to receive(:list_asset).with(id: id).and_return(asset)
          expect(api.connection).to receive(:download).and_return(response)
          expect(File).to receive(:write).and_return(true)
          api.download(id: id)
        end

        it 'sends :download with a url to the NexusConnection instance' do
          expect(api).to receive(:list_asset).and_return(asset)
          expect(api.connection).to receive(:download).with(url: url).and_return(response)
          expect(File).to receive(:write).and_return(true)
          api.download(id: id)
        end

        it 'sends :write with a name to File when specified' do
          name = 'name'
          expect(api).to receive(:list_asset).and_return(asset)
          expect(api.connection).to receive(:download).and_return(response)
          expect(File).to receive(:write).with(name, anything).and_return(true)
          api.download(id: id, name: name)
        end

        it 'sends :write with an assumed name to File when not specified' do
          expect(api).to receive(:list_asset).and_return(asset)
          expect(api.connection).to receive(:download).and_return(response)
          expect(File).to receive(:write).with('url', anything).and_return(true)
          api.download(id: id)
        end

        it 'returns true the operation succeeds' do
          expect(api).to receive(:list_asset).and_return(asset)
          expect(api.connection).to receive(:download).and_return(response)
          expect(File).to receive(:write).and_return(true)
          expect(api.download(id: id)).to be(true)
        end
      end

      it 'returns false when :list_asset returns an empty asset' do
        expect(api).to receive(:list_asset).and_return('')
        expect(api.download(id: id)).to be(false)
      end

      it 'returns false when :list_asset returns an empty array' do
        expect(api).to receive(:list_asset).and_return([])
        expect(api.download(id: id)).to be(false)
      end

      it 'returns false when :list_asset returns an empty hash' do
        expect(api).to receive(:list_asset).and_return({})
        expect(api.download(id: id)).to be(false)
      end

      it 'returns false when :list_asset returns an asset without a downloadUrl' do
        expect(api).to receive(:list_asset).and_return({'name'=>'no_url'})
        expect(api.download(id: id)).to be(false)
      end
    end

    describe '#paginate?' do
      it 'sends :paginate? to the NexusConnection instance' do
        expect(api.connection).to receive(:paginate?)
        api.paginate?
      end
    end
  end
end
