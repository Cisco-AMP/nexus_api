require 'lib/setup_api'

RSpec.shared_examples 'a create hosted repository command' do
  it 'sends a post to create a repo' do
    url = "#{BASE_URL}/beta/repositories/#{repo_type}/hosted"
    stub_request(:post, url)
      .with(body: hash_including({'name' => name}))
      .with(headers: { 'Content-Type'=>'application/json' })
    expect(create_command).to be(true)
    expect(a_request(:post, url)).to have_been_made
  end
end

RSpec.describe NexusAPI do
  let(:name) { 'name' }

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

    describe '#create_repository_docker_hosted' do
      let(:port) { 123 }

      it_behaves_like 'a create hosted repository command' do
        let(:repo_type) { 'docker' }
        let(:create_command) { api.create_repository_docker_hosted(name: name, port: port) }
      end
    end

    describe '#create_repository_maven_hosted' do
      it_behaves_like 'a create hosted repository command' do
        let(:repo_type) { 'maven' }
        let(:create_command) { api.create_repository_maven_hosted(name: name) }
      end
    end

    describe '#create_repository_npm_hosted' do
      it_behaves_like 'a create hosted repository command' do
        let(:repo_type) { 'npm' }
        let(:create_command) { api.create_repository_npm_hosted(name: name) }
      end
    end

    describe '#create_repository_pypi_hosted' do
      it_behaves_like 'a create hosted repository command' do
        let(:repo_type) { 'pypi' }
        let(:create_command) { api.create_repository_pypi_hosted(name: name) }
      end
    end

    describe '#create_repository_yum_hosted' do
      let(:depth) { 2 }

      it_behaves_like 'a create hosted repository command' do
        let(:repo_type) { 'yum' }
        let(:create_command) { api.create_repository_yum_hosted(name: name, depth: depth) }
      end
    end
  end
end
