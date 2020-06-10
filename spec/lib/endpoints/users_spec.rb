require 'lib/setup_api'

RSpec.describe NexusAPI do
  describe 'Users Endpoint' do
    include_context 'setup NexusAPI::API'

    let(:user_id) { 'user_id' }

    describe '#list_users' do
      it 'sends a get to /beta/security/users' do
        url = "#{BASE_URL}/beta/security/users"
        stub_request(:get, url)
          .with(headers: { 'Content-Type'=>'application/json' })
        api.list_users
        expect(a_request(:get, url)).to have_been_made
      end
    end

    describe '#create_user' do
      let(:first_name) { 'first_name' }
      let(:last_name) { 'last_name' }
      let(:email) { 'email' }
      let(:password) { 'password' }
      let(:roles) { ['role'] }

      it 'sends a post to /beta/security/users with required info' do
        url = "#{BASE_URL}/beta/security/users"
        stub_request(:post, url)
          .with(body: {
            'userId' => user_id,
            'firstName' => first_name,
            'lastName' => last_name,
            'emailAddress' => email,
            'password' => password,
            'roles' => roles,
            'status' => 'active'
          }).with(headers: { 'Content-Type'=>'application/json' })
        api.create_user(
          user_id: user_id,
          first_name: first_name,
          last_name: last_name,
          email: email,
          password: password,
          roles: roles
        )
        expect(a_request(:post, url)).to have_been_made
      end
    end

    describe '#delete_user' do
      it 'sends a delete to /beta/security/users/{userId}' do
        url = "#{BASE_URL}/beta/security/users/#{user_id}"
        stub_request(:delete, url)
          .with(headers: { 'Content-Type'=>'application/json' })
        api.delete_user(user_id: user_id)
        expect(a_request(:delete, url)).to have_been_made
      end
    end
  end
end
