require 'nexus_api/cli_utils'
require 'nexus_api/cli_commands/upload'
require 'lib/nexus_api/mock_cli_utils'

RSpec.describe NexusAPI::Upload do
  before(:each) {
    @upload = NexusAPI::Upload.new
    @upload.api = double
  }

  describe '#docker' do
    it 'sends the setup method from CLIUtils' do
      expect(@upload).to receive(:setup)
      expect(@upload.api).to receive(:upload_docker_component)
      @upload.docker
    end

    it 'sends the upload_docker_component method to api' do
      expect(@upload.api).to receive(:upload_docker_component)
      @upload.docker
    end

    it 'passes the flags set in Thor correctly to api' do
      image      = 'docker_image'
      docker_tag = 'docker_tag'

      expect(@upload.api).to receive(:upload_docker_component).with({
        :image => image,
        :tag   => docker_tag,
      })

      flags = {
        :image      => image,
        :docker_tag => docker_tag,
      }
      @upload.options = flags
      @upload.docker
    end
  end

  describe '#maven' do
    it 'returns false when :repository_set? returns false' do
      expect(@upload).to receive(:repository_set?).and_return(false)
      expect(@upload.maven).to be(false)
    end

    it 'sends the upload_maven_component method to api' do
      expect(@upload).to receive(:repository_set?).and_return(true)
      expect(@upload).to receive(:set)
      expect(@upload.api).to receive(:upload_maven_component)
      @upload.maven
    end

    it 'does not send upload_maven_component when file does not exist' do
      expect(@upload).to receive(:repository_set?).and_return(true)
      expect(@upload).to receive(:set)
      expect(@upload).to receive(:if_file_exists?).and_return(false)
      expect(@upload.api).not_to receive(:upload_maven_component)
      @upload.maven
    end

    it 'passes the flags set in Thor correctly to api' do
      filename    = 'maven_name'
      group_id    = 'maven_group_id'
      artifact_id = 'maven_artifact_id'
      version     = 'maven_version'
      repository  = 'maven_repo'
      tag         = 'maven_tag'

      expect(@upload.api).to receive(:upload_maven_component).with({
        :filename    => filename,
        :group_id    => group_id,
        :artifact_id => artifact_id,
        :version     => version,
        :repository  => repository,
        :tag         => tag,
      })

      flags = {
        :filename    => filename,
        :group_id    => group_id,
        :artifact_id => artifact_id,
        :version     => version,
        :repository  => repository,
        :tag         => tag,
      }
      @upload.options = flags
      @upload.maven
    end
  end

  describe '#npm' do
    it 'returns false when :repository_set? returns false' do
      expect(@upload).to receive(:repository_set?).and_return(false)
      expect(@upload.npm).to be(false)
    end

    it 'sends the upload_npm_component method to api' do
      expect(@upload).to receive(:repository_set?).and_return(true)
      expect(@upload).to receive(:set)
      expect(@upload.api).to receive(:upload_npm_component)
      @upload.npm
    end

    it 'does not send upload_npm_component when file does not exist' do
      expect(@upload).to receive(:repository_set?).and_return(true)
      expect(@upload).to receive(:set)
      expect(@upload).to receive(:if_file_exists?).and_return(false)
      expect(@upload.api).not_to receive(:upload_npm_component)
      @upload.npm
    end

    it 'passes the flags set in Thor correctly to api' do
      filename    = 'npm_name'
      repository  = 'npm_repo'
      tag         = 'npm_tag'

      expect(@upload.api).to receive(:upload_npm_component).with({
        :filename    => filename,
        :repository  => repository,
        :tag         => tag,
      })

      flags = {
        :filename    => filename,
        :repository  => repository,
        :tag         => tag,
      }
      @upload.options = flags
      @upload.npm
    end
  end

  describe '#pypi' do
    it 'returns false when :repository_set? returns false' do
      expect(@upload).to receive(:repository_set?).and_return(false)
      expect(@upload.pypi).to be(false)
    end

    it 'sends the upload_pypi_component method to api' do
      expect(@upload).to receive(:repository_set?).and_return(true)
      expect(@upload).to receive(:set)
      expect(@upload.api).to receive(:upload_pypi_component)
      @upload.pypi
    end

    it 'does not send upload_pypi_component when file does not exist' do
      expect(@upload).to receive(:repository_set?).and_return(true)
      expect(@upload).to receive(:set)
      expect(@upload).to receive(:if_file_exists?).and_return(false)
      expect(@upload.api).not_to receive(:upload_pypi_component)
      @upload.pypi
    end

    it 'passes the flags set in Thor correctly to api' do
      filename    = 'pypi_name'
      repository  = 'pypi_repo'
      tag         = 'pypi_tag'

      expect(@upload.api).to receive(:upload_pypi_component).with({
        :filename    => filename,
        :repository  => repository,
        :tag         => tag,
      })

      flags = {
        :filename    => filename,
        :repository  => repository,
        :tag         => tag,
      }
      @upload.options = flags
      @upload.pypi
    end
  end

  describe '#raw' do
    it 'returns false when :repository_set? returns false' do
      expect(@upload).to receive(:repository_set?).and_return(false)
      expect(@upload.raw).to be(false)
    end

    it 'sends the upload_raw_component method to api' do
      expect(@upload).to receive(:repository_set?).and_return(true)
      expect(@upload).to receive(:set)
      expect(@upload.api).to receive(:upload_raw_component)
      @upload.raw
    end

    it 'does not send upload_raw_component when file does not exist' do
      expect(@upload).to receive(:repository_set?).and_return(true)
      expect(@upload).to receive(:set)
      expect(@upload).to receive(:if_file_exists?).and_return(false)
      expect(@upload.api).not_to receive(:upload_raw_component)
      @upload.raw
    end

    it 'passes the flags set in Thor correctly to api' do
      filename    = 'raw_name'
      directory   = 'raw_dir'
      repository  = 'raw_repo'
      tag         = 'raw_tag'

      expect(@upload.api).to receive(:upload_raw_component).with({
        :filename    => filename,
        :directory   => directory,
        :repository  => repository,
        :tag         => tag,
      })

      flags = {
        :filename    => filename,
        :directory   => directory,
        :repository  => repository,
        :tag         => tag,
      }
      @upload.options = flags
      @upload.raw
    end
  end

  describe '#rubygems' do
    it 'returns false when :repository_set? returns false' do
      expect(@upload).to receive(:repository_set?).and_return(false)
      expect(@upload.rubygems).to be(false)
    end

    it 'sends the upload_rubygems_component method to api' do
      expect(@upload).to receive(:repository_set?).and_return(true)
      expect(@upload).to receive(:set)
      expect(@upload.api).to receive(:upload_rubygems_component)
      @upload.rubygems
    end

    it 'does not send upload_rubygems_component when file does not exist' do
      expect(@upload).to receive(:repository_set?).and_return(true)
      expect(@upload).to receive(:set)
      expect(@upload).to receive(:if_file_exists?).and_return(false)
      expect(@upload.api).not_to receive(:upload_rubygems_component)
      @upload.rubygems
    end

    it 'passes the flags set in Thor correctly to api' do
      filename    = 'rubygems_name'
      repository  = 'rubygems_repo'
      tag         = 'rubygems_tag'

      expect(@upload.api).to receive(:upload_rubygems_component).with({
        :filename    => filename,
        :repository  => repository,
        :tag         => tag,
      })

      flags = {
        :filename    => filename,
        :repository  => repository,
        :tag         => tag,
      }
      @upload.options = flags
      @upload.rubygems
    end
  end

  describe '#yum' do
    it 'returns false when :repository_set? returns false' do
      expect(@upload).to receive(:repository_set?).and_return(false)
      expect(@upload.yum).to be(false)
    end

    it 'sends the upload_yum_component method to api' do
      expect(@upload).to receive(:repository_set?).and_return(true)
      expect(@upload).to receive(:set)
      expect(@upload.api).to receive(:upload_yum_component)
      @upload.yum
    end

    it 'does not send upload_yum_component when file does not exist' do
      expect(@upload).to receive(:repository_set?).and_return(true)
      expect(@upload).to receive(:set)
      expect(@upload).to receive(:if_file_exists?).and_return(false)
      expect(@upload.api).not_to receive(:upload_yum_component)
      @upload.yum
    end

    it 'passes the flags set in Thor correctly to api' do
      filename    = 'yum_name'
      directory   = 'yum_dir'
      repository  = 'yum_repo'
      tag         = 'yum_tag'

      expect(@upload.api).to receive(:upload_yum_component).with({
        :filename    => filename,
        :directory   => directory,
        :repository  => repository,
        :tag         => tag,
      })

      flags = {
        :filename    => filename,
        :directory   => directory,
        :repository  => repository,
        :tag         => tag,
      }
      @upload.options = flags
      @upload.yum
    end
  end
end
