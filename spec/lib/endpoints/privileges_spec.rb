require 'lib/setup_api'

RSpec.describe NexusAPI do
  describe 'Privileges Endpoint' do
    include_context 'setup NexusAPI::API'

    describe '#list_privileges' do
      it 'sends a get to /beta/security/privileges' do
        url = "#{BASE_URL}/beta/security/privileges"
        stub_request(:get, url)
          .with(headers: { 'Content-Type'=>'application/json' })
        api.list_privileges
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end
end
