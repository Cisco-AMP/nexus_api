require 'lib/setup_api'

RSpec.describe NexusAPI do
  describe 'Components Endpoint' do
    include_context 'setup NexusAPI::API'

    let(:tag) { 'imatag' }
    let(:repository) { 'repository' }
    let(:team_config) { double }
    before(:each) { api.team_config = team_config }


    describe '#list_components' do
      let(:url_params) { "components?repository=#{repository}" }

      it 'sends :get_response from components with a repository to the NexusConnection instance' do
        expect(api.connection).to receive(:get_response).with(hash_including(:endpoint => url_params))
        api.list_components(repository: repository)
      end

      it 'sends the repo in the team config when not specified' do
        allow(team_config).to receive(:components_repository).and_return(repository)
        expect(api.connection).to receive(:get_response).with(hash_including(:endpoint => url_params))
        api.list_components
      end

      it 'sends the repo in the team config when nil is specified' do
        allow(team_config).to receive(:components_repository).and_return(repository)
        expect(api.connection).to receive(:get_response).with(hash_including(:endpoint => url_params))
        api.list_components(repository: nil)
      end

      it 'a passed in repo overrides the default in the team config' do
        allow(team_config).to receive(:components_repository).and_return('repo_to_override')
        expect(api.connection).to receive(:get_response).with(hash_including(:endpoint => url_params))
        api.list_components(repository: repository)
      end

      it 'sends :get_response from components with pagination defaulted to false to the NexusConnection instance' do
        expect(api.connection).to receive(:get_response).with(hash_including(paginate: false))
        api.list_components(repository: repository)
      end

      it 'sends :get_response from components with pagination set to true to the NexusConnection instance' do
        expect(api.connection).to receive(:get_response).with(hash_including(paginate: true))
        api.list_components(repository: repository, paginate: true)
      end
    end

    describe '#list_all_components' do
      it 'paginates automatically' do
        first_page = [1,2]
        second_page = [3,4]
        expect(api).to receive(:paginate?).and_return(true, false)
        expect(api).to receive(:list_components).and_return(first_page, second_page)
        expect(api.list_all_components(repository: repository)).to eq(first_page + second_page)
      end
    end


    describe '#upload_maven_component' do
      let(:repository)  { 'maven-releases' }
      let(:group_id)    { 'tests.are.good' }
      let(:artifact_id) { 'unique_123' }
      let(:version)     { '0.0.1' }
      let(:filename)    { 'maven_file' }

      def expect_post_with_maven_parameters(tag: false)
        file = double
        expect(File).to receive(:open).and_return(file)
        parameters = {
          'maven2.artifactId'=>instance_of(String),
          'maven2.asset1'=>file,
          'maven2.asset1.extension'=>instance_of(String),
          'maven2.groupId'=>instance_of(String),
          'maven2.version'=>instance_of(String),
        }
        parameters['maven2.tag'] = instance_of(String) if tag
        expect(api.connection).to receive(:post).with(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
      end

      it 'sends :post components with maven parameters to the NexusConnection instance' do
        expect_post_with_maven_parameters
        api.upload_maven_component(filename: filename, group_id: group_id, artifact_id: artifact_id, version: version, repository: repository)
      end

      it 'sends the repo in the team config when not specified' do
        expect_post_with_maven_parameters
        allow(team_config).to receive(:maven_repository).and_return(repository)
        api.upload_maven_component(filename: filename, group_id: group_id, artifact_id: artifact_id, version: version)
      end

      it 'sends the repo in the team config when nil is specified' do
        expect_post_with_maven_parameters
        allow(team_config).to receive(:maven_repository).and_return(repository)
        api.upload_maven_component(filename: filename, group_id: group_id, artifact_id: artifact_id, version: version, repository: nil)
      end

      it 'a passed in repo overrides the default in the team config' do
        expect_post_with_maven_parameters
        allow(team_config).to receive(:maven_repository).and_return('repo_to_override')
        api.upload_maven_component(filename: filename, group_id: group_id, artifact_id: artifact_id, version: version, repository: repository)
      end

      it 'adds a tag to the parameter list when specified' do
        expect_post_with_maven_parameters(tag: true)
        api.upload_maven_component(filename: filename, group_id: group_id, artifact_id: artifact_id, version: version, repository: repository, tag: tag)
      end
    end


    describe '#upload_npm_component' do
      let(:repository) { 'amp-npm-hosted' }
      let(:filename)   { 'npm_file' }

      def expect_post_with_npm_parameters(tag: false)
        file = double
        expect(File).to receive(:open).and_return(file)
        parameters = { 'npm.asset'=>file }
        parameters['npm.tag'] = instance_of(String) if tag
        expect(api.connection).to receive(:post).with(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
      end

      it 'sends :post components with npm parameters to the NexusConnection instance' do
        expect_post_with_npm_parameters
        api.upload_npm_component(filename: filename, repository: repository)
      end

      it 'sends the repo in the team config when not specified' do
        expect_post_with_npm_parameters
        allow(team_config).to receive(:npm_repository).and_return(repository)
        api.upload_npm_component(filename: filename)
      end

      it 'sends the repo in the team config when nil is specified' do
        expect_post_with_npm_parameters
        allow(team_config).to receive(:npm_repository).and_return(repository)
        api.upload_npm_component(filename: filename, repository: nil)
      end

      it 'a passed in repo overrides the default in the team config' do
        expect_post_with_npm_parameters
        allow(team_config).to receive(:npm_repository).and_return('repo_to_override')
        api.upload_npm_component(filename: filename, repository: repository)
      end

      it 'adds a tag to the parameter list when specified' do
        expect_post_with_npm_parameters(tag: true)
        api.upload_npm_component(filename: filename, repository: repository, tag: tag)
      end
    end


    describe '#upload_pypi_component' do
      let(:repository) { 'pypi-hosted' }
      let(:filename)   { "./spec/test_files/hound-dog-0.1.whl" }

      def expect_post_with_pypi_parameters(tag: false)
        file = double
        expect(File).to receive(:open).and_return(file)
        parameters = { 'pypi.asset'=>file }
        parameters['pypi.tag'] = instance_of(String) if tag
        expect(api.connection).to receive(:post).with(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
      end

      it 'sends :post components with pypi parameters to the NexusConnection instance' do
        expect_post_with_pypi_parameters
        api.upload_pypi_component(filename: filename, repository: repository)
      end

      it 'sends the repo in the team config when not specified' do
        expect_post_with_pypi_parameters
        allow(team_config).to receive(:pypi_repository).and_return(repository)
        api.upload_pypi_component(filename: filename)
      end

      it 'sends the repo in the team config when nil is specified' do
        expect_post_with_pypi_parameters
        allow(team_config).to receive(:pypi_repository).and_return(repository)
        api.upload_pypi_component(filename: filename, repository: nil)
      end

      it 'a passed in repo overrides the default in the team config' do
        expect_post_with_pypi_parameters
        allow(team_config).to receive(:pypi_repository).and_return('repo_to_override')
        api.upload_pypi_component(filename: filename, repository: repository)
      end

      it 'adds a tag to the parameter list when specified' do
        expect_post_with_pypi_parameters(tag: true)
        api.upload_pypi_component(filename: filename, repository: repository, tag: tag)
      end
    end


    describe '#upload_raw_component' do
      let(:repository) { 'raw' }
      let(:directory)  { 'test/directory/structure' }
      let(:filename)   { "./spec/test_files/trash.jpg" }

      def expect_post_with_raw_parameters(tag: false)
        file = double
        expect(File).to receive(:open).and_return(file)
        parameters = {
          'raw.directory'=>instance_of(String),
          'raw.asset1'=>file,
          'raw.asset1.filename'=>instance_of(String),
        }
        parameters['raw.tag'] = instance_of(String) if tag
        expect(api.connection).to receive(:post).with(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
      end

      it 'sends :post components with raw parameters to the NexusConnection instance' do
        expect_post_with_raw_parameters
        api.upload_raw_component(filename: filename, directory: directory, repository: repository)
      end

      it 'sends the repo in the team config when not specified' do
        expect_post_with_raw_parameters
        allow(team_config).to receive(:raw_repository).and_return(repository)
        api.upload_raw_component(filename: filename, directory: directory)
      end

      it 'sends the repo in the team config when nil is specified' do
        expect_post_with_raw_parameters
        allow(team_config).to receive(:raw_repository).and_return(repository)
        api.upload_raw_component(filename: filename, directory: directory, repository: nil)
      end

      it 'a passed in repo overrides the default in the team config' do
        expect_post_with_raw_parameters
        allow(team_config).to receive(:raw_repository).and_return('repo_to_override')
        api.upload_raw_component(filename: filename, directory: directory, repository: repository)
      end

      it 'adds a tag to the parameter list when specified' do
        expect_post_with_raw_parameters(tag: true)
        api.upload_raw_component(filename: filename, directory: directory, repository: repository, tag: tag)
      end
    end


    describe '#upload_rubygems_component' do
      let(:repository) { 'hosted-gems' }
      let(:filename)   { "./spec/test_files/flight_check-0.0.2.gem" }

      def expect_post_with_rubygems_parameters(tag: false)
        file = double
        expect(File).to receive(:open).and_return(file)
        parameters = { 'rubygems.asset'=>file }
        parameters['rubygems.tag'] = instance_of(String) if tag
        expect(api.connection).to receive(:post).with(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
      end

      it 'sends :post components with rubygems parameters to the NexusConnection instance' do
        expect_post_with_rubygems_parameters
        api.upload_rubygems_component(filename: filename, repository: repository)
      end

      it 'sends the repo in the team config when not specified' do
        expect_post_with_rubygems_parameters
        allow(team_config).to receive(:rubygems_repository).and_return(repository)
        api.upload_rubygems_component(filename: filename)
      end

      it 'sends the repo in the team config when nil is specified' do
        expect_post_with_rubygems_parameters
        allow(team_config).to receive(:rubygems_repository).and_return(repository)
        api.upload_rubygems_component(filename: filename, repository: nil)
      end

      it 'a passed in repo overrides the default in the team config' do
        expect_post_with_rubygems_parameters
        allow(team_config).to receive(:rubygems_repository).and_return('repo_to_override')
        api.upload_rubygems_component(filename: filename, repository: repository)
      end

      it 'adds a tag to the parameter list when specified' do
        expect_post_with_rubygems_parameters(tag: true)
        api.upload_rubygems_component(filename: filename, repository: repository, tag: tag)
      end
    end


    describe '#upload_yum_component' do
      let(:repository) { 'yum-internal' }
      let(:directory)  { 'test/directory/structure' }
      let(:filename)   { "./spec/test_files/ebtables-2.0.10-16.el7.x86_64.rpm" }

      def expect_post_with_yum_parameters(tag: false)
        file = double
        expect(File).to receive(:open).and_return(file)
        parameters = {
          'yum.directory'=>instance_of(String),
          'yum.asset'=>file,
          'yum.asset.filename'=>instance_of(String),
        }
        parameters['yum.tag'] = instance_of(String) if tag
        expect(api.connection).to receive(:post).with(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
      end

      it 'sends :post components with yum parameters to the NexusConnection instance' do
        expect_post_with_yum_parameters
        api.upload_yum_component(filename: filename, directory: directory, repository: repository)
      end

      it 'sends the repo in the team config when not specified' do
        expect_post_with_yum_parameters
        allow(team_config).to receive(:yum_repository).and_return(repository)
        api.upload_yum_component(filename: filename, directory: directory)
      end

      it 'sends the repo in the team config when nil is specified' do
        expect_post_with_yum_parameters
        allow(team_config).to receive(:yum_repository).and_return(repository)
        api.upload_yum_component(filename: filename, directory: directory, repository: repository)
      end

      it 'a passed in repo overrides the default in the team config' do
        expect_post_with_yum_parameters
        allow(team_config).to receive(:yum_repository).and_return('repo_to_override')
        api.upload_yum_component(filename: filename, directory: directory, repository: repository)
      end

      it 'adds a tag to the parameter list when specified' do
        expect_post_with_yum_parameters(tag: true)
        api.upload_yum_component(filename: filename, directory: directory, repository: repository, tag: tag)
      end
    end


    describe '#list_component' do
      it 'sends :get_response from components with a component ID to the NexusConnection instance' do
        expect(api.connection).to receive(:get_response).with(endpoint: 'components/id')
        api.list_component(id: 'id')
      end
    end
  end
end