require 'lib/setup_api'

RSpec.describe NexusAPI do
  describe 'Privileges Endpoint' do
    include_context 'setup NexusAPI::API'

    let(:privilege_id) { 'privilege_id' }

    describe '#list_privileges' do
      it 'sends a get to /beta/security/privileges' do
        url = "#{BASE_URL}/beta/security/privileges"
        stub_request(:get, url)
          .with(headers: { 'Content-Type'=>'application/json' })
        api.list_privileges
        expect(a_request(:get, url)).to have_been_made
      end
    end

    describe '#list_privilege' do
      it 'sends a get to /beta/security/privileges/{privilegeId}' do
        url = "#{BASE_URL}/beta/security/privileges/#{privilege_id}"
        stub_request(:get, url)
          .with(headers: { 'Content-Type'=>'application/json' })
        api.list_privilege(privilege_id: privilege_id)
        expect(a_request(:get, url)).to have_been_made
      end
    end

    describe '#delete_privilege' do
      it 'sends a delete to /beta/security/privileges/{privilegeId}' do
        url = "#{BASE_URL}/beta/security/privileges/#{privilege_id}"
        stub_request(:delete, url)
          .with(headers: { 'Content-Type'=>'application/json' })
        api.delete_privilege(privilege_id: privilege_id)
        expect(a_request(:delete, url)).to have_been_made
      end
    end

    describe '#create_privilege_repository_view' do
      let(:name) { 'name' }
      let(:description) { 'description' }
      let(:actions) { ['action1', 'action2'] }
      let(:format) { 'format' }
      let(:repository) { 'repository' }

      it 'sends a post to /beta/security/privileges/repository-view with required info' do
        url = "#{BASE_URL}/beta/security/privileges/repository-view"
        stub_request(:post, url)
          .with(body: {
            'name' => name,
            'description' => description,
            'actions' => actions,
            'format' => format,
            'repository' => repository
          }).with(headers: { 'Content-Type'=>'application/json' })
        api.create_privilege_repository_view(
          name: name,
          description: description,
          actions: actions,
          format: format,
          repository: repository
        )
        expect(a_request(:post, url)).to have_been_made
      end

      it 'sends a post to /beta/security/privileges/repository-view with a default description' do
        url = "#{BASE_URL}/beta/security/privileges/repository-view"
        stub_request(:post, url)
          .with(body: {
            'name' => name,
            'description' => nil,
            'actions' => actions,
            'format' => format,
            'repository' => repository
          }).with(headers: { 'Content-Type'=>'application/json' })
        api.create_privilege_repository_view(
          name: name,
          actions: actions,
          format: format,
          repository: repository
        )
        expect(a_request(:post, url)).to have_been_made
      end

      it 'sends a post to /beta/security/privileges/repository-view with a default action' do
        url = "#{BASE_URL}/beta/security/privileges/repository-view"
        stub_request(:post, url)
          .with(body: {
            'name' => name,
            'description' => description,
            'actions' => ['READ'],
            'format' => format,
            'repository' => repository
          }).with(headers: { 'Content-Type'=>'application/json' })
        api.create_privilege_repository_view(
          name: name,
          description: description,
          format: format,
          repository: repository
        )
        expect(a_request(:post, url)).to have_been_made
      end

      it 'sends a post to /beta/security/privileges/repository-view with a default format' do
        url = "#{BASE_URL}/beta/security/privileges/repository-view"
        stub_request(:post, url)
          .with(body: {
            'name' => name,
            'description' => description,
            'actions' => actions,
            'format' => '*',
            'repository' => repository
          }).with(headers: { 'Content-Type'=>'application/json' })
        api.create_privilege_repository_view(
          name: name,
          description: description,
          actions: actions,
          repository: repository
        )
        expect(a_request(:post, url)).to have_been_made
      end

      it 'sends a post to /beta/security/privileges/repository-view with a default repository' do
        url = "#{BASE_URL}/beta/security/privileges/repository-view"
        stub_request(:post, url)
          .with(body: {
            'name' => name,
            'description' => description,
            'actions' => actions,
            'format' => format,
            'repository' => '*'
          }).with(headers: { 'Content-Type'=>'application/json' })
        api.create_privilege_repository_view(
          name: name,
          description: description,
          actions: actions,
          format: format,
        )
        expect(a_request(:post, url)).to have_been_made
      end
    end
  end
end
