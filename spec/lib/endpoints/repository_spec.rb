require 'lib/setup_api'

RSpec.shared_examples 'a group repository' do
  it 'sends a post to create a repo' do
    url = "#{BASE_URL}/beta/repositories/#{repo_type}/group"
    stub_request(:post, url)
      .with(body: hash_including({'name' => name, 'group' => anything}))
      .with(headers: { 'Content-Type'=>'application/json' })
    expect(create_command).to be(true)
    expect(a_request(:post, url)).to have_been_made
  end
end

RSpec.shared_examples 'a hosted repository' do
  it 'sends a post to create a repo' do
    url = "#{BASE_URL}/beta/repositories/#{repo_type}/hosted"
    stub_request(:post, url)
      .with(body: hash_including({'name' => name}))
      .with(headers: { 'Content-Type'=>'application/json' })
    expect(create_command).to be(true)
    expect(a_request(:post, url)).to have_been_made
  end
end

RSpec.shared_examples 'a proxy repository' do
  it 'sends a post to create a repo' do
    url = "#{BASE_URL}/beta/repositories/#{repo_type}/proxy"
    stub_request(:post, url)
      .with(body: hash_including({'name' => name, 'proxy' => {
        'contentMaxAge'=>1440,'metadataMaxAge'=>1440,'remoteUrl'=>'remote_url'
      }})).with(headers: { 'Content-Type'=>'application/json' })
    expect(create_command).to be(true)
    expect(a_request(:post, url)).to have_been_made
  end
end

