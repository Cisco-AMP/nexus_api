require 'nexus_api/cli_utils'
require 'nexus_api/cli_commands/download'
require 'lib/nexus_api/mock_cli_utils'

RSpec.describe NexusAPI::Download do
  before(:each) {
    @download = NexusAPI::Download.new
    @download.api = double
  }

  describe '#docker' do
    it 'sends the setup method from CLIUtils' do
      expect(@download).to receive(:setup)
      expect(@download.api).to receive(:download_docker_component)
      @download.docker
    end

    it 'sends the download_docker_component method to api' do
      expect(@download.api).to receive(:download_docker_component)
      @download.docker
    end

    it 'passes the flags set in Thor correctly to api' do
      image      = 'download_image'
      docker_tag = 'download_tag'
      expect(@download.api).to receive(:download_docker_component).with({ :image => image, :tag => docker_tag })
      flags = {
        :image => image,
        :docker_tag => docker_tag,
      }
      @download.options = flags
      @download.docker
    end
  end

  describe '#file' do
    it 'sends the setup method from CLIUtils' do
      expect(@download).to receive(:setup)
      expect(@download.api).to receive(:download)
      @download.file
    end

    it 'sends the download method to api' do
      expect(@download.api).to receive(:download)
      @download.file
    end

    it 'passes the flags set in Thor correctly to api' do
      id   = 'download_id'
      name = 'download_name'
      expect(@download.api).to receive(:download).with({ :id => id, :name => name })
      flags = {
        :nexus_id => id,
        :new_name => name,
      }
      @download.options = flags
      @download.file
    end
  end
end
