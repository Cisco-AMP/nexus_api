require 'nexus_api/docker_shell'
require 'nexus_api/docker_manager'
require 'lib/nexus_api/mock_docker_image'

RSpec.describe NexusAPI::DockerManager do
  let(:username) { 'jake' }
  let(:password) { '1234' }
  let(:pull_host) { 'nexus_pull' }
  let(:push_host) { 'nexus_push' }
  let(:repo) { 'containerz' }
  let(:tag) { 'blue' }

  before(:each) {
    @shell = NexusAPI::DockerShell.new
    @manager = NexusAPI::DockerManager.new(
      docker: @shell,
      options: {
        'username' => username,
        'password' => password,
        'pull_host' => pull_host,
        'push_host' => push_host,
      }
    )
  }

  describe '#download' do
    it 'returns false when valid docker API not present' do
      expect(@shell).to receive(:validate_version!).and_return(false)
      expect {
        expect(@manager.download(image_name: repo, tag: tag)).to be false
      }.to output("ERROR: Your installed version of the Docker API is not supported by the docker-api gem!\n").to_stdout
    end

    it 'returns false when image can not be pulled' do
      expect(@shell).to receive(:validate_version!).and_return(true)
      expect(@shell).to receive(:pull_image).and_raise(Docker::Error::NotFoundError)
      expect {
        expect(@manager.download(image_name: repo, tag: tag)).to be false
      }.to output("ERROR: Failed to pull Docker image #{pull_host}/#{repo}:#{tag}.\nDoes it exist in Nexus?\n").to_stdout
    end

    it 'returns true when image pulled successfully' do
      expect(@shell).to receive(:validate_version!).and_return(true)
      expect(@shell).to receive(:pull_image).and_return(true)
      expect(@manager.download(image_name: repo, tag: tag)).to be true
    end
  end

  describe '#upload' do
    it 'returns false when valid docker API not present' do
      expect(@shell).to receive(:validate_version!).and_return(false)
      expect {
        expect(@manager.upload(image_name: repo, tag: tag)).to be false
      }.to output("ERROR: Your installed version of the Docker API is not supported by the docker-api gem!\n").to_stdout
    end

    it 'returns false when login fails' do
      expect(@shell).to receive(:validate_version!).and_return(true)
      expect(@shell).to receive(:authenticate!).and_return(false)
      expect {
        expect(@manager.upload(image_name: repo, tag: tag)).to be false
      }.to output("ERROR: Failed to authenticate to #{push_host} as #{username}\n").to_stdout
    end

    it 'returns false when no matching images found' do
      expect(@shell).to receive(:validate_version!).and_return(true)
      expect(@shell).to receive(:authenticate!).and_return(true)
      expect(@shell).to receive(:list_images).and_return([])
      expect {
        expect(@manager.upload(image_name: repo, tag: tag)).to be false
      }.to output("ERROR: No matching docker images found\n").to_stdout
    end

    it 'returns false when multiple matching images are found' do
      image1 = image2 = NexusAPI::MockDockerImage.new(["#{pull_host}/#{repo}:#{tag}"])
      image_tags = [["#{pull_host}/#{repo}:#{tag}"], ["#{pull_host}/#{repo}:#{tag}"]]
      expect(@shell).to receive(:validate_version!).and_return(true)
      expect(@shell).to receive(:authenticate!).and_return(true)
      expect(@shell).to receive(:list_images).and_return([image1, image2])
      expect {
        expect(@manager.upload(image_name: repo, tag: tag)).to be false
      }.to output("ERROR: Found multiple images that match: #{image_tags}\n").to_stdout
    end

    it 'returns true when a matching image is found and pushed' do
      image1 = NexusAPI::MockDockerImage.new(["#{pull_host}/#{repo}:#{tag}"])
      image2 = NexusAPI::MockDockerImage.new(["#{push_host}/#{repo}:#{tag}"])
      expect(@shell).to receive(:validate_version!).and_return(true)
      expect(@shell).to receive(:authenticate!).and_return(true)
      expect(@shell).to receive(:list_images).and_return([image1, image2])
      expect(image1).to receive(:push).and_return(true)
      expect(@manager.upload(image_name: repo, tag: tag)).to be true
    end
  end

  describe '#exists?' do
    it 'returns false when valid docker API not present' do
      expect(@shell).to receive(:validate_version!).and_return(false)
      expect {
        expect(@manager.exists?(image_name: repo, tag: tag)).to be false
      }.to output("ERROR: Your installed version of the Docker API is not supported by the docker-api gem!\n").to_stdout
    end

    it 'returns false when no matching images found' do
      expect(@shell).to receive(:validate_version!).and_return(true)
      expect(@shell).to receive(:list_images).and_return([])
      expect(@manager.exists?(image_name: repo, tag: tag)).to be false
    end

    it 'returns true when multiple matching images are found' do
      image1 = image2 = NexusAPI::MockDockerImage.new(["#{pull_host}/#{repo}:#{tag}"])
      image_tags = [["#{pull_host}/#{repo}:#{tag}"], ["#{pull_host}/#{repo}:#{tag}"]]
      expect(@shell).to receive(:validate_version!).and_return(true)
      expect(@shell).to receive(:list_images).and_return([image1, image2])
      expect(@manager.exists?(image_name: repo, tag: tag)).to be true
    end

    it 'returns true when a matching image is found' do
      image1 = NexusAPI::MockDockerImage.new(["#{pull_host}/#{repo}:#{tag}"])
      expect(@shell).to receive(:validate_version!).and_return(true)
      expect(@shell).to receive(:list_images).and_return([image1])
      expect(@manager.exists?(image_name: repo, tag: tag)).to be true
    end
  end

  describe '#delete' do
    it 'returns false when valid docker API not present' do
      expect(@shell).to receive(:validate_version!).and_return(false)
      expect {
        expect(@manager.delete(image_name: repo, tag: tag)).to be false
      }.to output("ERROR: Your installed version of the Docker API is not supported by the docker-api gem!\n").to_stdout
    end

    it 'returns false when no matching images found' do
      expect(@shell).to receive(:validate_version!).and_return(true)
      expect(@shell).to receive(:list_images).and_return([])
      expect {
        expect(@manager.delete(image_name: repo, tag: tag)).to be false
      }.to output("ERROR: No matching docker images found\n").to_stdout
    end

    it 'returns false when multiple matching images are found' do
      image1 = image2 = NexusAPI::MockDockerImage.new(["#{pull_host}/#{repo}:#{tag}"])
      image_tags = [["#{pull_host}/#{repo}:#{tag}"], ["#{pull_host}/#{repo}:#{tag}"]]
      expect(@shell).to receive(:validate_version!).and_return(true)
      expect(@shell).to receive(:list_images).and_return([image1, image2])
      expect {
        expect(@manager.delete(image_name: repo, tag: tag)).to be false
      }.to output("ERROR: Found multiple images that match: #{image_tags}\n").to_stdout
    end

    it 'returns false when a matching image is found but not deleted' do
      image1 = NexusAPI::MockDockerImage.new(["#{pull_host}/#{repo}:#{tag}"])
      expect(@shell).to receive(:validate_version!).and_return(true)
      expect(@shell).to receive(:list_images).and_return([image1])
      expect(image1).to receive(:remove).and_return(false)
      expect(@manager.delete(image_name: repo, tag: tag)).to be false
    end

    it 'returns true when a matching image is found and deleted' do
      image1 = NexusAPI::MockDockerImage.new(["#{pull_host}/#{repo}:#{tag}"])
      expect(@shell).to receive(:validate_version!).and_return(true)
      expect(@shell).to receive(:list_images).and_return([image1])
      expect(image1).to receive(:remove).and_return(true)
      expect(@manager.delete(image_name: repo, tag: tag)).to be true
    end
  end
end
