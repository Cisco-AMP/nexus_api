require 'utilities/parameter_builder'

RSpec.shared_examples 'a group repository' do
  let(:new_blobstore) { 'not_default' }
  let(:members) { ['member1', 'member2'] }

  before(:each) do
    @default = NexusAPI::ParameterBuilder.send(method, repo_name, members, {})
  end

  it 'provides default options' do
    expect(@default).to be_a(Hash)
    expect(@default).not_to eq({})
  end

  it 'sets a name' do
    expect(@default['name']).to eq(repo_name)
  end

  it 'sets group members' do
    expect(@default['group']['memberNames']).to eq(members)
  end

  it 'can override the default options' do
    custom = NexusAPI::ParameterBuilder.send(method, repo_name, members, {'online' => false})
    expect(@default['online']).to eq(true)
    expect(custom['online']).to eq(false)
  end

  it 'can partially override the default options' do
    custom = NexusAPI::ParameterBuilder.send(method, repo_name, members, {'storage' => {'blobStoreName' => new_blobstore}})
    expect(@default['storage']['blobStoreName']).to eq('default')
    expect(@default['storage']['strictContentTypeValidation']).to eq(true)
    expect(custom['storage']['blobStoreName']).to eq(new_blobstore)
    expect(custom['storage']['strictContentTypeValidation']).to eq(true)
  end

  it 'can add new options' do
    custom = NexusAPI::ParameterBuilder.send(method, repo_name, members, {'newOption' => 9999})
    expect(@default['newOption']).to be_nil
    expect(custom['newOption']).to eq(9999)
  end
end

RSpec.shared_examples 'a hosted repository' do
  let(:new_blobstore) { 'not_default' }
  let(:policies) { ['policy1', 'policy2'] }

  before(:each) do
    @default = NexusAPI::ParameterBuilder.send(method, repo_name, {})
  end

  it 'provides default options' do
    expect(@default).to be_a(Hash)
    expect(@default).not_to eq({})
  end

  it 'can override the default options' do
    custom = NexusAPI::ParameterBuilder.send(method, repo_name, {'cleanup' => {'policyNames' => policies}})
    expect(@default['cleanup']['policyNames']).to eq([])
    expect(custom['cleanup']['policyNames']).to eq(policies)
  end

  it 'can partially override the default options' do
    custom = NexusAPI::ParameterBuilder.send(method, repo_name, {'storage' => {'blobStoreName' => new_blobstore}})
    expect(@default['storage']['blobStoreName']).to eq('default')
    expect(@default['storage']['strictContentTypeValidation']).to eq(true)
    expect(custom['storage']['blobStoreName']).to eq(new_blobstore)
    expect(custom['storage']['strictContentTypeValidation']).to eq(true)
  end

  it 'can add new options' do
    custom = NexusAPI::ParameterBuilder.send(method, repo_name, {'newOption' => {'result' => true}})
    expect(@default['newOption']).to be_nil
    expect(custom['newOption']).to eq({'result' => true})
  end
end

RSpec.shared_examples 'a proxy repository' do
  let(:url) { 'url' }

  before(:each) do
    @default = NexusAPI::ParameterBuilder.send(method, repo_name, url, {})
  end

  it 'provides default options' do
    expect(@default).to be_a(Hash)
    expect(@default).not_to eq({})
  end

  it 'sets a name' do
    expect(@default['name']).to eq(repo_name)
  end

  it 'sets a url' do
    expect(@default['proxy']['remoteUrl']).to eq(url)
  end

  it 'can override the default options' do
    custom = NexusAPI::ParameterBuilder.send(method, repo_name, url, {'online' => false})
    expect(@default['online']).to eq(true)
    expect(custom['online']).to eq(false)
  end

  it 'can partially override the default options' do
    custom = NexusAPI::ParameterBuilder.send(method, repo_name, url, {'httpClient' => {'blocked' => true}})
    expect(@default['httpClient']['blocked']).to eq(false)
    expect(@default['httpClient']['autoBlock']).to eq(true)
    expect(custom['httpClient']['blocked']).to eq(true)
    expect(custom['httpClient']['autoBlock']).to eq(true)
  end

  it 'can add new options' do
    custom = NexusAPI::ParameterBuilder.send(method, repo_name, url, {'newOption' => true})
    expect(@default['newOption']).to be_nil
    expect(custom['newOption']).to eq(true)
  end
end



RSpec.describe NexusAPI::ParameterBuilder do
  let(:repo_name) { 'repo_name' }

  # Docker
  describe '.docker_group' do
    it_behaves_like 'a group repository' do
      let(:method) { :docker_group }
    end
  end

  describe '.docker_hosted' do
    it_behaves_like 'a hosted repository' do
      let(:method) { :docker_hosted }
    end
  end

  describe '.docker_proxy' do
    it_behaves_like 'a proxy repository' do
      let(:method) { :docker_proxy }
    end
  end

  # Maven
  describe '.maven_group' do
    it_behaves_like 'a group repository' do
      let(:method) { :maven_group }
    end
  end

  describe '.maven_hosted' do
    it_behaves_like 'a hosted repository' do
      let(:method) { :maven_hosted }
    end
  end

  describe '.maven_proxy' do
    it_behaves_like 'a proxy repository' do
      let(:method) { :maven_proxy }
    end
  end

  # NPM
  describe '.npm_group' do
    it_behaves_like 'a group repository' do
      let(:method) { :npm_group }
    end
  end

  describe '.npm_hosted' do
    it_behaves_like 'a hosted repository' do
      let(:method) { :npm_hosted }
    end
  end

  describe '.npm_proxy' do
    it_behaves_like 'a proxy repository' do
      let(:method) { :npm_proxy }
    end
  end

  # Pypi
  describe '.pypi_group' do
    it_behaves_like 'a group repository' do
      let(:method) { :pypi_group }
    end
  end

  describe '.pypi_hosted' do
    it_behaves_like 'a hosted repository' do
      let(:method) { :pypi_hosted }
    end
  end

  describe '.pypi_proxy' do
    it_behaves_like 'a proxy repository' do
      let(:method) { :pypi_proxy }
    end
  end

  # Raw
  describe '.raw_group' do
    it_behaves_like 'a group repository' do
      let(:method) { :raw_group }
    end
  end

  describe '.raw_hosted' do
    it_behaves_like 'a hosted repository' do
      let(:method) { :raw_hosted }
    end
  end

  describe '.raw_proxy' do
    it_behaves_like 'a proxy repository' do
      let(:method) { :raw_proxy }
    end
  end

  # Rubygems
  describe '.rubygems_group' do
    it_behaves_like 'a group repository' do
      let(:method) { :rubygems_group }
    end
  end

  describe '.rubygems_hosted' do
    it_behaves_like 'a hosted repository' do
      let(:method) { :rubygems_hosted }
    end
  end

  describe '.rubygems_proxy' do
    it_behaves_like 'a proxy repository' do
      let(:method) { :rubygems_proxy }
    end
  end

  # Yum
  describe '.yum_group' do
    it_behaves_like 'a group repository' do
      let(:method) { :yum_group }
    end
  end

  describe '.yum_hosted' do
    it_behaves_like 'a hosted repository' do
      let(:method) { :yum_hosted }
    end
  end

  describe '.yum_proxy' do
    it_behaves_like 'a proxy repository' do
      let(:method) { :yum_proxy }
    end
  end
end
