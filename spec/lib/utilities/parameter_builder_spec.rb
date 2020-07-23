require 'utilities/parameter_builder'

RSpec.shared_examples 'a base parameter set' do
  it 'configures a name' do
    expect(parameters['name']).to eq(repo_name)
  end

  it 'uses an allow_once policy by default' do
    expect(parameters['storage']['writePolicy']).to eq(allow_once)
  end

  it 'configures a write policy' do
    expect(overloaded_parameters['storage']['writePolicy']).to eq(policy)
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
      expect(parameters['docker']['httpPort']).to eq(port)
    end
  end

  describe '.docker_proxy' do
    let(:url) { 'url' }

    before(:each) do
      @result = NexusAPI::ParameterBuilder.docker_proxy(repo_name, url, {})
    end

    it 'provides default options' do
      expect(@result).not_to eq({})
    end

    it 'sets a name' do
      expect(@result['name']).to eq(repo_name)
    end

    it 'sets a url' do
      expect(@result['proxy']['remoteUrl']).to eq(url)
    end

    it 'can override the default options' do
      result = NexusAPI::ParameterBuilder.docker_proxy(repo_name, url, {'online' => false})
      expect(@result['online']).to eq(true)
      expect(result['online']).to eq(false)
    end

    it 'can partially override the default options' do
      result = NexusAPI::ParameterBuilder.docker_proxy(repo_name, url, {'docker' => {'v1Enabled' => true}})
      expect(@result['docker']['v1Enabled']).to eq(false)
      expect(@result['docker']['forceBasicAuth']).to eq(true)
      expect(result['docker']['v1Enabled']).to eq(true)
      expect(result['docker']['forceBasicAuth']).to eq(true)
    end

    it 'can add new options' do
      result = NexusAPI::ParameterBuilder.docker_proxy(repo_name, url, {'newOption' => true})
      expect(@result['newOption']).to be_nil
      expect(result['newOption']).to eq(true)
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
      expect(@parameters['maven']['versionPolicy']).to eq(release)
    end

    it 'uses a strict policy by default' do
      expect(@parameters['maven']['layoutPolicy']).to eq(strict)
    end

    it 'configures a version policy' do
      parameters = NexusAPI::ParameterBuilder.maven_hosted(repo_name, version_policy: policy)
      expect(parameters['maven']['versionPolicy']).to eq(policy)
    end

    it 'configures a layout policy' do
      parameters = NexusAPI::ParameterBuilder.maven_hosted(repo_name, layout_policy: policy)
      expect(parameters['maven']['layoutPolicy']).to eq(policy)
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

  describe '.raw_hosted' do
    it_behaves_like 'a base parameter set' do
      let(:parameters) { NexusAPI::ParameterBuilder.raw_hosted(repo_name) }
      let(:overloaded_parameters) do
        NexusAPI::ParameterBuilder.raw_hosted(repo_name, write_policy: policy)
      end
    end
  end

  describe '.rubygems_hosted' do
    it_behaves_like 'a base parameter set' do
      let(:parameters) { NexusAPI::ParameterBuilder.rubygems_hosted(repo_name) }
      let(:overloaded_parameters) do
        NexusAPI::ParameterBuilder.rubygems_hosted(repo_name, write_policy: policy)
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
      expect(@parameters['yum']['repodataDepth']).to eq(depth)
    end

    it 'uses a strict policy by default' do
      expect(@parameters['yum']['deployPolicy']).to eq(strict)
    end

    it 'configures a deploy policy' do
      parameters = NexusAPI::ParameterBuilder.yum_hosted(repo_name, depth, deploy_policy: policy)
      expect(parameters['yum']['deployPolicy']).to eq(policy)
    end
  end
end
