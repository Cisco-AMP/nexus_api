require 'utilities/parameter_builder'

RSpec.shared_examples 'a base parameter set' do
  it 'configures a name' do
    expect(JSON.parse(parameters)['name']).to eq(repo_name)
  end

  it 'uses an allow_once policy by default' do
    expect(JSON.parse(parameters)['storage']['writePolicy']).to eq(allow_once)
  end

  it 'configures a write policy' do
    expect(JSON.parse(overloaded_parameters)['storage']['writePolicy']).to eq(policy)
  end
end

RSpec.describe NexusAPI::ParameterBuilder do
  let(:allow_once) { NexusAPI::ParameterBuilder::ALLOW_ONCE }
  let(:release) { NexusAPI::ParameterBuilder::RELEASE }
  let(:strict) { NexusAPI::ParameterBuilder::STRICT }
  let(:repo_name) { 'repo_name' }
  let(:policy) { 'policy' }

  describe '.docker_hosted' do
    let(:port) { '123' }

    it_behaves_like 'a base parameter set' do
      let(:parameters) { NexusAPI::ParameterBuilder.docker_hosted(repo_name, port) }
      let(:overloaded_parameters) do
        NexusAPI::ParameterBuilder.docker_hosted(repo_name, port, write_policy: policy)
      end
    end

    it 'configures an HTTPS port' do
      parameters = NexusAPI::ParameterBuilder.docker_hosted(repo_name, port)
      expect(JSON.parse(parameters)['docker']['httpPort']).to eq(port)
    end
  end

  describe '.maven_hosted' do
    it_behaves_like 'a base parameter set' do
      let(:parameters) { NexusAPI::ParameterBuilder.maven_hosted(repo_name) }
      let(:overloaded_parameters) do
        NexusAPI::ParameterBuilder.maven_hosted(repo_name, write_policy: policy)
      end
    end

    before(:each) do
      @parameters = NexusAPI::ParameterBuilder.maven_hosted(repo_name)
    end

    it 'uses a release policy by default' do
      expect(JSON.parse(@parameters)['maven']['versionPolicy']).to eq(release)
    end

    it 'uses a strict policy by default' do
      expect(JSON.parse(@parameters)['maven']['layoutPolicy']).to eq(strict)
    end

    it 'configures a version policy' do
      parameters = NexusAPI::ParameterBuilder.maven_hosted(repo_name, version_policy: policy)
      expect(JSON.parse(parameters)['maven']['versionPolicy']).to eq(policy)
    end

    it 'configures a layout policy' do
      parameters = NexusAPI::ParameterBuilder.maven_hosted(repo_name, layout_policy: policy)
      expect(JSON.parse(parameters)['maven']['layoutPolicy']).to eq(policy)
    end
  end

  describe '.npm_hosted' do
    it_behaves_like 'a base parameter set' do
      let(:parameters) { NexusAPI::ParameterBuilder.npm_hosted(repo_name) }
      let(:overloaded_parameters) do
        NexusAPI::ParameterBuilder.npm_hosted(repo_name, write_policy: policy)
      end
    end
  end

  describe '.pypi_hosted' do
    it_behaves_like 'a base parameter set' do
      let(:parameters) { NexusAPI::ParameterBuilder.pypi_hosted(repo_name) }
      let(:overloaded_parameters) do
        NexusAPI::ParameterBuilder.pypi_hosted(repo_name, write_policy: policy)
      end
    end
  end

  describe '.yum_hosted' do
    let(:depth) { 1 }

    it_behaves_like 'a base parameter set' do
      let(:parameters) { NexusAPI::ParameterBuilder.yum_hosted(repo_name, depth) }
      let(:overloaded_parameters) do
        NexusAPI::ParameterBuilder.yum_hosted(repo_name, depth, write_policy: policy)
      end
    end

    before(:each) do
      @parameters = NexusAPI::ParameterBuilder.yum_hosted(repo_name, depth)
    end

    it 'configures a repodata depth' do
      expect(JSON.parse(@parameters)['yum']['repodataDepth']).to eq(depth)
    end

    it 'uses a strict policy by default' do
      expect(JSON.parse(@parameters)['yum']['deployPolicy']).to eq(strict)
    end

    it 'configures a deploy policy' do
      parameters = NexusAPI::ParameterBuilder.yum_hosted(repo_name, depth, deploy_policy: policy)
      expect(JSON.parse(parameters)['yum']['deployPolicy']).to eq(policy)
    end
  end
end
