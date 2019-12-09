require 'nexus_api/docker_shell'

RSpec.describe NexusAPI::DockerShell do
  before(:each) {
    @docker = NexusAPI::DockerShell.new
  }

  let(:username) { 'joe' }
  let(:password) { 'abc123' }
  let(:image_name) { 'venus' }
  let(:host) { 'docker_hub' }

  describe '#validate_version!' do
    it 'sends :validate_version! to Docker class' do
      expect(Docker).to receive(:validate_version!)
      @docker.validate_version!
    end
  end

  describe '#pull_image' do
    it 'sends :create to Docker::Image class' do
      image_parameters = {
        'username' => username,
        'password' => password,
        'fromImage' => image_name,
      }
      expect(Docker::Image).to receive(:create).with(image_parameters).and_return(true)
      @docker.pull_image(username, password, image_name)
    end
  end

  describe '#authenticate!' do
    it 'sends :authenticate! to Docker class' do
      auth_parameters = {
        'username' => username,
        'password' => password,
        'serveraddress' => host,
      }
      expect(Docker).to receive(:authenticate!).with(auth_parameters).and_return(true)
      @docker.authenticate!(username, password, host)
    end
  end

  describe '#list_images' do
    it 'sends :all to Docker::Image class' do
      expect(Docker::Image).to receive(:all)
      @docker.list_images
    end
  end
end