RSpec.describe NexusAPI do
  let(:name) { 'name' }
  let(:members) { ['member1', 'member2'] }
  let(:remote_url) { 'remote_url' }

  describe 'Repositories Endpoint' do
    include_context 'setup NexusAPI::API'

    describe '#list_repositories' do
      it 'send a get to beta/repositories' do
        url = "#{BASE_URL}/beta/repositories"
        stub_request(:get, url)
          .with(headers: { 'Content-Type'=>'application/json' })
        api.list_repositories
        expect(a_request(:get, url)).to have_been_made
      end
    end

    describe '#list_repository_names' do
      it 'expects an array of hashes and returns an array of names' do
        hashes = [{'name'=>'repo1'}, {'name'=>'repo2'}]
        names  = ['repo1', 'repo2']
        expect(api).to receive(:list_repositories).and_return(hashes)
        expect(api.list_repository_names).to eq(names)
      end
    end

    describe '#delete_repository' do
      let(:repo) { 'repo' }

      it 'sends a delete to beta/repositories with a repository name' do
        url = "#{BASE_URL}/beta/repositories/#{repo}"
        stub_request(:delete, url)
          .with(headers: { 'Content-Type'=>'application/json' })
        expect(api.delete_repository(name: repo)).to be(true)
        expect(a_request(:delete, url)).to have_been_made
      end
    end

    # Docker
    describe '#create_repository_docker_group' do
      it_behaves_like 'a group repository' do
        let(:repo_type) { 'docker' }
        let(:create_command) { api.create_repository_docker_group(name: name, members: members) }
      end
    end

    describe '#create_repository_docker_hosted' do
      it_behaves_like 'a hosted repository' do
        let(:repo_type) { 'docker' }
        let(:create_command) { api.create_repository_docker_hosted(name: name) }
      end
    end

    describe '#create_repository_docker_proxy' do
      it_behaves_like 'a proxy repository' do
        let(:repo_type) { 'docker' }
        let(:create_command) { api.create_repository_docker_proxy(name: name, remote_url: remote_url) }
      end
    end

    # Maven
    describe '#create_repository_maven_group' do
      it_behaves_like 'a group repository' do
        let(:repo_type) { 'maven' }
        let(:create_command) { api.create_repository_maven_group(name: name, members: members) }
      end
    end

    describe '#create_repository_maven_hosted' do
      it_behaves_like 'a hosted repository' do
        let(:repo_type) { 'maven' }
        let(:create_command) { api.create_repository_maven_hosted(name: name) }
      end
    end

    describe '#create_repository_maven_proxy' do
      it_behaves_like 'a proxy repository' do
        let(:repo_type) { 'maven' }
        let(:create_command) { api.create_repository_maven_proxy(name: name, remote_url: remote_url) }
      end
    end

    # NPM
    describe '#create_repository_npm_group' do
      it_behaves_like 'a group repository' do
        let(:repo_type) { 'npm' }
        let(:create_command) { api.create_repository_npm_group(name: name, members: members) }
      end
    end

    describe '#create_repository_npm_hosted' do
      it_behaves_like 'a hosted repository' do
        let(:repo_type) { 'npm' }
        let(:create_command) { api.create_repository_npm_hosted(name: name) }
      end
    end

    describe '#create_repository_npm_proxy' do
      it_behaves_like 'a proxy repository' do
        let(:repo_type) { 'npm' }
        let(:create_command) { api.create_repository_npm_proxy(name: name, remote_url: remote_url) }
      end
    end

    # Pypi
    describe '#create_repository_pypi_group' do
      it_behaves_like 'a group repository' do
        let(:repo_type) { 'pypi' }
        let(:create_command) { api.create_repository_pypi_group(name: name, members: members) }
      end
    end

    describe '#create_repository_pypi_hosted' do
      it_behaves_like 'a hosted repository' do
        let(:repo_type) { 'pypi' }
        let(:create_command) { api.create_repository_pypi_hosted(name: name) }
      end
    end

    describe '#create_repository_pypi_proxy' do
      it_behaves_like 'a proxy repository' do
        let(:repo_type) { 'pypi' }
        let(:create_command) { api.create_repository_pypi_proxy(name: name, remote_url: remote_url) }
      end
    end

    # Raw
    describe '#create_repository_raw_group' do
      it_behaves_like 'a group repository' do
        let(:repo_type) { 'raw' }
        let(:create_command) { api.create_repository_raw_group(name: name, members: members) }
      end
    end

    describe '#create_repository_raw_hosted' do
      it_behaves_like 'a hosted repository' do
        let(:repo_type) { 'raw' }
        let(:create_command) { api.create_repository_raw_hosted(name: name) }
      end
    end

    describe '#create_repository_raw_proxy' do
      it_behaves_like 'a proxy repository' do
        let(:repo_type) { 'raw' }
        let(:create_command) { api.create_repository_raw_proxy(name: name, remote_url: remote_url) }
      end
    end

    # Rubygems
    describe '#create_repository_rubygems_group' do
      it_behaves_like 'a group repository' do
        let(:repo_type) { 'rubygems' }
        let(:create_command) { api.create_repository_rubygems_group(name: name, members: members) }
      end
    end

    describe '#create_repository_rubygems_hosted' do
      it_behaves_like 'a hosted repository' do
        let(:repo_type) { 'rubygems' }
        let(:create_command) { api.create_repository_rubygems_hosted(name: name) }
      end
    end

    describe '#create_repository_rubygems_proxy' do
      it_behaves_like 'a proxy repository' do
        let(:repo_type) { 'rubygems' }
        let(:create_command) { api.create_repository_rubygems_proxy(name: name, remote_url: remote_url) }
      end
    end

    # Yum
    describe '#create_repository_yum_group' do
      it_behaves_like 'a group repository' do
        let(:repo_type) { 'yum' }
        let(:create_command) { api.create_repository_yum_group(name: name, members: members) }
      end
    end

    describe '#create_repository_yum_hosted' do
      it_behaves_like 'a hosted repository' do
        let(:repo_type) { 'yum' }
        let(:create_command) { api.create_repository_yum_hosted(name: name) }
      end
    end

    describe '#create_repository_yum_proxy' do
      it_behaves_like 'a proxy repository' do
        let(:repo_type) { 'yum' }
        let(:create_command) { api.create_repository_yum_proxy(name: name, remote_url: remote_url) }
      end
    end
  end
end
