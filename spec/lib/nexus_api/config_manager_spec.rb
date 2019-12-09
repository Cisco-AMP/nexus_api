require 'nexus_api/config_manager'

RSpec.describe NexusAPI::ConfigManager do
  describe 'Unexpected Path' do
    describe 'missing value' do
      it 'raises an error when config does not exist' do
        fake_config = 'spec/fixtures/not_real.yaml'
        error = "ERROR: Specified config '#{fake_config}' does not exist."
        expect { NexusAPI::ConfigManager.new(config_path: fake_config) }.to raise_error(StandardError, error)
      end
    end

    describe 'missing value' do
      it 'returns nil when item not found' do
        @config_manager = NexusAPI::ConfigManager.new(config_path: 'spec/fixtures/bad_test.yaml')
        expect(@config_manager.assets_repository).to eq(nil)
      end
    end
  end

  describe 'Happy Path' do
    before(:all) do
      @config_manager = NexusAPI::ConfigManager.new(config_path: 'spec/fixtures/test.yaml')
    end

    describe '#assets_repository' do
      it 'returns the value of the assets key' do
        expect(@config_manager.assets_repository).to eq('default_assets_repo')
      end
    end

    describe '#components_repository' do
      it 'returns the value of the components key' do
        expect(@config_manager.components_repository).to eq('default_components_repo')
      end
    end

    describe '#search_repository' do
      it 'returns the value of the search key' do
        expect(@config_manager.search_repository).to eq('default_search_repo')
      end
    end

    describe '#tag_repository' do
      it 'returns the value of the tag key' do
        expect(@config_manager.tag_repository).to eq('default_tag_repo')
      end
    end

    describe '#maven_repository' do
      it 'returns the value of the maven key' do
        expect(@config_manager.maven_repository).to eq('default_maven_repo')
      end
    end

    describe '#npm_repository' do
      it 'returns the value of the npm key' do
        expect(@config_manager.npm_repository).to eq('default_npm_repo')
      end
    end

    describe '#pypi_repository' do
      it 'returns the value of the pypi key' do
        expect(@config_manager.pypi_repository).to eq('default_pypi_repo')
      end
    end

    describe '#raw_repository' do
      it 'returns the value of the raw key' do
        expect(@config_manager.raw_repository).to eq('default_raw_repo')
      end
    end

    describe '#rubygems_repository' do
      it 'returns the value of the rubygems key' do
        expect(@config_manager.rubygems_repository).to eq('default_rubygems_repo')
      end
    end

    describe '#yum_repository' do
      it 'returns the value of the yum key' do
        expect(@config_manager.yum_repository).to eq('default_yum_repo')
      end
    end
  end
end